import 'package:flutter/material.dart';

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
  final PageController _pageController = PageController(initialPage: 1000);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-slide every 3 seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        // Just move to the next page, PageView.builder will handle wrap-around
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
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
            // Using infinite items
            itemCount: null, // Infinite
            onPageChanged: (index) {
              setState(() {
                // Get the modulo to map to our actual images
                _currentPage = index % widget.images.length;
              });
            },
            itemBuilder: (context, index) {
              // Map the infinite index to our actual image list
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
                child: Image.network(
                  widget.images[imageIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[600],
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
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
