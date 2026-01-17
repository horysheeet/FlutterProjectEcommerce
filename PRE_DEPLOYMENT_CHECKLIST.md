# ✅ Pre-Deployment Checklist

## Critical Items (Must Complete)

### 1. Shopee URLs Configuration
- [ ] Updated all product URLs in `lib/main.dart`
- [ ] Created product-to-URL mapping function
- [ ] Tested at least 5 product redirects manually
- [ ] Verified URLs open in new tab/window
- [ ] Confirmed correct Shopee products load

**Files to Check**:
- `lib/main.dart` (search for `_launchShopeeUrl`)

---

### 2. Branding Updates
- [ ] Replaced "COMPANY NAME" with actual business name
- [ ] Updated "Company Name" in About page
- [ ] Changed support email from `support@company.com`
- [ ] Updated company description (if needed)
- [ ] Verified logo/branding assets are correct

**Files to Check**:
- `lib/main.dart` (search for "COMPANY NAME")
- `lib/about_page.dart` (search for "Company Name")

---

### 3. Content Review
- [ ] All product names are accurate
- [ ] Product descriptions match Shopee listings
- [ ] Prices are current and match Shopee
- [ ] No placeholder text remains (Lorem Ipsum, etc.)
- [ ] Contact information is correct

**Files to Check**:
- `lib/main.dart` (product data structures)
- `lib/about_page.dart` (company info)

---

### 4. Functionality Testing
- [ ] Homepage loads without errors
- [ ] Store page displays all products
- [ ] About page renders correctly
- [ ] Support chat opens and functions
- [ ] Contact email link works
- [ ] All "Buy on Shopee" buttons redirect correctly

**Test Commands**:
```bash
flutter run -d chrome
# Or
flutter run -d edge  # Windows
```

---

### 5. Mobile Responsiveness
- [ ] Homepage looks good on mobile
- [ ] Product grid adjusts for small screens
- [ ] Buttons are tappable on mobile
- [ ] Text is readable without zooming
- [ ] Navigation works on mobile

**Test Commands**:
```bash
flutter run -d chrome --web-browser-flag "--device-scale-factor=2"
```

---

## Important Items (Strongly Recommended)

### 6. SEO & Metadata
- [ ] Page title is accurate in browser tab
- [ ] Meta description reflects Shopee redirect
- [ ] Social sharing preview looks correct
- [ ] Favicon displays properly
- [ ] PWA manifest is configured

**Files to Check**:
- `web/index.html`
- `web/manifest.json`

---

### 7. Error Handling
- [ ] Tested broken Shopee URL (error message displays)
- [ ] Verified error messages are user-friendly
- [ ] Checked that app doesn't crash on link failure
- [ ] Error colors match design system

**Test**: Try loading with invalid URL temporarily

---

### 8. Performance Check
- [ ] Initial page load is < 3 seconds
- [ ] Images load progressively
- [ ] No console errors in browser DevTools
- [ ] No memory leaks (check DevTools)
- [ ] Animations are smooth

**Test Commands**:
```bash
flutter build web --release
flutter run --release -d chrome
```

---

### 9. Legal Compliance
- [ ] Disclosure about Shopee purchasing is visible
- [ ] No misleading CTAs remain
- [ ] Terms of Service linked (if available)
- [ ] Privacy Policy linked (if available)
- [ ] Return policy references Shopee

**Files to Check**:
- All pages for disclosure messaging

---

## Optional Items (Nice to Have)

### 10. Analytics Setup
- [ ] Google Analytics installed (if using)
- [ ] Shopee affiliate tracking configured (if applicable)
- [ ] Click tracking on "Buy on Shopee" buttons
- [ ] Page view tracking enabled

---

### 11. Additional Pages
- [ ] FAQ page created (optional)
- [ ] Privacy Policy page added
- [ ] Terms of Service page added
- [ ] Shipping information linked to Shopee
- [ ] Return policy linked to Shopee

---

### 12. Advanced Features
- [ ] Search functionality added
- [ ] Product filtering implemented
- [ ] Category navigation added
- [ ] Email capture form (if desired)
- [ ] Newsletter signup (if desired)

---

## Build & Deploy Checklist

### 13. Build Process
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run `flutter pub outdated` (review updates)
- [ ] Run `flutter analyze` (zero errors)
- [ ] Build for web: `flutter build web --release`
- [ ] Check build/web folder exists and is populated

**Commands**:
```bash
flutter clean
flutter pub get
flutter analyze
flutter build web --release --web-renderer canvaskit
```

---

### 14. Pre-Deploy Testing
- [ ] Test built site locally
- [ ] Check network tab (no 404s)
- [ ] Verify asset loading (fonts, images)
- [ ] Test on multiple browsers (Chrome, Firefox, Safari, Edge)
- [ ] Test on mobile browser

**Local Server Test**:
```bash
cd build/web
python -m http.server 8080
# Open http://localhost:8080
```

---

### 15. Deployment
- [ ] Choose hosting platform (GitHub Pages / Firebase / Netlify / Vercel)
- [ ] Configure custom domain (if applicable)
- [ ] Set up SSL certificate (HTTPS)
- [ ] Test deployed site URL
- [ ] Verify all assets load on deployed site

**Popular Hosts**:
- GitHub Pages: https://pages.github.com
- Firebase: `firebase deploy`
- Netlify: Drag & drop build/web folder
- Vercel: `vercel --prod`

---

### 16. Post-Deploy Verification
- [ ] Visit deployed URL
- [ ] Click through all navigation links
- [ ] Test 5+ product redirects to Shopee
- [ ] Check on mobile device
- [ ] Share link to test social media preview
- [ ] Monitor for errors first 24 hours

---

## Final Checks

### 17. Documentation
- [ ] README updated with project info
- [ ] SHOPEE_SETUP.md reviewed
- [ ] TRANSFORMATION_SUMMARY.md saved for reference
- [ ] SHOPEE_URL_GUIDE.md bookmarked for future updates
- [ ] Deployment notes documented

---

### 18. Backup & Version Control
- [ ] All changes committed to Git
- [ ] Tagged current version (e.g., v1.0.0-shopee)
- [ ] Pushed to remote repository
- [ ] Created backup of build/web folder
- [ ] Documented any custom configurations

**Git Commands**:
```bash
git add .
git commit -m "Transform to Shopee outbound storefront"
git tag -a v1.0.0-shopee -m "Shopee integration complete"
git push origin main --tags
```

---

### 19. Team Communication
- [ ] Notified team of deployment
- [ ] Shared deployed URL
- [ ] Provided access to documentation
- [ ] Scheduled review meeting (if applicable)
- [ ] Set up monitoring/alerting

---

### 20. Go-Live Preparation
- [ ] Announced launch date
- [ ] Prepared social media posts
- [ ] Updated email signatures with new link
- [ ] Notified Shopee store team (if separate)
- [ ] Set up feedback collection method

---

## Quick Test Script

Run this in browser console on deployed site:
```javascript
// Check for cart references (should be zero)
console.log('Cart references:', document.body.innerText.match(/cart/gi)?.length || 0);

// Check for Shopee references (should be many)
console.log('Shopee references:', document.body.innerText.match(/shopee/gi)?.length || 0);

// Check for external link icons
console.log('External link icons:', document.querySelectorAll('[data-icon="open_in_new"]').length);

// Test a Shopee link
const shopeeButton = document.querySelector('button:contains("Shopee")');
if (shopeeButton) {
  console.log('Shopee button found:', shopeeButton);
} else {
  console.warn('No Shopee button found - check implementation');
}
```

---

## Success Criteria

### Your site is ready to deploy when:
✅ All critical items (1-5) are complete  
✅ At least 80% of important items (6-9) are done  
✅ Build completes without errors  
✅ No console errors in browser  
✅ All Shopee redirects work correctly  
✅ Site looks professional on mobile and desktop  
✅ Load time is < 3 seconds  

---

## Emergency Rollback Plan

If issues occur post-deploy:

1. **Quick Fix**: Revert to previous Git commit
   ```bash
   git revert HEAD
   git push
   redeploy
   ```

2. **Temporary Maintenance Page**: Replace index.html with:
   ```html
   <html><body><h1>Under Maintenance</h1><p>Back soon!</p></body></html>
   ```

3. **Contact Support**:
   - Hosting platform support
   - Shopee Seller Support (for product issues)
   - Flutter community (for technical issues)

---

## Maintenance Schedule

### Daily (First Week)
- [ ] Monitor analytics
- [ ] Check error logs
- [ ] Review user feedback
- [ ] Test random Shopee redirects

### Weekly
- [ ] Update product prices if changed on Shopee
- [ ] Check for broken Shopee links
- [ ] Review site performance metrics

### Monthly
- [ ] Run `flutter pub outdated`
- [ ] Update dependencies if needed
- [ ] Review and refresh content
- [ ] Analyze traffic patterns

---

## Support Resources

- **Flutter Docs**: https://flutter.dev/docs
- **url_launcher**: https://pub.dev/packages/url_launcher
- **Shopee Seller**: https://seller.shopee.ph
- **This Project Docs**: See SHOPEE_SETUP.md and TRANSFORMATION_SUMMARY.md

---

**Last Updated**: January 17, 2026  
**Estimated Review Time**: 45-60 minutes  
**Priority**: Complete Critical Items before any deployment
