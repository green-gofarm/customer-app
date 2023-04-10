import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonFarmstayListComponent extends StatelessWidget {
  SkeletonFarmstayListComponent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 170,
              width: context.width() - 32,
            ),
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
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Text(
                      '',
                      style: boldTextStyle(color: white),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBarWidget(
                    onRatingChanged: (rating) {},
                    rating: 5.0,
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
              Row(
                children: [
                  Icon(Icons.location_on, color: white, size: 12),
                  8.width,
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Text(
                      '',
                      style: boldTextStyle(color: white, size: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
