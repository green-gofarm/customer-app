import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/RoomFinderModel.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFWidget.dart';

class RFFAQComponent extends StatelessWidget {
  final RoomFinderModel faqData;

  RFFAQComponent({required this.faqData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: context.width(),
      margin: EdgeInsets.only(bottom: 16),
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                backgroundColor:
                    appStore.isDarkModeOn ? scaffoldDarkColor : rf_faqBgColor,
              ),
              padding: EdgeInsets.all(8),
              child:
                  faqData.img.validate().iconImage(color: rf_primaryColor)),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(faqData.price.validate(), style: boldTextStyle()),
              12.height,
              Text(faqData.description.validate(),
                  style: secondaryTextStyle(),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
