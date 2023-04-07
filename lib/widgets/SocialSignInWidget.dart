import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/GoogleButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:customer_app/screens/RFHomeScreen.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

const BUTTON_TEXT = "Đăng nhập với Google";
const CTA_TITLE = "Chưa có tài khoản?";
const CTA_SUBTITLE = "Đăng ký";

Widget SocialSignInWidget(BuildContext context, {Function? callBack}) {

  Future<void> handleGoogleSignIn() async {
    authStore.isLoading = true;
    try {
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
      if (authStore.user == null) {
        await AuthService.signOut();
      }
      authStore.isLoading = false;
    }
  }

  return Column(
    children: [
      Column(
        children: [
          28.height,
          GoogleButtonWidget(
            context,
            isLoading: authStore.isLoading,
            text: BUTTON_TEXT,
          ).onTap(() async {
            await handleGoogleSignIn();
          }),
          24.height,
          rfCommonRichText(title: CTA_TITLE, subTitle: CTA_SUBTITLE)
              .paddingAll(8)
              .onTap(() {
            callBack!.call();
          }),
          if (authStore.errorMessage != null &&
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
