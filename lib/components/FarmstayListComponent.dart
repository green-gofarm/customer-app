import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/screens/FarmstayDetailScreen.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FarmstayListComponent extends StatelessWidget {
  final FarmstayModel farmstay;
  final bool? locationWidth;

  FarmstayListComponent({required this.farmstay, this.locationWidth});

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
              image: farmstay.images?.avatar?.validate() ?? default_image,
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
          Row(
            children: [
              Icon(Icons.home_outlined, size: 18),
              8.width,
              Text(farmstay.name.validate(), style: boldTextStyle()),
            ],
          ).paddingSymmetric(horizontal: 16),
          4.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBarWidget(
                onRatingChanged: (rating) {},
                rating: farmstay.rating ?? 0.0,
                allowHalfRating: true,
                itemCount:
                    farmstay.rating == null || farmstay.rating == 0.0 ? 0 : 5,
                size: 16,
                disable: true,
                activeColor: Colors.yellow,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border_outlined,
                inActiveColor: Colors.yellow,
              ),
              4.width,
              farmstay.rating != null && farmstay.rating! > 0.0
                  ? Text(
                      "(${farmstay.rating ?? 0})",
                      style: primaryTextStyle(size: 12),
                    )
                  : Text(
                      "Chưa có đánh giá",
                      style: primaryTextStyle(
                          fontStyle: FontStyle.italic, size: 12),
                    ),
            ],
          ).paddingSymmetric(horizontal: 16),
          4.height,
          if (farmstay.address!.province != null)
            Row(
              children: [
                Icon(Icons.location_on, size: 12),
                8.width,
                Text(farmstay.address!.province!.name,
                    style: boldTextStyle(size: 12)),
              ],
            ).paddingSymmetric(horizontal: 16),
          16.height,
        ],
      ),
    ).onTap(() {
      FarmstayDetailScreen(
        farmstayId: farmstay.id,
        onBack: () {},
      ).launch(context);
    });
  }
}
