import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design_tokens.dart';
import 'main.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productIndex;
  final String productName;
  final String productDesc;
  final String productPrice;
  final String shopeeUrl;

  const ProductDetailsPage({
    super.key,
    required this.productIndex,
    required this.productName,
    required this.productDesc,
    required this.productPrice,
    this.shopeeUrl = '',
  });

  Future<void> _launchShopeeProduct(BuildContext context) async {
    final url = shopeeUrl.isNotEmpty 
        ? shopeeUrl 
        : 'https://shopee.ph/product/product-$productIndex';
    
    final uri = Uri.parse(url);
    
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open Shopee. Please try again.'),
            backgroundColor: AppTokens.colorRed,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Shopee'),
            backgroundColor: AppTokens.colorRed,
          ),
        );
      }
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
              height: isMobile ? 250 : 400,
              color: AppTokens.colorDarkGrey,
              child: AnimatedContainer(
                duration: AppTokens.transitionNormal,
                child: Center(
                  child: Icon(
                    Icons.smart_toy,
                    size: isMobile ? 80 : 120,
                    color: AppTokens.colorOrange,
                  ),
                ),
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
                  // Shopee Availability Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTokens.spacingMd,
                      vertical: AppTokens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.colorOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                      border: Border.all(
                        color: AppTokens.colorOrange,
                        width: 1.5,
                      ),
                    ),
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
                  const SizedBox(height: AppTokens.spacingLg),
                  // Purchase Disclosure
                  Container(
                    padding: EdgeInsets.all(AppTokens.spacingMd),
                    decoration: BoxDecoration(
                      color: AppTokens.colorDarkGrey,
                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                      border: Border.all(
                        color: AppTokens.colorOrange.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTokens.colorOrange,
                          size: 20,
                        ),
                        SizedBox(width: AppTokens.spacingSm),
                        Expanded(
                          child: Text(
                            'This product is sold on Shopee. You\'ll be redirected to complete your purchase securely.',
                            style: AppTokens.bodySmall.copyWith(
                              color: AppTokens.colorLightGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingXl),
                  // Buy on Shopee Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTokens.colorOrange,
                        foregroundColor: AppTokens.colorWhite,
                        padding: EdgeInsets.symmetric(
                          vertical: AppTokens.spacingMd,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        ),
                      ),
                      onPressed: () => _launchShopeeProduct(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 20),
                          SizedBox(width: AppTokens.spacingSm),
                          Text(
                            'Buy on Shopee',
                            style: AppTokens.labelLarge.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: AppTokens.spacingSm),
                          Icon(Icons.open_in_new, size: 18),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppTokens.spacingMd),
                  // Alternative: Check Price button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTokens.colorOrange,
                        side: BorderSide(
                          color: AppTokens.colorOrange,
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: AppTokens.spacingSm,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        ),
                      ),
                      onPressed: () => _launchShopeeProduct(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View Details on Shopee',
                            style: AppTokens.labelLarge,
                          ),
                          SizedBox(width: AppTokens.spacingXs),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
