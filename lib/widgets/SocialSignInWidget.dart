import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/widgets/GoogleButtonWidget.dart';
import 'package:customer_app/widgets/LoadingMixin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';

const BUTTON_TEXT = "Đăng nhập với Google";

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
        authStore.resetStore();
        setLoading(true);
      });

      final UserCredential userCredential =
          await AuthService.signInWithGoogle();

      if (userCredential.user != null) {
        await authStore.signInCustomer(false);
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          authStore.updateNotificationToken(token);
        }

        if (authStore.user != null) {
          if(widget.callBack != null) {
            widget.callBack!();
            finish(context);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutePaths.HOME.value, (route) => false);
          }
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
            20.height,
            GoogleButtonWidget(
              context,
              isLoading: isLoading,
              text: BUTTON_TEXT,
            ).onTap(() async {
              await handleGoogleSignIn();
            }),
            20.height,
            if (mounted &&
                authStore.errorMessage != null &&
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
