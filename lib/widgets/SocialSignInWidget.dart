import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/GoogleButtonWidget.dart';
import 'package:customer_app/widgets/LoadingMixin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:customer_app/screens/RFHomeScreen.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

const BUTTON_TEXT = "Đăng nhập với Google";
const CTA_TITLE = "Chưa có tài khoản?";
const CTA_SUBTITLE = "Đăng ký";

class SocialSignInWidget extends StatefulWidget {
  final Function? callBack;

  const SocialSignInWidget({Key? key, this.callBack}) : super(key: key);

  @override
  _SocialSignInWidgetState createState() => _SocialSignInWidgetState();
}

class _SocialSignInWidgetState extends State<SocialSignInWidget>
    with LoadingMixin {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> handleGoogleSignIn() async {
    try {
      setState(() {
        setLoading(true);
      });

      final UserCredential userCredential =
          await AuthService.signInWithGoogle();

      if (userCredential.user != null) {
        await authStore.signInCustomer(null);

        if (authStore.user != null) {
          Navigator.pushReplacementNamed(context, RoutePaths.HOME.value);
        }
      }
    } catch (error) {
      logger.e("Social sign in", error);
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
              isLoading: isLoading && mounted,
              text: BUTTON_TEXT,
            ).onTap(() async {
              await handleGoogleSignIn();
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