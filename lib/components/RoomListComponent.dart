import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/screens/RoomDetailScreen.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RoomListComponent extends StatelessWidget {
  final RoomModel room;

  RoomListComponent({required this.room});

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
              image: room.images.avatar,
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
              Text(room.name, style: boldTextStyle()),
              6.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Số lần đặt:", style: secondaryTextStyle()),
                      4.width,
                      room.bookingCount != null && room.bookingCount! > 0
                          ? Text("${room.bookingCount ?? 0} lần",
                              style: secondaryTextStyle())
                          : Text("Chờ khám phá",
                              style: secondaryTextStyle(
                                  fontStyle: FontStyle.italic, size: 11))
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
                    NumberUtil.formatIntPriceToVnd(room.price),
                    style: secondaryTextStyle(color: rf_primaryColor),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ).paddingRight(8),
    ).onTap(() {
      RoomDetailScreen(
        farmstayId: room.farmstayId,
        roomId: room.id,
        onBack: () => {},
      ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
    });
  }
}
