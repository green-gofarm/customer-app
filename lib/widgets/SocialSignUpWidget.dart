import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/ICImages.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/GoogleButtonWidget.dart';
import 'package:customer_app/widgets/LoadingMixin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';

const BUTTON_TEXT = "Đăng ký với Google";
const CTA_SUBTITLE = "Đăng ký";

class SocialSignUpWidget extends StatefulWidget {
  final Function? callBack;

  const SocialSignUpWidget({Key? key, this.callBack}) : super(key: key);

  @override
  _SocialSignUpWidgetState createState() => _SocialSignUpWidgetState();
}

class _SocialSignUpWidgetState extends State<SocialSignUpWidget>
    with LoadingMixin {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> handleSignUp() async {
    try {
      setState(() {
        setLoading(true);
        authStore.resetStore();
      });
      final UserCredential userCredential =
          await AuthService.signInWithGoogle();

      if (userCredential.user != null) {
        final String? token = await AuthService.getFirebaseAuthToken(false);
        if (token != null) {
          await authStore.signUpCustomer(token);
        }

        if (authStore.user != null) {
          //Refresh to get new token after sign up success;
          AuthService.getFirebaseAuthToken(true);
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.HOME.value, (route) => false);
        }
      }
    } catch (error) {
      logger.e("Social sign up", error);
    } finally {
      setState(() {
        setLoading(false);
      });
      if (authStore.user == null) {
        await AuthService.signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: appStore.isDarkModeOn ? scaffoldDarkColor : mainBgColor),
        Container(
          color: rf_primaryColor.withOpacity(0.05),
          height: 250,
          child: Align(
              alignment: Alignment.center, child: Image.asset(big_logo)),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CTA_SUBTITLE, style: boldTextStyle(size: 16)),
              12.height,
              Text("Tạo tài khoản gofarm và đăng nhập.", style: secondaryTextStyle()),
              12.height,
              GoogleButtonWidget(
                context,
                isLoading: isLoading,
                text: BUTTON_TEXT,
              ).onTap(() async {
                await handleSignUp();
              }),
              16.height,
              if (mounted && authStore.errorMessage != null &&
                  authStore.errorMessage!.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        text: authStore.errorMessage,
                        style: primaryTextStyle(
                          size: 14,
                          height: 0,
                          color: bannedTextColor,
                        )),
                  ),
                ),
              16.height,
            ],
          ),
        )
      ],
    );
  }
}
