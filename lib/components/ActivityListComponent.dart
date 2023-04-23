import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/screens/ActivityDetailScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

class ActivityListComponent extends StatelessWidget {
  final ActivityModel activity;

  ActivityListComponent({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: default_image,
                    image: activity.images.avatar,
                    fit: BoxFit.cover,
                    height: 170,
                    width: context.width() - 32,
                    imageErrorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        default_image,
                        fit: BoxFit.cover,
                        height: 170,
                        width: context.width() - 32,
                      );
                    },
                  ),
                ).paddingSymmetric(horizontal: 16),
                8.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    Text(activity.name, style: boldTextStyle()),
                    6.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Entypo.book, size: 16),
                            8.width,
                            Row(
                              children: [
                                Text("Số lần đặt:",
                                    style: secondaryTextStyle()),
                                4.width,
                                activity.bookingCount != null &&
                                        activity.bookingCount! > 0
                                    ? Text("${activity.bookingCount ?? 0} lần",
                                        style: secondaryTextStyle())
                                    : Text("Chờ khám phá",
                                        style: secondaryTextStyle(
                                            fontStyle: FontStyle.italic,
                                            size: 11))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    6.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.price_change, size: 16),
                        8.width,
                        Text(
                          NumberUtil.formatIntPriceToVnd(activity.price),
                          style: secondaryTextStyle(color: rf_primaryColor),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
              ],
            ).paddingRight(8))
        .onTap(() {
      ActivityDetailScreen(
        farmstayId: activity.farmstayId,
        activityId: activity.id,
        onBack: () => {},
      ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
    });
  }
}
