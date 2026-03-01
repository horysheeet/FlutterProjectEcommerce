import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/theme/design_tokens.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productIndex;
  final String productName;
  final String productDesc;
  final String productPrice;
  final String shopeeUrl;
  final List<String> imagePaths;

  const ProductDetailsPage({
    super.key,
    required this.productIndex,
    required this.productName,
    required this.productDesc,
    required this.productPrice,
    this.shopeeUrl = '',
    this.imagePaths = const [],
  });

  Future<void> _openShopeeLink(BuildContext context) async {
    if (shopeeUrl.trim().isEmpty) return;

    final uri = Uri.tryParse(shopeeUrl);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Shopee link.')),
      );
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Shopee link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < AppTokens.breakpointTablet;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTokens.colorBlack,
        title: Text(
          productName,
          style: TextStyle(
            color: AppTokens.colorWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTokens.colorWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Container(
              width: double.infinity,
              height: isMobile ? 360 : 460,
              color: AppTokens.colorDarkGrey,
              child: ProductImageCarousel(
                imagePaths: imagePaths,
              ),
            ),
            // Product Details
            Padding(
              padding: EdgeInsets.all(
                isMobile ? AppTokens.spacingMd : AppTokens.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTokens.colorOrange,
                      side: BorderSide(
                        color: AppTokens.colorOrange,
                        width: 1.5,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTokens.spacingMd,
                        vertical: AppTokens.spacingXs,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                      ),
                      backgroundColor: AppTokens.colorOrange.withValues(alpha: 0.1),
                    ),
                    onPressed: shopeeUrl.trim().isEmpty
                      ? null
                      : () => _openShopeeLink(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          color: AppTokens.colorOrange,
                          size: 18,
                        ),
                        SizedBox(width: AppTokens.spacingXs),
                        Text(
                          'Available on Shopee',
                          style: AppTokens.labelSmall.copyWith(
                            color: AppTokens.colorOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppTokens.spacingMd),
                  Text(
                    productName,
                    style: AppTokens.headingMedium,
                  ),
                  const SizedBox(height: AppTokens.spacingMd),
                  Text(
                    productPrice,
                    style: AppTokens.priceTag.copyWith(
                      color: AppTokens.colorOrange,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingLg),
                  Text(
                    'Description',
                    style: AppTokens.headingSmall,
                  ),
                  const SizedBox(height: AppTokens.spacingSm),
                  Text(
                    productDesc,
                    style: AppTokens.bodyMedium,
                  ),
                  const SizedBox(height: AppTokens.spacingXl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImageCarousel extends StatefulWidget {
  static const List<String> fallbackImages = [
    'assets/product_images/product_1/B1.png',
    'assets/product_images/product_1/B2.png',
    'assets/product_images/product_1/G1.png',
    'assets/product_images/product_1/G2.png',
    'assets/product_images/product_1/W1.png',
    'assets/product_images/product_1/W2.png',
  ];

  final List<String> imagePaths;

  const ProductImageCarousel({
    super.key,
    required this.imagePaths,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  static const Duration _autoSlideInterval = Duration(seconds: 4);
  static const Duration _slideDuration = Duration(milliseconds: 500);

  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  late final List<String> _images;

  int get _imageCount => _images.length;

  @override
  void initState() {
    super.initState();
    _images = widget.imagePaths.isNotEmpty
        ? widget.imagePaths
        : ProductImageCarousel.fallbackImages;

    _pageController = PageController(
      initialPage: _imageCount * 100,
    );

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoSlideInterval, (_) {
      _goToNextImage();
    });
  }

  void _goToNextImage() {
    if (!mounted || !_pageController.hasClients || _imageCount <= 1) {
      return;
    }
    _pageController.nextPage(
      duration: _slideDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        child: Container(
          color: AppTokens.colorWhite,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _goToNextImage,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    if (!mounted || _imageCount == 0) return;
                    setState(() => _currentIndex = index % _imageCount);
                  },
                  itemBuilder: (context, index) {
                    if (_imageCount == 0) {
                      return Center(
                        child: Icon(
                          Icons.smart_toy,
                          size: 120,
                          color: AppTokens.colorOrange,
                        ),
                      );
                    }

                    final imagePath = _images[index % _imageCount];
                    return Center(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.smart_toy,
                          size: 120,
                          color: AppTokens.colorOrange,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_imageCount, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppTokens.colorOrange
                              : AppTokens.colorLightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
