import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../widgets/shimmer_widget.dart';
import '../../../views/detail/property_detail_screen.dart';

class PropertyCard3D extends StatefulWidget {
  final String image;
  final String type;
  final String name;
  final String location;
  final double price;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final int index;
  final ScrollController scrollController;

  const PropertyCard3D({
    super.key,
    required this.image,
    required this.type,
    required this.name,
    required this.location,
    required this.price,
    required this.index,
    required this.scrollController,
    this.rating = 0,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  State<PropertyCard3D> createState() => _PropertyCard3DState();
}

class _PropertyCard3DState extends State<PropertyCard3D> {
  double _rotationY = 0;
  double _scale = 1.0;
  double _translateZ = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    // Calculate card position
    double cardWidth = 220 + 16; // card width + spacing
    double scrollOffset = widget.scrollController.offset;
    double viewportWidth = MediaQuery.of(context).size.width;
    double cardPosition = (widget.index * cardWidth) - scrollOffset;

    // Calculate how far from center the card is
    double distanceFromCenter =
        (viewportWidth / 2) - (cardPosition + cardWidth / 2);
    double normalizedDistance = distanceFromCenter / (viewportWidth / 2);

    // Check if first or last item
    bool isFirstItem = widget.index == 0;
    bool isLastItem = widget.index == 4; // Assuming 5 items total (index 0-4)

    // Special handling for first and last items
    double rotationValue;
    if (isFirstItem && normalizedDistance > 0) {
      // First item at left edge - no rotation
      rotationValue = 0;
    } else if (isLastItem && normalizedDistance < 0) {
      // Last item at right edge - no rotation
      rotationValue = 0;
    } else {
      // Normal rotation for all other cases, limited to a range
      rotationValue = normalizedDistance.clamp(-0.3, 0.3) * -1;
    }

    // Scale based on distance from center (cards in center are slightly larger)
    double scaleValue = 1.0 - (0.05 * normalizedDistance.abs());

    // Add slight z translation for deeper 3D effect
    double translateZ = -40 * normalizedDistance.abs();

    if (mounted) {
      setState(() {
        _rotationY = rotationValue;
        _scale = scaleValue;
        _translateZ = translateZ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateY(_rotationY)
        ..scale(_scale)
        ..translate(0.0, 0.0, _translateZ),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PropertyDetailScreen(
                image: widget.image,
                type: widget.type,
                name: widget.name,
                location: widget.location,
                price: widget.price,
                rating: widget.rating,
              ),
            ),
          );
        },
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image with Hero animation
              Stack(
                children: [
                  Hero(
                    tag: 'property-image-${widget.name}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        height: 120,
                        width: 220,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            ShimmerWidget.rectangular(
                          height: 120,
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 120,
                          width: 220,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: widget.onFavoriteToggle,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Property details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.type,
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 11,
                              fontFamily: 'SF Pro',
                            ),
                          ),
                        ),
                        if (widget.rating > 0)
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.rating}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Property name
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'SF Pro',
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey[600], size: 14),
                        const SizedBox(width: 4),
                        Text(
                          widget.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontFamily: 'SF Pro',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${widget.price}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'SF Pro',
                          ),
                        ),
                        Text(
                          '/month',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontFamily: 'SF Pro',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
