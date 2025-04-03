import 'package:flutter/material.dart';
import 'widgets/location_header.dart';
import 'widgets/notification_icon.dart';
import 'widgets/search_bar_with_filter.dart';
import 'widgets/property_category_item.dart';
import 'widgets/property_card_3d.dart';
import 'widgets/property_card_shimmer.dart';
import 'widgets/nearby_property_card.dart';
import 'widgets/nearby_property_card_shimmer.dart';
import 'widgets/image_slider.dart';
import 'widgets/image_slider_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _recommendedScrollController = ScrollController();

  final List<String> _sliderImages = [
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1576941089067-2de3c901e126?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.home_outlined, 'label': 'House'},
    {'icon': Icons.villa_outlined, 'label': 'Villa'},
    {'icon': Icons.apartment_outlined, 'label': 'Apartment'},
    {'icon': Icons.holiday_village_outlined, 'label': 'Bungalow'},
  ];

  final List<Map<String, dynamic>> _recommendedProperties = [
    {
      'image':
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'type': 'Apartment',
      'name': 'Woodland Apartments',
      'location': 'New York, USA',
      'price': 1500,
      'rating': 4.5,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'type': 'Home',
      'name': 'Oakleaf Cottage',
      'location': 'New York, USA',
      'price': 900,
      'rating': 4.2,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'type': 'Villa',
      'name': 'Skyview Residence',
      'location': 'New York, USA',
      'price': 2200,
      'rating': 4.8,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1558036117-15d82a90b9b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'type': 'Apartment',
      'name': 'Urban Loft',
      'location': 'New York, USA',
      'price': 1300,
      'rating': 4.0,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1513584684374-8bab748fbf90?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'type': 'Bungalow',
      'name': 'Sunset Retreat',
      'location': 'New York, USA',
      'price': 1800,
      'rating': 4.6,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Setup fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    // Force showing shimmer initially
    setState(() {
      _isLoading = true;
    });

    // Simulate loading data from an API
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _recommendedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: const LocationHeader(location: 'New York, USA'),
        actions: [
          NotificationIcon(
            notificationCount: 3,
            onPressed: () {
              // Handle notification press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            SearchBarWithFilter(
              onSearchTap: () {
                // Navigate to search page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search page will be implemented soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            // Property types
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return PropertyCategoryItem(
                    icon: _categories[index]['icon'],
                    label: _categories[index]['label'],
                    isSelected: _selectedCategoryIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  );
                },
              ),
            ),

            // Image Slider
            const SizedBox(height: 8),
            _isLoading
                ? const ImageSliderShimmer()
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: ImageSlider(images: _sliderImages),
                  ),
            const SizedBox(height: 16),

            // Recommended Property
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Property',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recommended property cards with 3D effect
            SizedBox(
              height: 260,
              child: _isLoading
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        PropertyCardShimmer(),
                        SizedBox(width: 16),
                        PropertyCardShimmer(),
                        SizedBox(width: 16),
                        PropertyCardShimmer(),
                        SizedBox(width: 16),
                        PropertyCardShimmer(),
                        SizedBox(width: 16),
                        PropertyCardShimmer(),
                      ],
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        controller: _recommendedScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _recommendedProperties.length,
                        itemBuilder: (context, index) {
                          final property = _recommendedProperties[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == _recommendedProperties.length - 1
                                  ? 0
                                  : 16,
                            ),
                            child: PropertyCard3D(
                              image: property['image'],
                              type: property['type'],
                              name: property['name'],
                              location: property['location'],
                              price: property['price'].toDouble(),
                              rating: property['rating'].toDouble(),
                              index: index,
                              scrollController: _recommendedScrollController,
                              onTap: () {
                                // Handle property tap
                              },
                              onFavoriteToggle: () {
                                // Handle favorite toggle
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // Nearby Property
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Property',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Nearby property cards
            _isLoading
                ? Column(
                    children: const [
                      NearbyPropertyCardShimmer(),
                      SizedBox(height: 12),
                      NearbyPropertyCardShimmer(),
                      SizedBox(height: 12),
                      NearbyPropertyCardShimmer(),
                      SizedBox(height: 12),
                      NearbyPropertyCardShimmer(),
                      SizedBox(height: 12),
                      NearbyPropertyCardShimmer(),
                    ],
                  )
                : Column(
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: NearbyPropertyCard(
                          image:
                              'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
                          type: 'Villa',
                          name: 'BlissView Villa',
                          location: 'New York, USA',
                          rating: 4.9,
                          onTap: () {
                            // Handle property tap
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: NearbyPropertyCard(
                          image:
                              'https://images.unsplash.com/photo-1574362848149-11496d93a7c7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
                          type: 'Apartment',
                          name: 'Riverside Apartments',
                          location: 'New York, USA',
                          rating: 4.3,
                          onTap: () {
                            // Handle property tap
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: NearbyPropertyCard(
                          image:
                              'https://images.unsplash.com/photo-1502005097973-6a7082348e28?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
                          type: 'Home',
                          name: 'Maple Grove House',
                          location: 'New York, USA',
                          rating: 4.1,
                          onTap: () {
                            // Handle property tap
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: NearbyPropertyCard(
                          image:
                              'https://images.unsplash.com/photo-1494526585095-c41746248156?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
                          type: 'Villa',
                          name: 'Harbor Luxury Villa',
                          location: 'New York, USA',
                          rating: 4.7,
                          onTap: () {
                            // Handle property tap
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: NearbyPropertyCard(
                          image:
                              'https://images.unsplash.com/photo-1507149833265-60c372daea22?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
                          type: 'Bungalow',
                          name: 'Pinecrest Bungalow',
                          location: 'New York, USA',
                          rating: 4.4,
                          onTap: () {
                            // Handle property tap
                          },
                        ),
                      ),
                    ],
                  ),

            // Add some bottom padding
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
