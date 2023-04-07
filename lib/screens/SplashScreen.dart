import 'package:customer_app/main.dart';
import 'package:customer_app/screens/RFHomeScreen.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/utils/RFImages.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/utils/RFColors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> autoSignIn() async {
    try {
      await authStore.signInCustomer(true);
      if (authStore.getUser != null) {
        Navigator.pushReplacementNamed(context, RoutePaths.SPLASH.value);
      } else {
        Navigator.pushReplacementNamed(context, RoutePaths.SIGN_IN.value);
      }
    } catch (e) {
      logger.e("Auto sign in failed", e);
      Navigator.pushReplacementNamed(context, RoutePaths.SIGN_IN.value);
    }
  }

  Future<void> init() async {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);

    await autoSignIn();
    await Future.delayed(Duration(seconds: 2));
    finish(context);
  }

  @override
  void dispose() {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rf_splashBgColor,
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                  boxShape: BoxShape.circle, backgroundColor: rf_splashBgColor),
              width: 250,
              height: 250,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10000),
              ),
              child: ClipOval(
                  child: commonCacheImageWidget(go_ram_logo, 200,
                      fit: BoxFit.cover, alignment: Alignment.center)),
            ),
            if (authStore.isLoading)
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(rf_primaryColor),
                  strokeWidth: 4,
                ),
              ),
          ],
        ).center(),
      ),
    );
  }
}
