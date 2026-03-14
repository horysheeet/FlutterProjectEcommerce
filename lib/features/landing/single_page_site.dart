import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/services/analytics_service.dart';
import '../../shared/theme/design_tokens.dart';
import 'widgets/featured_product_carousel.dart';
import 'widgets/hero_section.dart';
import 'widgets/right_side_navigation.dart';
import 'widgets/store_section.dart';

enum SiteSection { home, store }

class SinglePageSite extends StatefulWidget {
  const SinglePageSite({super.key});

  @override
  State<SinglePageSite> createState() => _SinglePageSiteState();
}

class _SinglePageSiteState extends State<SinglePageSite>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final Map<SiteSection, GlobalKey> _sectionKeys = {
    SiteSection.home: GlobalKey(),
    SiteSection.store: GlobalKey(),
  };

  SiteSection _activeSection = SiteSection.home;
  bool _isCalculatingSection = false;
  bool _isHeaderVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.track('site_open', params: {'screen': 'single_page_site'});
      _handleScroll();
    });
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_isCalculatingSection || !_scrollController.hasClients || !mounted) {
      return;
    }

    _isCalculatingSection = true;
    final currentOffset = _scrollController.offset;
    final scrollingDown = currentOffset > _lastOffset + 2;
    final scrollingUp = currentOffset < _lastOffset - 2;
    final shouldShowHeader = currentOffset < 16 || scrollingUp;

    if (shouldShowHeader != _isHeaderVisible && (scrollingDown || scrollingUp || currentOffset < 16)) {
      setState(() => _isHeaderVisible = shouldShowHeader);
    }

    final viewportHeight = MediaQuery.of(context).size.height;
    final probeLine = currentOffset + viewportHeight * 0.35;

    SiteSection nextActive = _activeSection;
    double lastTop = -1;

    for (final section in SiteSection.values) {
      final sectionTop = _sectionTop(section);
      if (sectionTop == null) {
        continue;
      }
      if (sectionTop <= probeLine && sectionTop >= lastTop) {
        lastTop = sectionTop;
        nextActive = section;
      }
    }

    if (nextActive != _activeSection) {
      AnalyticsService.track(
        'section_view',
        params: {'section': nextActive.name},
      );
      setState(() => _activeSection = nextActive);
    }

    _lastOffset = currentOffset;
    _isCalculatingSection = false;
  }

  double? _sectionTop(SiteSection section) {
    final contextForSection = _sectionKeys[section]?.currentContext;
    if (contextForSection == null) return null;

    final renderObject = contextForSection.findRenderObject();
    if (renderObject is! RenderBox) return null;

    final position = renderObject.localToGlobal(Offset.zero).dy;
    return position + _scrollController.offset;
  }

  void _scrollToSection(SiteSection section) {
    final target = _sectionTop(section);
    if (target == null || !_scrollController.hasClients) return;

    AnalyticsService.track(
      'navigate_section',
      params: {'section': section.name},
    );

    final maxScroll = _scrollController.position.maxScrollExtent;
    final destination = math
      .max(0.0, math.min(target - AppTokens.spacingLg, maxScroll))
      .toDouble();

    _scrollController.animateTo(
      destination,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _launchUrl(String url) async {
    AnalyticsService.track(
      'outbound_link',
      params: {'url': url},
    );
    final uri = Uri.parse(url);
    final launchMode = uri.scheme == 'mailto'
        ? LaunchMode.platformDefault
        : LaunchMode.externalApplication;
    if (!await launchUrl(uri, mode: launchMode) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isTabletOrDesktop = width >= 768;
          final sideNavigationWidth = isTabletOrDesktop ? 90.0 : 0.0;
            final heroViewportHeight =
              (constraints.maxHeight - (AppTokens.spacing2xl * 2)).clamp(420.0, 2200.0);
            const headerHeight = 64.0;
          final horizontalPadding = width >= 1100
              ? AppTokens.spacing2xl * 2
              : width >= 768
                  ? AppTokens.spacing2xl
                  : AppTokens.spacingLg;

          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppTokens.spacing2xl + headerHeight,
                      horizontalPadding + sideNavigationWidth,
                      AppTokens.spacingXl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: HeroSection(
                        key: _sectionKeys[SiteSection.home],
                        sectionHeight: heroViewportHeight,
                        onBrowseStore: () {
                          AnalyticsService.track('hero_browse_store_click');
                          _scrollToSection(SiteSection.store);
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding + sideNavigationWidth,
                      AppTokens.spacing2xl,
                    ),
                    sliver: const SliverToBoxAdapter(
                      child: FeaturedProductCarousel(),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding + sideNavigationWidth,
                      AppTokens.spacingXl,
                    ),
                    sliver: const SliverToBoxAdapter(
                      child: _SectionDivider(),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding + sideNavigationWidth,
                      AppTokens.spacing2xl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: StoreSection(
                        key: _sectionKeys[SiteSection.store],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding + sideNavigationWidth,
                      AppTokens.spacingXl,
                    ),
                    sliver: const SliverToBoxAdapter(
                      child: _SectionDivider(),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding + sideNavigationWidth,
                      AppTokens.spacing2xl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _FooterSection(onLaunch: _launchUrl),
                    ),
                  ),
                ],
              ),
              if (isTabletOrDesktop)
                Positioned(
                  right: AppTokens.spacingLg,
                  top: 0,
                  bottom: 0,
                  child: RightSideNavigation(
                    activeSection: _activeSection,
                    onSelect: _scrollToSection,
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: AnimatedSlide(
                    duration: AppTokens.transitionNormal,
                    curve: Curves.easeInOut,
                    offset: _isHeaderVisible ? Offset.zero : const Offset(0, -1.2),
                    child: AnimatedOpacity(
                      duration: AppTokens.transitionNormal,
                      opacity: _isHeaderVisible ? 1 : 0,
                      child: const _TopHeader(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppTokens.spacingLg,
        AppTokens.spacingXs,
        AppTokens.spacingLg,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.spacingMd,
        vertical: AppTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppTokens.colorDarkGrey.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTokens.radiusXl),
        border: Border.all(
          color: AppTokens.colorWhite.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Text(
            'MICROBOT',
            style: AppTokens.labelLarge.copyWith(
              color: AppTokens.colorLightGrey,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final void Function(String url) onLaunch;

  const _FooterSection({required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.spacingLg,
        vertical: AppTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTokens.colorWhite.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: AppTokens.spacingXs,
        spacing: AppTokens.spacingSm,
        children: [
          Text(
            'MICROBOT',
            style: AppTokens.labelLarge.copyWith(
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Future-ready robotics, built for practical innovation.',
                style: AppTokens.bodySmall.copyWith(
                  color: AppTokens.colorLightGrey.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              InkWell(
                onTap: () {
                  AnalyticsService.track('contact_email_click');
                  onLaunch('mailto:email@email.com');
                },
                child: Text(
                  'Contact us now at email@email.com',
                  style: AppTokens.bodySmall.copyWith(
                    color: AppTokens.colorOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTokens.colorOrange,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'GitHub',
                onPressed: () => onLaunch('https://github.com/horysheeet'),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: const EdgeInsets.all(4),
                iconSize: 18,
                icon: const Icon(Icons.code),
              ),
              IconButton(
                tooltip: 'Shopee',
                onPressed: () => onLaunch('https://shopee.ph/'),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: const EdgeInsets.all(4),
                iconSize: 18,
                icon: const Icon(Icons.shopping_bag),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppTokens.colorWhite.withValues(alpha: 0.12),
    );
  }
}
