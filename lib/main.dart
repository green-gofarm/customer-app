import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/screens/RFSplashScreen.dart';
import 'package:customer_app/store/AppStore.dart';
import 'package:customer_app/utils/AppTheme.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

AppStore appStore = AppStore();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
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
        home: RFSplashScreen(),
      ),
    );
  }
}
