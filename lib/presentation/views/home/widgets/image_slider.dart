import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../widgets/shimmer_widget.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final double height;

  const ImageSlider({
    super.key,
    required this.images,
    this.height = 180,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    // Set initial page at a large offset to create illusion of infinite scrolling
    _pageController = PageController(initialPage: 1000 % widget.images.length);
    // Start auto-slide after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _startAutoSlide();
      }
    });
  }

  void _startAutoSlide() {
    // Cancel any existing timer
    _autoSlideTimer?.cancel();

    // Create a new timer that fires every 3 seconds
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && mounted && !_isSliding) {
        _isSliding = true;
        _pageController
            .nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        )
            .then((_) {
          if (mounted) {
            setState(() {
              _isSliding = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          // Page View of Images
          PageView.builder(
            controller: _pageController,
            itemCount: null, // Infinite scrolling
            onPageChanged: (index) {
              setState(() {
                _currentPage = index % widget.images.length;
              });
            },
            itemBuilder: (context, index) {
              final imageIndex = index % widget.images.length;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.images[imageIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => ShimmerWidget.rectangular(
                    height: widget.height,
                  ),
                  errorWidget: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.error, color: Colors.grey[600]),
                    );
                  },
                ),
              );
            },
          ),

          // Dots Indicator
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 12,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _currentPage == index
                        ? Colors.blue[600]
                        : Colors.grey[400],
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
