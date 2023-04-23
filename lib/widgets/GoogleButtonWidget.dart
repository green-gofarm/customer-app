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
      padding: EdgeInsets.symmetric(vertical: 8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoading == true
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(rf_primaryColor),
                  strokeWidth: 2,
                ),
              )
            : commonCacheImageWidget(rf_google_logo, 20, fit: BoxFit.cover),
        16.width,
        Text(text!, style: boldTextStyle()),
      ],
    ),
  ).paddingSymmetric();
}
