import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/GoogleButtonWidget.dart';
import 'package:customer_app/widgets/LoadingMixin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';

const BUTTON_TEXT = "Đăng ký với Google";
const CTA_TITLE = "Đã có tài khoản?";
const CTA_SUBTITLE = "Đăng nhập";

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
        final String? token = await AuthService.getFirebaseAuthToken();
        if (token != null) {
          await authStore.signUpCustomer(token);
        }

        if (authStore.user != null) {
          Navigator.pushNamedAndRemoveUntil(context, RoutePaths.HOME.value, (route) => false);
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
        Column(
          children: [
            28.height,
            GoogleButtonWidget(
              context,
              isLoading: isLoading,
              text: BUTTON_TEXT,
            ).onTap(() async {
              await handleSignUp();
            }),
            24.height,
            rfCommonRichText(title: CTA_TITLE, subTitle: CTA_SUBTITLE)
                .paddingAll(8)
                .onTap(() {
              widget.callBack!.call();
            }),
            if (mounted && authStore.errorMessage != null &&
                authStore.errorMessage!.isNotEmpty)
              Padding(
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
              )
          ],
        )
      ],
    );
  }
}
