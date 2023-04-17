import 'package:customer_app/main.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

sSAppButton(
    {Function? onPressed,
    String? title,
    required BuildContext context,
    Color? color,
    Color? textColor,
    bool? enabled,
    Widget? child}) {
  return AppButton(
    shapeBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    text: title,
    color: color ?? rf_primaryColor,
    textColor: textColor ?? Color(0xfffffbfb),
    enabled: enabled != null ? enabled : true,
    onTap: () {
      onPressed!();
    },
    child: child,
    width: context.width(),
  );
}
