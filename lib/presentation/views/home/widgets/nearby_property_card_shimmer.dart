import 'package:flutter/material.dart';
import '../../../widgets/shimmer_widget.dart';

class NearbyPropertyCardShimmer extends StatelessWidget {
  const NearbyPropertyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 110,
        child: Row(
          children: [
            // Property image shimmer
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ShimmerWidget.rectangular(
                width: 110,
                height: 110,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.rectangular(
                        width: 80,
                        height: 24,
                      ),
                      ShimmerWidget.rectangular(
                        width: 50,
                        height: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ShimmerWidget.rectangular(
                    width: 150,
                    height: 16,
                  ),
                  const SizedBox(height: 8),
                  ShimmerWidget.rectangular(
                    width: 180,
                    height: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
