import 'package:customer_app/fragment/CartFragment.dart';
import 'package:customer_app/screens/FarmstayDetailScreen.dart';
import 'package:customer_app/screens/RoomDetailScreen.dart';
import 'package:customer_app/store/province/province_store.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:customer_app/screens/ActivityDetailScreen.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/screens/SignUpScreen.dart';
import 'package:customer_app/screens/SplashScreen.dart';
import 'package:customer_app/store/auth/auth_store.dart';
import 'package:customer_app/store/tag_category/tag_category_store.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/utils/logger/AppLoggerFilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:logger/logger.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:customer_app/store/AppStore.dart';
import 'package:customer_app/utils/AppTheme.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timeago/src/messages/vi_messages.dart';
import 'package:timeago/timeago.dart' as timeago;

// create instances of AppStore, AuthStore, and Logger
final AppStore appStore = AppStore();
final AuthStore authStore = AuthStore();
final TagCategoryStore tagCategoryStore = TagCategoryStore();
final ProvinceStore provinceStore = ProvinceStore();

final materialAppKey = GlobalKey();
final Logger logger = Logger(
  filter: AppLoggerFilter(),
  printer: PrettyPrinter(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initialize();

  // Toggle dark mode based on user preference
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  // Set language
  timeago.setLocaleMessages('vi', ViMessages());

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return await onWillPop(context);
        },
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'), // English
            const Locale('vi', 'VN'), // Vietnamese
            // Add more locales here
          ],
          locale: const Locale('vi', 'VN'),
          key: materialAppKey,
          scrollBehavior: SBehavior(),
          navigatorKey: navigatorKey,
          title: 'Gofarm',
          debugShowCheckedModeBanner: false,
          theme: AppThemeData.lightTheme,
          darkTheme: AppThemeData.darkTheme,
          themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          initialRoute: RoutePaths.SPLASH.value,
          routes: {
            RoutePaths.SPLASH.value: (context) => SplashScreen(),
            RoutePaths.SIGN_IN.value: (context) => SignInScreen(),
            RoutePaths.SIGN_UP.value: (context) => SignUpScreen(),
            RoutePaths.HOME.value: (context) => HomeScreen(),
            RoutePaths.CART_LIST.value: (context) => CartFragment(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case RouteConstants.FARMSTAY_DETAIL:
                final args = settings.arguments as FarmstayDetailArguments;
                return MaterialPageRoute(
                  builder: (context) => FarmstayDetailScreen(
                    farmstayId: args.farmstayId,
                    onBack: args.onBack,
                  ),
                );
              case RouteConstants.ACTIVITY_DETAIL:
                final args = settings.arguments as ActivityDetailArguments;
                return MaterialPageRoute(
                  builder: (context) => ActivityDetailScreen(
                    farmstayId: args.farmstayId,
                    activityId: args.activityId,
                    defaultDatetime: args.defaultDatetime,
                    onBack: args.onBack,
                  ),
                );
              case RouteConstants.ROOM_DETAIL:
                final args = settings.arguments as RoomDetailArguments;
                return MaterialPageRoute(
                  builder: (context) => RoomDetailScreen(
                    farmstayId: args.farmstayId,
                    roomId: args.roomId,
                    defaultDatetime: args.defaultDatetime,
                    onBack: args.onBack,
                  ),
                );
              default:
                return MaterialPageRoute(builder: (context) => HomeScreen());
            }
          },
          navigatorObservers: [NavigationHistoryObserver()],
        ),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    await SystemNavigator.pop(animated: true);
    return false;
  }
}
