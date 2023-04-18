import 'package:customer_app/screens/SignUpScreen.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/SocialSignInWidget.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/components/RFCommonAppComponent.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFString.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:nb_utils/nb_utils.dart';

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

  void init() async {
    authStore.errorMessage = null;
    final isAuthenticated = await authStore.isAuthenticated();
    if(isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(context, RoutePaths.HOME.value, (route) => false);
      return;
    }
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
        appBar: jsAppBar(context, backWidget: true, homeAction: true),
        body: RFCommonAppComponent(
          title: RFAppName,
          subTitle: RFAppSubTitle,
          cardWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SocialSignInWidget(
                callBack: () {
                  Navigator.pushNamed(context, RoutePaths.SIGN_UP.value);
                },
              ),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
            height: 40,
            padding: EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).copyWith().size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chưa có tài khoản?', style: secondaryTextStyle()),
                TextButton(
                  onPressed: () {
                    SignUpScreen().launch(context);
                  },
                  child: Text('Đăng ký', style: boldTextStyle(size: 14, color: rf_primaryColor)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
