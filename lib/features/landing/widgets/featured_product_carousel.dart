import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/theme/design_tokens.dart';
import '../../products/product_data.dart';

class FeaturedProductCarousel extends StatefulWidget {
  const FeaturedProductCarousel({super.key});

  @override
  State<FeaturedProductCarousel> createState() => _FeaturedProductCarouselState();
}

class _FeaturedProductCarouselState extends State<FeaturedProductCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  static const Duration _autoSlideInterval = Duration(seconds: 4);
  static const Duration _slideDuration = Duration(milliseconds: 520);

  Timer? _timer;
  int _currentIndex = 0;

  List<StoreProduct> get _featuredProducts {
    if (kStoreProducts.isEmpty) {
      return const <StoreProduct>[];
    }
    return kStoreProducts.take(5).toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoSlideInterval, (_) => _slideToNextPage());
  }

  Future<void> _slideToNextPage() async {
    final products = _featuredProducts;
    if (!mounted || products.length < 2 || !_pageController.hasClients) {
      return;
    }

    final nextIndex = (_currentIndex + 1) % products.length;
    await _pageController.animateToPage(
      nextIndex,
      duration: _slideDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _featuredProducts;
    final width = MediaQuery.of(context).size.width;
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Product',
          style: AppTokens.headingMedium.copyWith(
            color: AppTokens.colorOrange,
            fontSize: 34,
          ),
        ),
        const SizedBox(height: AppTokens.spacingSm),
        Text(
          'Tap the carousel or wait for auto-slide to discover highlighted items.',
          style: AppTokens.bodyMedium.copyWith(
            color: AppTokens.colorLightGrey.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: AppTokens.spacingLg),
        GestureDetector(
          onTap: () {
            _startAutoSlide();
            _slideToNextPage();
          },
          child: SizedBox(
            height: width >= AppTokens.breakpointTablet ? 360 : 320,
            child: PageView.builder(
              controller: _pageController,
              itemCount: products.length,
              onPageChanged: (index) {
                if (!mounted) return;
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final product = products[index];
                return AnimatedPadding(
                  duration: AppTokens.transitionFast,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTokens.spacingXs,
                    vertical: _currentIndex == index ? 0 : AppTokens.spacingSm,
                  ),
                  child: _FeaturedProductCard(product: product),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppTokens.spacingMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(products.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: AppTokens.transitionNormal,
              margin: const EdgeInsets.symmetric(horizontal: AppTokens.spacing2xs),
              width: isActive ? 24 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTokens.colorOrange
                    : AppTokens.colorLightGrey.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppTokens.radiusXl),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  final StoreProduct product;

  const _FeaturedProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final imagePath = product.imagePaths.isEmpty ? null : product.imagePaths.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTokens.colorDarkGrey,
          border: Border.all(
            color: AppTokens.colorWhite.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 700;
            final image = imagePath == null
                ? const _FeaturedImagePlaceholder()
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const _FeaturedImagePlaceholder(),
                  );

            final details = Padding(
              padding: const EdgeInsets.all(AppTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.headingSmall.copyWith(fontSize: isNarrow ? 24 : 28),
                  ),
                  const SizedBox(height: AppTokens.spacingSm),
                  Text(
                    product.description,
                    maxLines: isNarrow ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.bodyMedium.copyWith(
                      color: AppTokens.colorLightGrey.withValues(alpha: 0.88),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingMd),
                  Text(
                    product.price,
                    style: AppTokens.priceTag.copyWith(
                      color: AppTokens.colorOrange,
                      fontSize: isNarrow ? 22 : 26,
                    ),
                  ),
                ],
              ),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 170, child: image),
                  Expanded(child: details),
                ],
              );
            }

            return Row(
              children: [
                Expanded(flex: 5, child: image),
                Expanded(flex: 4, child: details),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedImagePlaceholder extends StatelessWidget {
  const _FeaturedImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.colorBlack,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: AppTokens.colorLightGrey.withValues(alpha: 0.78),
            size: 48,
          ),
          const SizedBox(height: AppTokens.spacingXs),
          Text(
            'No product image',
            style: AppTokens.bodySmall,
          ),
        ],
      ),
    );
  }
}
