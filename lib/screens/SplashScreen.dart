import 'package:customer_app/main.dart';
import 'package:customer_app/services/auth_service.dart';
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
  Future<void>? _autoSignInFuture;

  @override
  void initState() {
    super.initState();
    _autoSignInFuture = autoSignIn();
    init();
  }

  Future<void> autoSignIn() async {
    RoutePaths path = RoutePaths.SIGN_IN;

    try {
      final token = await AuthService.getFirebaseAuthToken(false);

      if (token != null) {
        await authStore.signInCustomer(true);
      }

      if (authStore.getUser != null) {
        path = RoutePaths.HOME;
      }
    } catch (e) {
      path = RoutePaths.SIGN_IN;
      logger.e("Auto sign in failed", e);
    } finally {
      Navigator.pushNamedAndRemoveUntil(context, path.value, (route) => false);
    }
  }

  Future<void> init() async {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rf_splashBgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: boxDecorationWithRoundedCorners(
                boxShape: BoxShape.circle, backgroundColor: rf_splashBgColor),
            width: 150,
            height: 150,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10000),
            ),
            child: ClipOval(
                child: commonCacheImageWidget(go_ram_logo, 100,
                    fit: BoxFit.cover, alignment: Alignment.center)),
          ),
          FutureBuilder<void>(
            future: _autoSignInFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    color: rf_primaryColor,
                    strokeWidth: 2,
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ).center(),
    );
  }
}
