import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FarmstayListComponent extends StatelessWidget {
  final FarmstayModel farmstay;
  final bool? locationWidth;

  FarmstayListComponent({required this.farmstay, this.locationWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FadeInImage.assetNetwork(
            placeholder: default_image,
            image: farmstay!.images?.avatar?.validate() ?? default_image,
            fit: BoxFit.cover,
            height: 170,
            width: context.width() - 32,
          ),
        ),
        Container(
          height: 170,
          width: context.width() - 32,
          decoration: boxDecorationWithRoundedCorners(
              backgroundColor: black.withOpacity(0.2)),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.home_outlined, color: white, size: 18),
                  8.width,
                  Text(farmstay.name.validate(),
                      style: boldTextStyle(color: white)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBarWidget(
                    onRatingChanged: (rating) {},
                    rating: farmstay?.rating ?? 0.0,
                    allowHalfRating: true,
                    itemCount: 5,
                    size: 16,
                    disable: true,
                    activeColor: Colors.yellow,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (farmstay!.address!.province != null)
                Row(
                  children: [
                    Icon(Icons.location_on, color: white, size: 12),
                    8.width,
                    Text(farmstay!.address!.province!.name!,
                        style: boldTextStyle(color: white, size: 12)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
