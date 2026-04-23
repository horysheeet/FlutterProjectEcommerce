import 'package:flutter/material.dart';

import '../../../shared/services/analytics_service.dart';
import '../../../shared/theme/design_tokens.dart';
import '../../products/product_actions.dart';
import '../../products/product_data.dart';
import '../../products/product_details_page.dart';

class StoreSection extends StatelessWidget {
  const StoreSection({super.key});

  int _gridColumns(double width) {
    if (width < 760) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columns = _gridColumns(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: AppTokens.headingMedium.copyWith(
            color: AppTokens.colorOrange,
            fontSize: 34,
          ),
        ),
        const SizedBox(height: AppTokens.spacingSm),
        Text(
          'Engineering product catalog with direct Shopee access.',
          style: AppTokens.bodyMedium.copyWith(
            color: AppTokens.colorLightGrey.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: AppTokens.spacingXl),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kStoreProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppTokens.spacingMd,
            mainAxisSpacing: AppTokens.spacingMd,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final product = kStoreProducts[index];
            return _StoreProductCard(
              product: product,
            );
          },
        ),
      ],
    );
  }
}

class _StoreProductCard extends StatefulWidget {
  final StoreProduct product;

  const _StoreProductCard({
    required this.product,
  });

  @override
  State<_StoreProductCard> createState() => _StoreProductCardState();
}

class _StoreProductCardState extends State<_StoreProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppTokens.transitionNormal,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: AppTokens.colorDarkGrey,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          border: Border.all(
            color: AppTokens.colorWhite.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTokens.colorBlack.withValues(alpha: _isHovered ? 0.35 : 0.2),
              blurRadius: _isHovered ? 20 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: product.imagePaths.isEmpty
                    ? const _ProductImagePlaceholder()
                    : Image.asset(
                        product.imagePaths.first,
                        fit: BoxFit.cover,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) {
                            return child;
                          }
                          return const _ProductImagePlaceholder();
                        },
                        errorBuilder: (context, error, stackTrace) => const _ProductImagePlaceholder(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppTokens.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTokens.headingSmall.copyWith(fontSize: 21, height: 1.2),
                    ),
                    const SizedBox(height: AppTokens.spacingXs),
                    Text(
                      product.shortDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTokens.bodySmall.copyWith(
                        color: AppTokens.colorLightGrey.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppTokens.spacingSm),
                    Text(
                      product.price,
                      style: AppTokens.priceTag.copyWith(
                        color: AppTokens.colorOrange,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppTokens.spacingSm),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              AnalyticsService.track(
                                'view_product_click',
                                params: {'product': product.name},
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTokens.colorWhite,
                              side: BorderSide(
                                color: AppTokens.colorWhite.withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Text('View Product'),
                          ),
                        ),
                        const SizedBox(width: AppTokens.spacingXs),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AnalyticsService.track(
                                'shopee_cta_click',
                                params: {'product': product.name},
                              );
                              launchShopeeUrl(product.shopeeUrl, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTokens.colorOrange,
                              foregroundColor: AppTokens.colorWhite,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppTokens.spacingSm,
                              ),
                            ),
                            child: const Text('Buy on Shopee'),
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

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.colorBlack,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.smart_toy,
            size: 54,
            color: AppTokens.colorWhite.withValues(alpha: 0.68),
          ),
          const SizedBox(height: AppTokens.spacingXs),
          Text(
            'Loading image...',
            style: AppTokens.bodySmall.copyWith(
              color: AppTokens.colorLightGrey.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
