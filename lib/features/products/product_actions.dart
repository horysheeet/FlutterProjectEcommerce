import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/theme/design_tokens.dart';

/// Launch Shopee product URL in external browser.
Future<void> launchShopeeUrl(String productId, BuildContext context) async {
  final uri = Uri.parse('https://shopee.ph/product/$productId');

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
