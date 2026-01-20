import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'about_page.dart';
import 'design_tokens.dart';
import 'product_details_page.dart';

Future<void> _launchEmail(String email, {String subject = ''}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: subject.isNotEmpty ? {'subject': subject} : null,
  );
  if (!await launchUrl(uri)) {
    // ignore: use_build_context_synchronously
    // couldn't launch mail app - show snackbar via context when available
  }
}

/// Launch Shopee product URL in external browser
Future<void> _launchShopeeUrl(String productId, BuildContext context) async {
  // Example Shopee URL structure - replace with actual store URLs
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

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTokens.appTheme,
      home: const MainAppWrapper(),
    ),
  );
}

// Main wrapper with persistent header
class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StorePage(),
    const AboutPage(),
  ];

  final List<String> _pageTitles = [
    'WELCOME',
    'STORE - COMPANY NAME',
    'ABOUT',
  ];

  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTokens.colorDarkGrey,
        title: ShinyText(
          text: _pageTitles[_currentPageIndex],
          speed: 3,
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 16 : 22,
            fontWeight: FontWeight.w800,
            color: AppTokens.colorLightGrey,
          ),
        ),
        actions: isMobile ? [
          PopupMenuButton<int>(
            icon: Icon(Icons.menu, color: AppTokens.colorWhite),
            onSelected: (index) => _navigateToPage(index),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text('Home', style: TextStyle(
                  color: _currentPageIndex == 0 ? AppTokens.colorOrange : AppTokens.colorBlack,
                  fontWeight: _currentPageIndex == 0 ? FontWeight.bold : FontWeight.normal,
                )),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Store', style: TextStyle(
                  color: _currentPageIndex == 1 ? AppTokens.colorOrange : AppTokens.colorBlack,
                  fontWeight: _currentPageIndex == 1 ? FontWeight.bold : FontWeight.normal,
                )),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('About', style: TextStyle(
                  color: _currentPageIndex == 2 ? AppTokens.colorOrange : AppTokens.colorBlack,
                  fontWeight: _currentPageIndex == 2 ? FontWeight.bold : FontWeight.normal,
                )),
              ),
            ],
          ),
        ] : [
          TextButton(
            onPressed: _currentPageIndex == 0 ? null : () => _navigateToPage(0),
            child: Text('Home', style: AppTokens.labelLarge.copyWith(
              color: _currentPageIndex == 0 ? AppTokens.colorOrange : AppTokens.colorWhite,
            )),
          ),
          TextButton(
            onPressed: _currentPageIndex == 1 ? null : () => _navigateToPage(1),
            child: Text('Store', style: AppTokens.labelLarge.copyWith(
              color: _currentPageIndex == 1 ? AppTokens.colorOrange : AppTokens.colorWhite,
            )),
          ),
          TextButton(
            onPressed: () {
              _launchEmail('support@company.com', subject: 'Support request');
            },
            child: Text('Contact', style: AppTokens.labelLarge.copyWith(
              color: AppTokens.colorWhite,
            )),
          ),
          TextButton(
            onPressed: _currentPageIndex == 2 ? null : () => _navigateToPage(2),
            child: Text('About', style: AppTokens.labelLarge.copyWith(
              color: _currentPageIndex == 2 ? AppTokens.colorOrange : AppTokens.colorWhite,
            )),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pages,
      ),
    );
  }
}

// Product model for featured carousel
class FeaturedProduct {
  final String name;
  final String description;
  final String price;
  final IconData icon;

  FeaturedProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

// Featured Products Carousel
class FeaturedProductsCarousel extends StatefulWidget {
  const FeaturedProductsCarousel({super.key});

  @override
  State<FeaturedProductsCarousel> createState() =>
      _FeaturedProductsCarouselState();
}

class _FeaturedProductsCarouselState extends State<FeaturedProductsCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<FeaturedProduct> featuredProducts = [
    FeaturedProduct(
      name: 'Most Bought Product',
      description:
          'RoboArm X1 - Precision robotic arm with adaptive AI control.',
      price: '₱24,999',
      icon: Icons.precision_manufacturing,
    ),
    FeaturedProduct(
      name: 'Most Popular Product',
      description:
          'DroneEye 360 - Autonomous drone with panoramic navigation sensors.',
      price: '₱49,999',
      icon: Icons.flight,
    ),
    FeaturedProduct(
      name: 'Recommended Product',
      description:
          'AutoBot Z - Self-learning mobile assistant robot for industrial use.',
      price: '₱149,999',
      icon: Icons.smart_toy,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      final nextPage = (_currentIndex + 1) % featuredProducts.length;
      _pageController.animateToPage(
        nextPage,
        duration: AppTokens.transitionSlow,
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppTokens.spacingXl),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTokens.spacingMd),
          child: Text(
            'Featured Selection',
            style: AppTokens.headingMedium,
          ),
        ),
        SizedBox(height: AppTokens.spacingMd),
        SizedBox(
          height: MediaQuery.of(context).size.width < 600 ? 350 : 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTokens.spacingSm),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTokens.colorWhite,
                    borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppTokens.colorBlack.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(AppTokens.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  AppTokens.colorOrange.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTokens.radiusMd),
                            ),
                            child: Icon(
                              product.icon,
                              size: 36,
                              color: AppTokens.colorOrange,
                            ),
                          ),
                          SizedBox(height: AppTokens.spacingSm),
                          Text(
                            product.name,
                            style: AppTokens.headingSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppTokens.spacingXs),
                          Text(
                            product.description,
                            style: AppTokens.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.price,
                            style: AppTokens.priceTag,
                          ),
                          SizedBox(height: AppTokens.spacingSm),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTokens.colorOrange,
                                foregroundColor: AppTokens.colorWhite,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppTokens.spacingSm,
                                ),
                              ),
                              onPressed: () {
                                _launchShopeeUrl('featured-$index', context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Buy on Shopee',
                                    style: AppTokens.labelLarge,
                                  ),
                                  SizedBox(width: AppTokens.spacingXs),
                                  Icon(Icons.open_in_new, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppTokens.spacingMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            featuredProducts.length,
            (index) => AnimatedContainer(
              duration: AppTokens.transitionFast,
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppTokens.colorOrange
                    : AppTokens.colorLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: AppTokens.spacingXl),
      ],
    );
  }
}

// StoreMenuButton with hover dropdown animation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final height = MediaQuery.of(context).size.height - kToolbarHeight;
        final isMobile = MediaQuery.of(context).size.width < 600;
        // Stack: fixed hero at top, scrollable content beneath it
        return Stack(
          children: [
            // Fixed hero banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: height,
                padding: EdgeInsets.symmetric(horizontal: AppTokens.spacingLg),
                color: AppTokens.colorOrange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSplitText(
                      text: 'Discover the Future of Robotics',
                      style: isMobile 
                        ? AppTokens.headingMedium 
                        : AppTokens.headingLarge,
                    ),
                    SizedBox(height: AppTokens.spacingSm),
                    // This TextType stays fixed at the top now
                    TextType(
                      text: [
                        'Browse our catalog. All purchases securely completed on Shopee.'
                      ],
                      typingSpeed: 40,
                      pauseDuration: 1800,
                      textStyle: AppTokens.bodyLarge,
                    ),
                    SizedBox(height: AppTokens.spacingSm),
                    // Shopee Disclosure Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTokens.spacingMd,
                        vertical: AppTokens.spacingSm,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.colorWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        border: Border.all(
                          color: AppTokens.colorWhite.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag, color: AppTokens.colorWhite, size: 20),
                          SizedBox(width: AppTokens.spacingXs),
                          Text(
                            'Available on Shopee',
                            style: AppTokens.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppTokens.spacingLg),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTokens.colorWhite,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppTokens.spacingLg,
                              vertical: AppTokens.spacingMd),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTokens.radiusXl))),
                      onPressed: () {
                        // Navigation handled by MainAppWrapper
                        final mainState = context.findAncestorStateOfType<_MainAppWrapperState>();
                        mainState?._navigateToPage(1);
                      },
                      child: Text('Browse Catalog',
                          style: GoogleFonts.poppins(
                              color: AppTokens.colorOrange,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable content below the fixed hero
            Positioned.fill(
              top: height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppTokens.spacingXl),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppTokens.spacingMd),
                      child: Text('Featured Products',
                          style: AppTokens.headingMedium),
                    ),
                    SizedBox(height: AppTokens.spacingSm),
                    SizedBox(height: 260, child: const FutureProductCarousel()),
                    SizedBox(height: AppTokens.spacingLg),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const StorePage()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTokens.colorOrange),
                        child: Text('View All Products',
                            style: AppTokens.labelLarge),
                      ),
                    ),
                    SizedBox(height: AppTokens.spacing2xl),
                    // CTA
                    Container(
                      width: double.infinity,
                      color: AppTokens.colorDarkGrey,
                      padding: EdgeInsets.symmetric(
                          vertical: AppTokens.spacingXl,
                          horizontal: AppTokens.spacingLg),
                      child: Column(
                        children: [
                          Text('Join the Future of Robotics',
                              style: AppTokens.headingSmall),
                          SizedBox(height: AppTokens.spacingXs),
                          Text(
                              'Collaborate, invest, or explore our latest breakthroughs in AI automation.',
                              style: AppTokens.bodyLarge),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class FutureProductCarousel extends StatefulWidget {
  const FutureProductCarousel({super.key});

  @override
  State<FutureProductCarousel> createState() => _FutureProductCarouselState();
}

class _FutureProductCarouselState extends State<FutureProductCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _index = 0;

  final List<Map<String, String>> featuredProducts = [
    {
      'name': 'RoboArm X1',
      'desc': 'Precision robotic arm with adaptive AI control.',
      'price': '₱24,999'
    },
    {
      'name': 'DroneEye 360',
      'desc': 'Autonomous drone with panoramic navigation sensors.',
      'price': '₱49,999'
    },
    {
      'name': 'AutoBot Z',
      'desc': 'Self-learning mobile assistant robot for industrial use.',
      'price': '₱149,999'
    },
  ];

  @override
  void initState() {
    super.initState();
    // simple auto-scroll
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    _index = (_index + 1) % featuredProducts.length;
    _controller.animateToPage(_index,
        duration: AppTokens.transitionSlow, curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: featuredProducts.length,
            onPageChanged: (idx) => setState(() => _index = idx),
            itemBuilder: (context, i) {
              final p = featuredProducts[i];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppTokens.spacingSm,
                    vertical: AppTokens.spacingXs),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTokens.colorOrange,
                    borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    border: Border.all(color: AppTokens.colorOrange),
                  ),
                  padding: EdgeInsets.all(AppTokens.spacingMd),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.smart_toy,
                          size: 52, color: AppTokens.colorWhite),
                      SizedBox(height: AppTokens.spacingSm),
                      Text(p['name']!, style: AppTokens.headingSmall),
                      SizedBox(height: AppTokens.spacingXs),
                      Text(p['desc']!,
                          textAlign: TextAlign.center,
                          style: AppTokens.bodyLarge),
                      SizedBox(height: AppTokens.spacingSm),
                      Text(p['price']!, style: AppTokens.priceTag),
                      SizedBox(height: AppTokens.spacingSm),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTokens.colorWhite,
                          foregroundColor: AppTokens.colorOrange,
                        ),
                        onPressed: () {
                          _launchShopeeUrl('featured-product-$i', context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('View on Shopee', style: AppTokens.labelLarge),
                            SizedBox(width: AppTokens.spacingXs),
                            Icon(Icons.open_in_new, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppTokens.spacingSm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(featuredProducts.length, (i) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _index == i ? 14 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _index == i
                    ? AppTokens.colorOrange
                    : AppTokens.colorLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// StoreMenuButton with hover dropdown animation
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
                      onTap: () {
                        // Add navigation or action here
                      },
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

class AnimatedSplitText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration duration;

  const AnimatedSplitText({
    super.key,
    required this.text,
    required this.style,
    this.delay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSplitText> createState() => _AnimatedSplitTextState();
}

class _AnimatedSplitTextState extends State<AnimatedSplitText>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _opacities;
  late final List<Animation<Offset>> _offsets;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.text.length, (i) {
      return AnimationController(vsync: this, duration: widget.duration);
    });
    _opacities = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
    _offsets = _controllers
        .map((c) => Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
    _run();
  }

  Future<void> _run() async {
    for (final c in _controllers) {
      await Future.delayed(widget.delay);
      if (!mounted) return;
      c.forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(widget.text.length, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) {
            return Opacity(
              opacity: _opacities[i].value,
              child: Transform.translate(
                offset: _offsets[i].value * 10,
                child: Text(widget.text[i], style: widget.style),
              ),
            );
          },
        );
      }),
    );
  }
}

// Typing animation used in StorePage and elsewhere
class TextType extends StatefulWidget {
  final List<String> text;
  final int typingSpeed; // ms per character
  final int pauseDuration; // ms between texts
  final bool showCursor;
  final String cursorCharacter;
  final TextStyle? textStyle;

  const TextType({
    super.key,
    required this.text,
    this.typingSpeed = 75,
    this.pauseDuration = 1500,
    this.showCursor = true,
    this.cursorCharacter = '|',
    this.textStyle,
  });

  @override
  State<TextType> createState() => _TextTypeState();
}

class _TextTypeState extends State<TextType> {
  int _textIndex = 0;
  int _charIndex = 0;
  String _displayed = '';
  bool _typing = true;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  Future<void> _startTyping() async {
    if (widget.text.isEmpty) return;
    while (mounted) {
      final current = widget.text[_textIndex % widget.text.length];
      while (_charIndex < current.length) {
        await Future.delayed(Duration(milliseconds: widget.typingSpeed));
        if (!mounted) return;
        setState(() {
          _charIndex++;
          _displayed = current.substring(0, _charIndex);
        });
      }
      // finished one word
      await Future.delayed(Duration(milliseconds: widget.pauseDuration));
      if (!mounted) return;
      setState(() {
        _textIndex = (_textIndex + 1) % widget.text.length;
        _charIndex = 0;
        _displayed = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.showCursor
          ? '$_displayed${_typing ? widget.cursorCharacter : ''}'
          : _displayed,
      style: widget.textStyle ??
          GoogleFonts.poppins(
              fontSize: 18,
              color: const Color(0xFFED5833),
              fontWeight: FontWeight.w600),
    );
  }
}

// StorePage - Browse catalog with Shopee redirects
class StorePage extends StatelessWidget {
  const StorePage({super.key});

  static int _getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1; // Mobile: 1 column
    if (width < 900) return 2; // Tablet: 2 columns
    return 3; // Desktop: 3 columns
  }

  @override
  Widget build(BuildContext context) {
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
                    "Browse Our Catalog",
                    "Find Your Perfect Product",
                    "Shop on Shopee",
                    "Secure Checkout on Shopee"
                  ],
                  typingSpeed: 75,
                  pauseDuration: 1500,
                  showCursor: true,
                  cursorCharacter: "|",
                  textStyle: AppTokens.headingSmall.copyWith(
                    color: AppTokens.colorOrange,
                  ),
                ),
              ),
            ),
          ),
        ),
          SliverPadding(
            padding: EdgeInsets.all(AppTokens.spacingLg),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedProductCard(
                      index: index, delay: Duration.zero);
                },
                childCount: 30,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: StorePage._getGridColumns(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Header delegate used for the pinned animated banner in StorePage

// Add this widget below _ProductCard:
class AnimatedProductCard extends StatefulWidget {
  final int index;
  final Duration delay;
  const AnimatedProductCard(
      {super.key, required this.index, required this.delay});

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTokens.transitionFast,
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _offset =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    // Start immediately (no staggered per-item delay) to keep fade duration
    // consistent across product widgets per QA requirements.
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: PixelTransitionCard(index: widget.index),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final int index;
  const _ProductCard({required this.index});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: AppTokens.transitionFast,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppTokens.colorLightGrey,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: AppTokens.colorOrange.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTokens.colorBlack.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: _hovering
              ? Border.all(color: AppTokens.colorOrange, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        margin: EdgeInsets.all(AppTokens.spacing2xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Middle clickable area - Opens Product Details Page
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        productIndex: widget.index,
                        productName: 'Product ${widget.index + 1}',
                        productDesc: 'High-quality robotic product with advanced features and capabilities. Perfect for industrial automation and smart manufacturing solutions.',
                        productPrice: '₱9,999',
                        shopeeUrl: 'https://shopee.ph/product/product-${widget.index}',
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTokens.radiusLg),
                ),
                child: Container(
                  padding: EdgeInsets.all(AppTokens.spacingSm),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.smart_toy, size: 48, color: AppTokens.colorOrange),
                      SizedBox(height: AppTokens.spacingSm),
                      Text(
                        'Product ${widget.index + 1}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppTokens.colorBlack,
                        ),
                      ),
                      SizedBox(height: AppTokens.spacingXs),
                      Text(
                        '₱9,999',
                        style: GoogleFonts.openSans(
                          color: AppTokens.colorBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: AppTokens.spacingXs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTokens.spacingSm,
                          vertical: AppTokens.spacing2xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppTokens.colorOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                          border: Border.all(
                            color: AppTokens.colorOrange,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'View Product',
                          style: GoogleFonts.openSans(
                            color: AppTokens.colorOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom button - Opens Shopee directly
            Padding(
              padding: EdgeInsets.all(AppTokens.spacingSm),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _launchShopeeUrl('product-${widget.index}', context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.colorOrange,
                    foregroundColor: AppTokens.colorWhite,
                    padding: EdgeInsets.symmetric(
                      vertical: AppTokens.spacingSm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_bag, size: 16),
                      SizedBox(width: AppTokens.spacingXs),
                      Text('Buy Now', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this widget above your pages:
class ShinyText extends StatefulWidget {
  final String text;
  final double speed;
  final TextStyle? style;
  final bool disabled;

  const ShinyText({
    super.key,
    required this.text,
    this.speed = 3,
    this.style,
    this.disabled = false,
  });

  @override
  State<ShinyText> createState() => _ShinyTextState();
}

class _ShinyTextState extends State<ShinyText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: AppTokens.transitionSlow)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return Text(widget.text, style: widget.style);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                AppTokens.colorLightGrey,
                AppTokens.colorOrange,
                AppTokens.colorLightGrey
              ],
              stops: [
                (_controller.value - 0.2).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.2).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style ??
                const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        );
      },
    );
  }
}

class PixelTransitionCard extends StatefulWidget {
  final int index;
  const PixelTransitionCard({super.key, required this.index});

  @override
  State<PixelTransitionCard> createState() => _PixelTransitionCardState();
}

class _PixelTransitionCardState extends State<PixelTransitionCard>
    with SingleTickerProviderStateMixin {
  bool _hovering = false;
  // Replaced tiled pixel animation with a simple fade overlay.
  // _hovering controls showing the overlay via AnimatedOpacity.
  late final AnimationController _bounceController;
  late final Animation<double> _scale;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: AppTokens.transitionNormal,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeOut));
    _startBounceLoop();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _startBounceLoop() async {
    while (mounted) {
      final seconds = 2 + _random.nextInt(7); // 2..8s
      await Future.delayed(Duration(seconds: seconds));
      if (!mounted) break;
      try {
        await _bounceController.forward();
        await _bounceController.reverse();
      } catch (_) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovering = true);
      },
      onExit: (_) {
        setState(() => _hovering = false);
      },
      child: AnimatedContainer(
        duration: AppTokens.transitionSlow,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _hovering
                ? [AppTokens.colorOrange, AppTokens.colorTeal]
                : [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: AppTokens.colorOrange.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTokens.colorBlack.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: _hovering
              ? Border.all(color: AppTokens.colorOrange, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        margin: EdgeInsets.all(AppTokens.spacing2xs),
        child: Column(
          children: [
            // Middle clickable section - Opens Product Details Page
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        productIndex: widget.index,
                        productName: 'Product ${widget.index + 1}',
                        productDesc: 'High-quality robotic product with advanced features and capabilities. Perfect for industrial automation and smart manufacturing solutions.',
                        productPrice: '₱9,999',
                        shopeeUrl: 'https://shopee.ph/product/product-${widget.index}',
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radiusLg)),
                child: AnimatedOpacity(
                  opacity: _hovering ? 0.3 : 1.0,
                  duration: AppTokens.transitionFast,
                  child: Container(
                    padding: EdgeInsets.all(AppTokens.spacingSm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.smart_toy,
                            size: 48, color: AppTokens.colorOrange),
                        SizedBox(height: AppTokens.spacingSm),
                        Text('Product ${widget.index + 1}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppTokens.colorBlack)),
                        SizedBox(height: AppTokens.spacingXs),
                        Text('₱9,999',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTokens.colorBlack)),
                        SizedBox(height: AppTokens.spacingSm),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTokens.spacingLg,
                            vertical: AppTokens.spacingSm,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTokens.colorOrange,
                                AppTokens.colorOrange.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                            boxShadow: [
                              BoxShadow(
                                color: AppTokens.colorOrange.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.visibility,
                                color: AppTokens.colorWhite,
                                size: 16,
                              ),
                              SizedBox(width: AppTokens.spacingXs),
                              Text(
                                'View Product',
                                style: GoogleFonts.poppins(
                                  color: AppTokens.colorWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom button - Opens Shopee (1/3 width)
            Padding(
              padding: EdgeInsets.only(
                left: AppTokens.spacingSm,
                right: AppTokens.spacingSm,
                bottom: AppTokens.spacingSm,
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.65,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchShopeeUrl('product-${widget.index}', context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTokens.colorOrange,
                      foregroundColor: AppTokens.colorWhite,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTokens.spacingXs,
                        vertical: AppTokens.spacingXs,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_bag, size: 14),
                        SizedBox(width: 4),
                        Text('Buy Now', style: GoogleFonts.openSans(fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
