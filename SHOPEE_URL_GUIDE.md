# 🔗 Quick Reference: Updating Shopee Product URLs

## Step-by-Step Guide

### 1. Locate the Function
Open `lib/main.dart` and find the `_launchShopeeUrl()` function around line 30.

### 2. Current Implementation
```dart
Future<void> _launchShopeeUrl(String productId, BuildContext context) async {
  // Example Shopee URL structure - replace with actual store URLs
  final uri = Uri.parse('https://shopee.ph/product/$productId');
  // ... rest of function
}
```

### 3. Get Your Shopee Product URLs

#### Method A: Copy from Shopee Seller Center
1. Log into Shopee Seller Center
2. Go to "My Products"
3. Click on a product
4. Copy the URL from the browser address bar

Example URL formats:
- `https://shopee.ph/Product-Name-i.123456.789012`
- `https://shopee.ph/Your-Store-Product-i.234567.890123`

#### Method B: Use Shopee Product ID
If you know your Shopee product IDs, construct URLs like:
```
https://shopee.ph/product/{shop_id}/{item_id}
```

### 4. Create a Product Mapping

Add this function below `_launchShopeeUrl()` in `lib/main.dart`:

```dart
/// Map product indices to actual Shopee URLs
String _getShopeeUrl(int productIndex) {
  // Map each product index to its Shopee URL
  final Map<int, String> shopeeUrls = {
    0: 'https://shopee.ph/RoboArm-X1-Precision-Robotic-i.123456.789012',
    1: 'https://shopee.ph/DroneEye-360-Autonomous-Drone-i.123456.789013',
    2: 'https://shopee.ph/AutoBot-Z-Mobile-Assistant-i.123456.789014',
    // Add more products here...
  };
  
  // Return the URL or a default store URL if not found
  return shopeeUrls[productIndex] ?? 'https://shopee.ph/your-store-name';
}
```

### 5. Update All Product Launch Calls

Find and replace all instances of:
```dart
_launchShopeeUrl('product-${widget.index}', context);
```

With:
```dart
final url = _getShopeeUrl(widget.index);
_launchShopeeUrl(url, context);
```

Or modify `_launchShopeeUrl` to accept the full URL directly:
```dart
Future<void> _launchShopeeUrl(String shopeeUrl, BuildContext context) async {
  final uri = Uri.parse(shopeeUrl);
  // ... rest of function stays the same
}
```

### 6. Update Product Data

Locate the product data structures in `lib/main.dart`:

#### Featured Products Carousel (around line 470)
```dart
final List<Map<String, String>> featuredProducts = [
  {
    'name': 'RoboArm X1',
    'desc': 'Precision robotic arm with adaptive AI control.',
    'price': '₱24,999',
    'shopeeUrl': 'https://shopee.ph/RoboArm-X1-i.123456.789012', // ADD THIS
  },
  // ... more products
];
```

#### Future Product Carousel (around line 680)
```dart
final List<Map<String, String>> featuredProducts = [
  {
    'name': 'RoboArm X1',
    'desc': 'Precision robotic arm with adaptive AI control.',
    'price': '₱24,999',
    'shopeeUrl': 'https://shopee.ph/RoboArm-X1-i.123456.789012', // ADD THIS
  },
  // ... more products
];
```

### 7. Update Button Callbacks

Change from:
```dart
onPressed: () {
  _launchShopeeUrl('featured-$index', context);
}
```

To:
```dart
onPressed: () {
  final url = featuredProducts[index]['shopeeUrl']!;
  _launchShopeeUrl(url, context);
}
```

### 8. Test Each Product

Create a test checklist:
```
Product 0: [ ] URL works, [ ] Opens in new tab
Product 1: [ ] URL works, [ ] Opens in new tab
Product 2: [ ] URL works, [ ] Opens in new tab
...
```

---

## Complete Example Implementation

### Option 1: Centralized URL Mapping (Recommended)

```dart
// Add this class near the top of main.dart
class ShopeeProducts {
  static const Map<int, String> urls = {
    0: 'https://shopee.ph/RoboArm-X1-Precision-Robotic-i.123456.789012',
    1: 'https://shopee.ph/DroneEye-360-Autonomous-Drone-i.123456.789013',
    2: 'https://shopee.ph/AutoBot-Z-Mobile-Assistant-i.123456.789014',
    // Add all 30 products here
  };
  
  static String getUrl(int index) {
    return urls[index] ?? 'https://shopee.ph/your-default-store';
  }
}

// Update the launch function
Future<void> _launchShopeeProduct(int productIndex, BuildContext context) async {
  final url = ShopeeProducts.getUrl(productIndex);
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

// Update all button callbacks to:
onPressed: () => _launchShopeeProduct(widget.index, context)
```

### Option 2: Product Model with URLs

```dart
class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String shopeeUrl;
  
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.shopeeUrl,
  });
}

// Create product list
final List<Product> products = [
  Product(
    id: 0,
    name: 'RoboArm X1',
    description: 'Precision robotic arm with adaptive AI control.',
    price: '₱24,999',
    shopeeUrl: 'https://shopee.ph/RoboArm-X1-i.123456.789012',
  ),
  // ... more products
];

// Use in buttons:
onPressed: () => _launchShopeeUrl(products[index].shopeeUrl, context)
```

---

## Testing Your URLs

### Browser Test
1. Copy a Shopee URL
2. Paste in browser address bar
3. Press Enter
4. Verify product page loads correctly

### App Test
1. Run `flutter run -d chrome`
2. Click a product button
3. Verify Shopee opens in new tab
4. Verify correct product displayed

### Mobile Test
```bash
flutter run -d edge  # Windows
flutter run -d safari  # macOS
```

---

## Common Shopee URL Formats

### Standard Product URL
```
https://shopee.ph/Product-Name-i.{shop_id}.{item_id}
```

### Short URL (if you have one)
```
https://shp.ee/abcd123
```

### With Campaign Tracking
```
https://shopee.ph/Product-Name-i.123.456?utm_source=website&utm_campaign=catalog
```

### Affiliate URL (if applicable)
```
https://shopee.ph/universal-link/now-applink-redirect/...?affiliate_id=xyz
```

---

## Troubleshooting

### Problem: URL doesn't open
**Solution**: Check that `url_launcher` is in `pubspec.yaml`
```yaml
dependencies:
  url_launcher: ^6.2.5
```

### Problem: Opens in same tab
**Solution**: Verify `LaunchMode.externalApplication` is used:
```dart
launchUrl(uri, mode: LaunchMode.externalApplication)
```

### Problem: Wrong product loads
**Solution**: Double-check product index mapping
```dart
print('Loading product $index');  // Debug line
print('URL: ${ShopeeProducts.getUrl(index)}');  // Debug line
```

### Problem: URL format error
**Solution**: Ensure URL has `https://` prefix
```dart
final url = 'https://shopee.ph/...';  // ✅ Correct
final url = 'shopee.ph/...';  // ❌ Wrong
```

---

## Bulk Update Script (Optional)

If you have many products, create a JSON file:

**`assets/shopee_urls.json`**
```json
{
  "products": [
    {
      "id": 0,
      "name": "RoboArm X1",
      "shopee_url": "https://shopee.ph/RoboArm-X1-i.123456.789012"
    },
    {
      "id": 1,
      "name": "DroneEye 360",
      "shopee_url": "https://shopee.ph/DroneEye-360-i.123456.789013"
    }
  ]
}
```

Then load dynamically:
```dart
import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<int, String>> loadShopeeUrls() async {
  final String response = await rootBundle.loadString('assets/shopee_urls.json');
  final data = json.decode(response);
  
  return Map.fromIterable(
    data['products'],
    key: (item) => item['id'] as int,
    value: (item) => item['shopee_url'] as String,
  );
}
```

---

## Need Help?

1. **Shopee Seller Support**: Contact Shopee for product URL questions
2. **Flutter Documentation**: https://flutter.dev/docs/development/ui/navigation/url-strategies
3. **url_launcher Package**: https://pub.dev/packages/url_launcher

---

**Last Updated**: January 17, 2026  
**Estimated Time to Complete**: 15-30 minutes for ~30 products
