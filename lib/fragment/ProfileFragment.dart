import 'package:customer_app/main.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// import '../screens/BHAccountInformationScreen.dart';
// import '../screens/BHNotificationScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  static final String SIGN_OUT_TITLE = "Đăng xuất";
  static final String SIGN_OUT_CONTENT = "Bạn có thực sự muốn đăng xuất?";
  static final String SIGN_OUT_NO = "Quay lại";
  static final String SIGN_OUT_YES = "Xác nhận";
  static final String ACCOUNT_INFO = "Hồ sơ cá nhân";
  static final String NOTIFICATION = "Thông báo";
  static final String SIGN_OUT = "Đăng xuất";

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentTextStyle: secondaryTextStyle(),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(SIGN_OUT_TITLE, style: boldTextStyle()),
          content: Text(SIGN_OUT_CONTENT, style: secondaryTextStyle()),
          actions: <Widget>[
            TextButton(
              child: Text(SIGN_OUT_NO,
                  style: TextStyle(color: Colors.blue, fontSize: 14)),
              onPressed: () {
                finish(context);
              },
            ),
            TextButton(
              child: Text(SIGN_OUT_YES,
                  style: TextStyle(color: Colors.blue, fontSize: 14)),
              onPressed: () async {
                await authStore.signOut();
                finish(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = authStore.user;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        height: context.height(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  16.height,
                  Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                        backgroundImage: FadeInImage.assetNetwork(
                          placeholder: default_image,
                          image: user?.avatar.validate() ?? default_image,
                          fit: BoxFit.cover,
                          height: 170,
                          width: context.width() - 32,
                        ).image,
                        radius: 50),
                  ),
                  8.height,
                  Text(user?.name ?? "NO_NAME", style: boldTextStyle()),
                  8.height,
                  Text(user?.email ?? "NO_EMAIL", style: secondaryTextStyle()),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: Offset(0.0, 1.0),
                        blurRadius: 2.0),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_circle,
                            size: 23, color: rf_primaryColor),
                        8.width,
                        Text(ACCOUNT_INFO, style: secondaryTextStyle())
                            .expand(),
                      ],
                    ).onTap(() {
                      // BHAccountInformationScreen().launch(context);
                    }),
                    16.height,
                    Row(
                      children: [
                        Icon(Icons.notifications,
                            size: 23, color: rf_primaryColor),
                        8.width,
                        Text(NOTIFICATION, style: secondaryTextStyle())
                            .expand(),
                      ],
                    ).onTap(() {
                      // BHNotificationScreen().launch(context);
                    }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: Offset(0.0, 1.0),
                        blurRadius: 2.0),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.logout, size: 23, color: rf_primaryColor),
                        8.width,
                        Text(SIGN_OUT, style: secondaryTextStyle()).expand(),
                      ],
                    ).onTap(
                      () {
                        _showDialog();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
