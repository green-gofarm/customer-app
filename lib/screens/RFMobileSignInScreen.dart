import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/components/RFCommonAppComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/screens/RFEmailSignInScreen.dart';
import 'package:customer_app/screens/RFResetPasswordScreen.dart';
import 'package:customer_app/screens/RFSignUpScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFString.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/codePicker/country_code_picker.dart';

class RFMobileSignIn extends StatefulWidget {
  @override
  _RFMobileSignInState createState() => _RFMobileSignInState();
}

class _RFMobileSignInState extends State<RFMobileSignIn> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    changeStatusColor(appStore.scaffoldBackground!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RFCommonAppComponent(
          title: RFAppName,
          subTitle: RFAppSubTitle,
          cardWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              socialLoginWidget(
                context,
                title1: "Chưa có tài khoản? ",
                title2: "Đăng ký",
                callBack: () {
                  RFSignUpScreen().launch(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
