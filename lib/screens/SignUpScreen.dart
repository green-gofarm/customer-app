import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/SocialSignInWidget.dart';
import 'package:customer_app/widgets/SocialSignUpWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/components/RFCommonAppComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFString.dart';
import 'package:customer_app/utils/RFWidget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

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
              SocialSignUpWidget(
                context,
                callBack: () {
                  Navigator.pushReplacementNamed(context, RoutePaths.HOME.value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
