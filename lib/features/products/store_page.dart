import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/theme/design_tokens.dart';
import '../../shared/widgets/app_footer.dart';
import '../../shared/widgets/typing_text.dart';
import 'product_actions.dart';
import 'product_data.dart';
import 'product_details_page.dart';

Future<void> _launchFooterUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Could not open link')));
  }
}

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  static int _getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final columns = StorePage._getGridColumns(context);
    final horizontalPadding = AppTokens.spacingLg;
    const crossAxisSpacing = 16.0;
    const mainAxisSpacing = 16.0;
    const childAspectRatio = 0.8;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: false,
            backgroundColor: AppTokens.colorBlack,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                color: AppTokens.colorBlack,
                child: Center(
                  child: TextType(
                    text: [
                      'Browse Our Catalog',
                      'Find Your Perfect Product',
                      'Shop on Shopee',
                      'Secure Checkout on Shopee'
                    ],
                    typingSpeed: 75,
                    pauseDuration: 1500,
                    showCursor: true,
                    cursorCharacter: '|',
                    textStyle: AppTokens.headingSmall.copyWith(
                      color: AppTokens.colorOrange,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(horizontalPadding),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = kStoreProducts[index];
                  return ProductCard(
                    index: index,
                    product: product,
                  );
                },
                childCount: kStoreProducts.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                childAspectRatio: childAspectRatio,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AppFooter(
              onLaunch: (url) => _launchFooterUrl(context, url),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final int index;
  final StoreProduct product;
  const ProductCard({
    super.key,
    required this.index,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppTokens.transitionNormal,
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -10 : 0, 0),
        decoration: BoxDecoration(
          color: AppTokens.colorDarkGrey,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          border: Border.all(
            color: AppTokens.colorWhite.withValues(alpha: 0.85),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTokens.colorBlack.withValues(
                alpha: _isHovered ? 0.32 : 0.18,
              ),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
          ],
        ),
        margin: EdgeInsets.all(AppTokens.spacing2xs),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    productIndex: widget.index,
                    productName: widget.product.name,
                    productDesc: widget.product.description,
                    productPrice: widget.product.price,
                    shopeeUrl: widget.product.shopeeUrl,
                    imagePaths: widget.product.imagePaths,
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: widget.product.imagePaths.isEmpty
                      ? Container(
                          color: AppTokens.colorBlack,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.smart_toy,
                            size: 72,
                            color: AppTokens.colorWhite.withValues(alpha: 0.78),
                          ),
                        )
                      : Image.asset(
                          widget.product.imagePaths.first,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppTokens.colorBlack,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.smart_toy,
                              size: 72,
                              color:
                                  AppTokens.colorWhite.withValues(alpha: 0.78),
                            ),
                          ),
                        ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.75),
                          Colors.black.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(AppTokens.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          widget.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppTokens.colorWhite,
                            fontSize: 32,
                          ),
                        ),
                        SizedBox(height: AppTokens.spacing2xs),
                        Text(
                          widget.product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            color: AppTokens.colorWhite.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppTokens.spacingSm),
                        Text(
                          widget.product.price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            color: AppTokens.colorWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(height: AppTokens.spacingSm),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              launchShopeeUrl(widget.product.shopeeId, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTokens.colorWhite,
                              foregroundColor: AppTokens.colorBlack,
                              padding: EdgeInsets.symmetric(
                                vertical: AppTokens.spacingSm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppTokens.radiusMd),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shopping_bag, size: 16),
                                SizedBox(width: AppTokens.spacingXs),
                                Text(
                                  'Buy Now',
                                  style: GoogleFonts.openSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class StoreMenuButton extends StatefulWidget {
  const StoreMenuButton({super.key});

  @override
  State<StoreMenuButton> createState() => _StoreMenuButtonState();
}

class _StoreMenuButtonState extends State<StoreMenuButton> {
  OverlayEntry? _dropdownOverlay;
  final LayerLink _layerLink = LayerLink();

  final List<String> componentTypes = [
    'Insert type of component here 1',
    'Insert type of component here 2',
    'Insert type of component here 3',
    'Insert type of component here 4',
    'Insert type of component here 5',
  ];

  void _showDropdown() {
    if (_dropdownOverlay != null) return;
    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 180,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 40),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFED5833),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(componentTypes.length, (index) {
                    return ListTile(
                      title: Text(
                        componentTypes[index],
                        style: const TextStyle(color: Color(0xFFE3EEF1)),
                      ),
                      onTap: () {},
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _showDropdown(),
        onExit: (_) => _hideDropdown(),
        child: TextButton(
          onPressed: () {},
          child: const Text('Store', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

