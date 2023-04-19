import 'package:customer_app/utils/RFConstant.dart';
import 'package:flutter/material.dart';

Widget ErrorImageWidget(
    BuildContext context, Object exception, StackTrace? stackTrace, {double? width, double? height, BoxFit? fit}) {
  return Image.asset(
    default_image,
    fit: fit ?? BoxFit.cover,
    height: height,
    width: width,
  );
}
