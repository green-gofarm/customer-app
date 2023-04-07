import 'package:customer_app/screens/RFHomeScreen.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/screens/SignUpScreen.dart';
import 'package:customer_app/screens/SplashScreen.dart';
import 'package:customer_app/screens/auth_wrapper.dart';
import 'package:customer_app/store/auth/auth_store.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/utils/logger/AppLoggerFilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:customer_app/store/AppStore.dart';
import 'package:customer_app/utils/AppTheme.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// create instances of AppStore, AuthStore, and Logger
final AppStore appStore = AppStore();
final AuthStore authStore = AuthStore();
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

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Observer(
      builder: (_) => MaterialApp(
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'Gofarm',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        initialRoute: RoutePaths.AUTH_WRAPPER.value,
        routes: {
          RoutePaths.AUTH_WRAPPER.value: (context) => AuthWrapper(),
          RoutePaths.SPLASH.value: (context) => SplashScreen(),
          RoutePaths.SIGN_IN.value: (context) => SignInScreen(),
          RoutePaths.SIGN_UP.value: (context) => SignUpScreen(),
          RoutePaths.HOME.value: (context) => RFHomeScreen(),
        },
      ),
    );
  }
}
