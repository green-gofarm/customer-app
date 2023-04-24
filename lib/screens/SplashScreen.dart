import 'package:customer_app/components/NotificationHandler.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/screens/SelectCityScreen.dart';
import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/utils/RFImages.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/StorageUtil.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NotificationHandler _notificationHandler = NotificationHandler();


  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> autoSignIn() async {
    try {
      final token = await AuthService.getFirebaseAuthToken(false);
      if (token != null) {
        await authStore.signInCustomer(true);
      }
    } catch (e) {
      logger.e("Auto sign in failed", e);
    }
  }

  Future<void> handleNavigate() async {
    final storedCities = await StorageUtil.getCities();
    final storedHashtags = await StorageUtil.getHashtags();

    if (storedCities.isNotEmpty && storedHashtags.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePaths.HOME.value, (route) => false);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelectCityScreen()));
    }
  }

  Future<void> init() async {
    await autoSignIn();
    await handleNavigate();
    await _notificationHandler.setupFirebaseMessaging();
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
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: rf_primaryColor,
              strokeWidth: 2,
            ),
          ),
        ],
      ).center(),
    );
  }
}
