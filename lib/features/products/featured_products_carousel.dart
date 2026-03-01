import 'package:flutter/material.dart';
import '../../shared/theme/design_tokens.dart';
import 'product_actions.dart';
import 'product_data.dart';

class FeaturedProductsCarousel extends StatefulWidget {
  const FeaturedProductsCarousel({super.key});

  @override
  State<FeaturedProductsCarousel> createState() =>
      _FeaturedProductsCarouselState();
}

class _FeaturedProductsCarouselState extends State<FeaturedProductsCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<FeaturedProduct> featuredProducts = [
    FeaturedProduct(
      name: 'Most Bought Product',
      description: 'RoboArm X1 - Precision robotic arm with adaptive AI control.',
      price: '₱24,999',
      icon: Icons.precision_manufacturing,
    ),
    FeaturedProduct(
      name: 'Most Popular Product',
      description: 'DroneEye 360 - Autonomous drone with panoramic navigation sensors.',
      price: '₱49,999',
      icon: Icons.flight,
    ),
    FeaturedProduct(
      name: 'Recommended Product',
      description: 'AutoBot Z - Self-learning mobile assistant robot for industrial use.',
      price: '₱149,999',
      icon: Icons.smart_toy,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      final nextPage = (_currentIndex + 1) % featuredProducts.length;
      _pageController.animateToPage(
        nextPage,
        duration: AppTokens.transitionSlow,
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppTokens.spacingXl),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTokens.spacingMd),
          child: Text(
            'Featured Selection',
            style: AppTokens.headingMedium,
          ),
        ),
        SizedBox(height: AppTokens.spacingMd),
        SizedBox(
          height: MediaQuery.of(context).size.width < 600 ? 350 : 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTokens.spacingSm),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTokens.colorWhite,
                    borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppTokens.colorBlack.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(AppTokens.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTokens.colorOrange.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTokens.radiusMd),
                            ),
                            child: Icon(
                              product.icon,
                              size: 36,
                              color: AppTokens.colorOrange,
                            ),
                          ),
                          SizedBox(height: AppTokens.spacingSm),
                          Text(
                            product.name,
                            style: AppTokens.headingSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppTokens.spacingXs),
                          Text(
                            product.description,
                            style: AppTokens.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.price,
                            style: AppTokens.priceTag,
                          ),
                          SizedBox(height: AppTokens.spacingSm),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTokens.colorOrange,
                                foregroundColor: AppTokens.colorWhite,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppTokens.spacingSm,
                                ),
                              ),
                              onPressed: () {
                                launchShopeeUrl('featured-$index', context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Buy on Shopee',
                                    style: AppTokens.labelLarge,
                                  ),
                                  SizedBox(width: AppTokens.spacingXs),
                                  Icon(Icons.open_in_new, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppTokens.spacingMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            featuredProducts.length,
            (index) => AnimatedContainer(
              duration: AppTokens.transitionFast,
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppTokens.colorOrange
                    : AppTokens.colorLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: AppTokens.spacingXl),
      ],
    );
  }
}
