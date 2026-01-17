# Shopee Integration Setup Guide

## Overview
This Flutter web application is now configured as an **outbound e-commerce catalog** that redirects users to Shopee for purchases. The site functions as a product showcase only—no cart, checkout, or payment processing occurs on-site.

## Key Changes Made

### 1. Architecture Transformation
- **Removed**: All cart functionality (CartModel, CartPage, cart navigation)
- **Removed**: Provider dependency and state management for cart
- **Removed**: Product details pages with "Add to Cart" functionality
- **Removed**: Internal checkout flows
- **Added**: Direct Shopee URL integration with external link launching

### 2. Call-to-Action (CTA) Updates
All product interaction buttons now redirect to Shopee:
- ✅ "Buy on Shopee" - Primary CTA with external link icon
- ✅ "View on Shopee" - Secondary CTA variant
- ✅ "View Details on Shopee" - Tertiary option
- ❌ Removed: "Add to Cart", "Buy Now", "View Product" (internal)

### 3. User Disclosure & Transparency
Added clear messaging throughout the site:
- **Homepage Hero**: "Browse our catalog. All purchases securely completed on Shopee."
- **Badge**: "Available on Shopee" badge on hero section
- **Store Page**: "🛍️ All purchases completed on Shopee" notification
- **Product Cards**: "Available on Shopee" labels
- **About Page**: Information banner about Shopee purchasing
- **Product Details**: Disclosure box explaining external redirect

### 4. External Link Handling
Implemented `_launchShopeeUrl()` function that:
- Opens Shopee URLs in external browser (`LaunchMode.externalApplication`)
- Includes error handling with user-friendly snackbar messages
- Supports custom product IDs for actual Shopee product mapping

### 5. Product URL Mapping
Current implementation uses placeholder URLs:
```dart
String productId = 'product-123';
String url = 'https://shopee.ph/product/$productId';
```

**ACTION REQUIRED**: Replace with your actual Shopee product URLs.

### 6. SEO & Metadata Updates
- **Title**: "Robotics Catalog - Shop on Shopee"
- **Description**: "Browse our robotics catalog. All products available for secure purchase on Shopee."
- **Theme Color**: #ED5833 (Orange brand color)
- **Meta Tags**: Added Open Graph and Twitter card metadata
- **Manifest**: Updated PWA manifest with correct branding

### 7. UI/UX Enhancements
- External link icons (↗) on all Shopee CTAs
- Shopee-aligned orange accent color (#ED5833)
- "Available on Shopee" badges and labels
- Consistent aspect ratios for product images
- Prevented text truncation on product names
- Clean, trustworthy visual hierarchy

## Required Configuration

### Step 1: Update Shopee Product URLs

Open `lib/main.dart` and update the `_launchShopeeUrl` function with your actual Shopee store URLs:

```dart
Future<void> _launchShopeeUrl(String productId, BuildContext context) async {
  // Replace with your actual Shopee store URL structure
  final uri = Uri.parse('https://shopee.ph/your-store-name/$productId');
  // ... rest of function
}
```

### Step 2: Map Product IDs to Shopee URLs

Create a mapping for each product:

```dart
String _getShopeeUrlForProduct(int productIndex) {
  final productMap = {
    0: 'https://shopee.ph/RoboArm-X1-i.123456.789012',
    1: 'https://shopee.ph/DroneEye-360-i.123456.789013',
    2: 'https://shopee.ph/AutoBot-Z-i.123456.789014',
    // Add all your products here
  };
  
  return productMap[productIndex] ?? 'https://shopee.ph/your-default-store';
}
```

### Step 3: Update Branding

In `lib/main.dart` and `lib/about_page.dart`, replace:
- "COMPANY NAME" with your actual company name
- "Company Name" in About page
- Update the hero section messaging if needed

### Step 4: Update Contact Information

In `lib/main.dart`, update the support email:
```dart
_launchEmail('support@company.com', subject: 'Support request');
```
Replace with your actual support email.

### Step 5: Install Dependencies

Run the following command to install updated dependencies:
```bash
flutter pub get
```

## Testing Checklist

- [ ] All "Buy on Shopee" buttons open correct Shopee product pages
- [ ] External links open in new tab/window (not in-app browser)
- [ ] Error messages display correctly if Shopee link fails
- [ ] Disclosure messaging is visible on all key pages
- [ ] No cart/checkout functionality remains accessible
- [ ] Mobile responsive design works correctly
- [ ] SEO metadata is accurate in browser tab and social shares

## Product Management Workflow

### Adding New Products
1. Add product data to the product lists in `lib/main.dart`
2. Map the product index to its Shopee URL in your URL mapping function
3. Update product images/icons as needed
4. Test the Shopee redirect functionality

### Updating Product Information
- Product names, descriptions, and prices are display-only
- Actual pricing and inventory managed on Shopee
- Keep website display prices synchronized with Shopee listings

## Performance Optimizations

### Completed
- Removed Provider dependency (reduced bundle size)
- Removed cart state management overhead
- Simplified navigation (no cart routes)
- Direct external linking (faster than in-app navigation)

### Recommended
- Implement lazy loading for product grid images
- Use cached network images for product photos
- Enable Flutter web renderer optimization flags during build:
  ```bash
  flutter build web --release --web-renderer canvaskit
  ```

## Deployment

### Build for Production
```bash
flutter clean
flutter pub get
flutter build web --release
```

### Deploy
The output will be in the `build/web` directory. Deploy to:
- GitHub Pages
- Firebase Hosting
- Netlify
- Vercel
- Any static hosting provider

### Environment Variables (Optional)
Consider adding a `.env` file for:
- Shopee store base URL
- Analytics IDs
- Feature flags

## Compliance & Legal

### Recommended Additions
1. **Terms of Service**: Link to Shopee's terms for transactions
2. **Privacy Policy**: Clarify that purchases occur on Shopee
3. **Return Policy**: Link to Shopee's return/refund policies
4. **Shipping Information**: Link to Shopee's shipping details

### Shopee Partnership
- Verify compliance with Shopee's affiliate/referral program terms
- Consider implementing Shopee affiliate tracking if applicable
- Add Shopee branding/badges if required by partnership agreement

## Support & Maintenance

### Common Issues
1. **Links not opening**: Check url_launcher package is installed
2. **Wrong products loading**: Verify product ID mapping
3. **Styling inconsistencies**: Check AppTokens in design_tokens.dart

### Future Enhancements
- [ ] Add product categories/filters
- [ ] Implement search functionality
- [ ] Add customer testimonials from Shopee reviews
- [ ] Create promotional landing pages
- [ ] Add email capture for notifications
- [ ] Integrate Shopee API for live inventory (if available)

## Contact
For questions about this implementation:
- Review the code comments in `lib/main.dart` and `lib/product_details_page.dart`
- Check Flutter documentation: https://flutter.dev/docs
- url_launcher package: https://pub.dev/packages/url_launcher

---

**Last Updated**: January 17, 2026  
**Flutter Version**: Compatible with Flutter 2.17.0 and above  
**Target Platform**: Web (Primary), with mobile support via url_launcher
