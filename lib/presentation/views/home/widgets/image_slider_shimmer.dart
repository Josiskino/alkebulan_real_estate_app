import 'package:flutter/material.dart';
import '../../../widgets/shimmer_widget.dart';

class ImageSliderShimmer extends StatelessWidget {
  final double height;

  const ImageSliderShimmer({
    super.key,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          // Image shimmer
          ShimmerWidget.rectangular(height: height),

          // Dots indicator shimmer
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ShimmerWidget.rectangular(
                    width: index == 0 ? 24 : 12,
                    height: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
