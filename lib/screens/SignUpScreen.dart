import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/utils/JSWidget.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/SocialSignUpWidget.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onSignedInCallback;

  SignUpScreen({this.onSignedInCallback});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    authStore.errorMessage = null;
    final isAuthenticated = await authStore.isAuthenticated();
    if (isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePaths.HOME.value, (route) => false);
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SocialSignUpWidget(
                callBack: () {
                  if (widget.onSignedInCallback != null) {
                    widget.onSignedInCallback!();
                    finish(context);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RoutePaths.HOME.value, (route) => false);
                  }
                },
              ),
              Row(
                children: [
                  Container(
                      width: context.width(),
                      height: 1,
                      color: gray.withOpacity(0.2))
                      .expand(),
                  8.width,
                  Text("&", style: secondaryTextStyle()),
                  8.width,
                  Container(
                      width: context.width(),
                      height: 1,
                      color: gray.withOpacity(0.2))
                      .expand(),
                ],
              ),
              8.height,
              RichTextWidget(
                list: [
                  TextSpan(
                    text: 'Bằng cách Đăng ký, bạn đồng ý với ',
                    style: primaryTextStyle(size: 12),
                  ),
                  TextSpan(
                      text: ' Điều khoản Dịch vụ ',
                      style: primaryTextStyle(
                          size: 12,
                          color: rf_primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(text: ' và ', style: primaryTextStyle(size: 12)),
                  TextSpan(
                      text: ' công nhận rằng ',
                      style: primaryTextStyle(size: 12)),
                  TextSpan(
                      text: 'Chính sách Bảo mật ',
                      style: primaryTextStyle(
                          size: 12,
                          color: rf_primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                      text: ' của chúng tôi áp dụng cho bạn',
                      style: primaryTextStyle(size: 12)),
                ],
                textAlign: TextAlign.center,
                maxLines: 3,
              )
                  .paddingOnly(top: 0, bottom: 16, left: 12, right: 12)
                  .visible(true),
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
                Text('Đã có tài khoản?', style: secondaryTextStyle()),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(
                          onSignedInCallback: widget.onSignedInCallback,
                        ),
                      ),
                    );
                  },
                  child: Text('Đăng nhập',
                      style: boldTextStyle(size: 14, color: rf_primaryColor)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
