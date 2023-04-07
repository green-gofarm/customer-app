import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/SocialSignInWidget.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/components/RFCommonAppComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFString.dart';
import 'package:customer_app/utils/RFWidget.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
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
              SocialSignInWidget(
                callBack: () {
                  Navigator.pushReplacementNamed(context, RoutePaths.SIGN_UP.value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
