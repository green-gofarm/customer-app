import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class NotificationSkeleton extends StatelessWidget {
  NotificationSkeleton();

  Widget _shimmerContainer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerContainer(width: 20, height: 20),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerContainer(width: context.width() * 0.6, height: 12),
                SizedBox(height: 12),
                _shimmerContainer(width: context.width() - 80, height: 8),
                SizedBox(height: 4),
                _shimmerContainer(width: context.width() - 80, height: 8),
                SizedBox(height: 4),
                _shimmerContainer(width: context.width() - 80, height: 8),
                SizedBox(height: 4),
                _shimmerContainer(width: context.width() - 80, height: 8),
                SizedBox(height: 8),
                _shimmerContainer(width: 60, height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
