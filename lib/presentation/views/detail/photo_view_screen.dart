import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

class PhotoViewScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoViewScreen({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  int _currentIndex = 0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _closeView() {
    // Force immediate close without animation for now
    Navigator.of(context).pop();

    /* Commented out the animation for now to ensure reliable closing
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    
    // Pour être sûr que la navigation se produit même si l'animation a un problème
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
    */
  }

  void _navigateToNext() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToPrevious() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _closeView();
        return false; // On gère nous-mêmes la fermeture
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Scaffold(
            backgroundColor:
                Colors.black.withOpacity(_opacityAnimation.value * 0.9),
            // Add an AppBar with a close button
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                // Explicit close button in AppBar
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: const EdgeInsets.all(16),
                ),
              ],
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Blurred background
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0 * _opacityAnimation.value,
                    sigmaY: 20.0 * _opacityAnimation.value,
                  ),
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.2 * _opacityAnimation.value),
                  ),
                ),

                // Main content - Photos page view
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isZoomed = !_isZoomed;
                          });
                        },
                        child: Center(
                          child: Hero(
                            tag: 'gallery-image-$index',
                            child: InteractiveViewer(
                              panEnabled: _isZoomed,
                              minScale: 1.0,
                              maxScale: 3.0,
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrls[index],
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  color: Colors.black,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.black,
                                  child: const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Previous image button
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: _opacityAnimation.value *
                        (_currentIndex > 0 ? 1.0 : 0.3),
                    child: GestureDetector(
                      onTap: _navigateToPrevious,
                      behavior: HitTestBehavior.translucent,
                      child: SizedBox(
                        width: 60,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Next image button
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: _opacityAnimation.value *
                        (_currentIndex < widget.imageUrls.length - 1
                            ? 1.0
                            : 0.3),
                    child: GestureDetector(
                      onTap: _navigateToNext,
                      behavior: HitTestBehavior.translucent,
                      child: SizedBox(
                        width: 60,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Image counter
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Column(
                      children: [
                        // Image index indicator
                        Text(
                          '${_currentIndex + 1}/${widget.imageUrls.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.imageUrls.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
