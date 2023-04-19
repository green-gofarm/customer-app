import 'package:customer_app/main.dart';
import 'package:customer_app/screens/HomeScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Widget googleSignInWidget(
    {String? loginLogo,
    String? btnName,
    Function? onTapBtn,
    double? logoHeight,
    double? logoWidth}) {
  return OutlinedButton(
    onPressed: () {
      onTapBtn!();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        rfCommonCachedNetworkImage(loginLogo!,
            height: logoHeight!, width: logoWidth!, fit: BoxFit.cover),
        24.width,
        Text(btnName!, style: boldTextStyle()),
      ],
    ).paddingOnly(top: 8, bottom: 8, right: 8),
  );
}

InputDecoration jsInputDecoration(
    {Icon? icon, String? hintText, Icon? prefixIcon, bool? showPreFixIcon}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      hintText: hintText,
      hintStyle: secondaryTextStyle(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: rf_primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      filled: true,
      fillColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
      suffixIcon: icon.validate(),
      prefixIcon: showPreFixIcon.validate() ? prefixIcon.validate() : null);
}

PreferredSizeWidget jsAppBar(BuildContext context,
    {VoidCallback? callBack,
    Widget? titleWidget,
    bool? backWidget,
    bool? homeAction,
    bool? bottomSheet,
    bool? message,
    bool? notifications,
    List<Widget>? actions,
    double appBarHeight = 50}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0, // Adjust the blur radius as needed
            spreadRadius: 1.0, // Adjust the spread radius as needed
            offset: Offset(0.0, 3.0), // Adjust the offset as needed
          ),
        ],
      ),
      child: appBarWidget(
        '',
        titleWidget: titleWidget,
        color: appStore.isDarkModeOn ? cardDarkColor : rf_primaryColor,
        elevation: 0.0,
        backWidget: backWidget.validate()
            ? IconButton(
                icon: Icon(Icons.arrow_back, size: 20),
                color: Colors.white,
                onPressed: () {
                  if (callBack != null) {
                    callBack();
                    return;
                  }
                  Navigator.pop(context);
                })
            : SizedBox.shrink(),
        actions: [
          homeAction.validate()
              ? IconButton(
                  onPressed: () {
                    HomeScreen().launch(context);
                  },
                  icon: Icon(Icons.home, size: 20),
                  color: Colors.white)
              : SizedBox.shrink(),
          ...(actions?? []),
        ],
      ),
    ),
  );
}
