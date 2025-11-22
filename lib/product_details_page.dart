import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'design_tokens.dart';
import 'main.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productIndex;
  final String productName;
  final String productDesc;
  final String productPrice;

  const ProductDetailsPage({
    super.key,
    required this.productIndex,
    required this.productName,
    required this.productDesc,
    required this.productPrice,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < AppTokens.breakpointTablet;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [cartNavButton(context)],
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
                  Text(
                    widget.productName,
                    style: AppTokens.headingMedium,
                  ),
                  const SizedBox(height: AppTokens.spacingMd),
                  Text(
                    widget.productPrice,
                    style: AppTokens.priceTag.copyWith(
                      color: AppTokens.colorOrange,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingLg),
                  Text(
                    'Description',
                    style: AppTokens.headingSmall,
                  ),
                  const SizedBox(height: AppTokens.spacingSm),
                  Text(
                    widget.productDesc,
                    style: AppTokens.bodyMedium,
                  ),
                  const SizedBox(height: AppTokens.spacingXl),
                  // Quantity Selector
                  Text(
                    'Quantity',
                    style: AppTokens.headingSmall,
                  ),
                  const SizedBox(height: AppTokens.spacingMd),
                  Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                        icon: const Icon(Icons.remove),
                        color: AppTokens.colorOrange,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTokens.spacingMd,
                        ),
                        child: Text(
                          '$quantity',
                          style: AppTokens.labelLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add),
                        color: AppTokens.colorOrange,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTokens.spacingXl),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart =
                            Provider.of<CartModel>(context, listen: false);
                        for (int i = 0; i < quantity; i++) {
                          cart.addToCart(widget.productIndex);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added $quantity item(s) to cart',
                              style: AppTokens.bodyMedium,
                            ),
                            backgroundColor: AppTokens.colorOrange,
                          ),
                        );
                      },
                      child: const Text('Add to Cart'),
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
