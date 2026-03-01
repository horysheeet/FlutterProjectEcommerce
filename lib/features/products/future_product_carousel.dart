import 'package:flutter/material.dart';
import '../../shared/theme/design_tokens.dart';
import 'product_actions.dart';

class FutureProductCarousel extends StatefulWidget {
  const FutureProductCarousel({super.key});

  @override
  State<FutureProductCarousel> createState() => _FutureProductCarouselState();
}

class _FutureProductCarouselState extends State<FutureProductCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _index = 0;

  final List<Map<String, String>> featuredProducts = [
    {
      'name': 'RoboArm X1',
      'desc': 'Precision robotic arm with adaptive AI control.',
      'price': '₱24,999'
    },
    {
      'name': 'DroneEye 360',
      'desc': 'Autonomous drone with panoramic navigation sensors.',
      'price': '₱49,999'
    },
    {
      'name': 'AutoBot Z',
      'desc': 'Self-learning mobile assistant robot for industrial use.',
      'price': '₱149,999'
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    _index = (_index + 1) % featuredProducts.length;
    _controller.animateToPage(
      _index,
      duration: AppTokens.transitionSlow,
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: featuredProducts.length,
            onPageChanged: (idx) => setState(() => _index = idx),
            itemBuilder: (context, i) {
              final p = featuredProducts[i];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTokens.spacingSm,
                  vertical: AppTokens.spacingXs,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTokens.colorOrange,
                    borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    border: Border.all(color: AppTokens.colorOrange),
                  ),
                  padding: EdgeInsets.all(AppTokens.spacingMd),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.smart_toy,
                            size: 52, color: AppTokens.colorWhite),
                        SizedBox(height: AppTokens.spacingSm),
                        Text(p['name']!, style: AppTokens.headingSmall),
                        SizedBox(height: AppTokens.spacingXs),
                        Text(
                          p['desc']!,
                          textAlign: TextAlign.center,
                          style: AppTokens.bodyLarge,
                        ),
                        SizedBox(height: AppTokens.spacingSm),
                        Text(p['price']!, style: AppTokens.priceTag),
                        SizedBox(height: AppTokens.spacingSm),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTokens.colorWhite,
                            foregroundColor: AppTokens.colorOrange,
                          ),
                          onPressed: () {
                            launchShopeeUrl('featured-product-$i', context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View on Shopee',
                                  style: AppTokens.labelLarge),
                              SizedBox(width: AppTokens.spacingXs),
                              Icon(Icons.open_in_new, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppTokens.spacingSm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(featuredProducts.length, (i) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _index == i ? 14 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _index == i
                    ? AppTokens.colorOrange
                    : AppTokens.colorLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}
