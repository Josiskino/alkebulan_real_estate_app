import 'package:flutter/material.dart';
import '../../../widgets/shimmer_widget.dart';

class PropertyCardShimmer extends StatelessWidget {
  const PropertyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image shimmer
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: ShimmerWidget.rectangular(
                  height: 120,
                  width: 220,
                ),
              ),
              // Favorite button shimmer
              Positioned(
                top: 10,
                right: 10,
                child: ShimmerWidget.circular(
                  width: 36,
                  height: 36,
                ),
              ),
            ],
          ),

          // Property details shimmer
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type and rating shimmer
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

                // Property name shimmer
                ShimmerWidget.rectangular(
                  width: 150,
                  height: 16,
                ),

                const SizedBox(height: 8),

                // Location shimmer
                ShimmerWidget.rectangular(
                  width: 180,
                  height: 14,
                ),

                const SizedBox(height: 8),

                // Price shimmer
                ShimmerWidget.rectangular(
                  width: 120,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
