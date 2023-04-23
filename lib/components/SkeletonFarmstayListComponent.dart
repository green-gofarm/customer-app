import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonFarmstayListComponent extends StatelessWidget {
  SkeletonFarmstayListComponent();

  Widget shimmerContainer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
    );
  }

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
            child: shimmerContainer(
              width: context.width() - 32,
              height: 170,
            ),
          ).paddingSymmetric(horizontal: 16),
          8.height,
          Row(
            children: [
              shimmerContainer(width: 18, height: 18),
              8.width,
              shimmerContainer(width: context.width() * 0.6, height: 16),
            ],
          ).paddingSymmetric(horizontal: 16),
          4.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerContainer(width: 18, height: 18),
              4.width,
              shimmerContainer(width: 40, height: 12),
            ],
          ).paddingSymmetric(horizontal: 16),
          4.height,
          Row(
            children: [
              shimmerContainer(width: 18, height: 18),
              8.width,
              shimmerContainer(width: context.width() * 0.4, height: 12),
            ],
          ).paddingSymmetric(horizontal: 16),
          16.height,
        ],
      ),
    );
  }
}
