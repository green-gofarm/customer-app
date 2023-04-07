import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFImages.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Widget GoogleButtonWidget(
  BuildContext context, {
  String? text,
  bool? isLoading,
  Function()? onPressed,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: context.scaffoldBackgroundColor,
      side: BorderSide(color: context.dividerColor, width: 1),
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoading == true
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(rf_primaryColor),
                  strokeWidth: 4,
                ),
              )
            : commonCacheImageWidget(rf_google_logo, 20, fit: BoxFit.cover),
        8.width,
        Text(text!, style: primaryTextStyle()),
      ],
    ),
  ).paddingSymmetric(horizontal: 24);
}
