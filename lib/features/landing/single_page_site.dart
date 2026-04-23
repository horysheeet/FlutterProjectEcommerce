import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/services/analytics_service.dart';
import '../../shared/theme/design_tokens.dart';
import 'widgets/featured_product_carousel.dart';
import 'widgets/hero_section.dart';
import 'widgets/store_section.dart';

enum SiteSection { home, store, about }

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
    SiteSection.about: GlobalKey(),
  };

  SiteSection _activeSection = SiteSection.home;
  bool _isCalculatingSection = false;

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

    final maxScroll = _scrollController.position.maxScrollExtent;
    final atBottomThreshold = maxScroll - 30;
    if (currentOffset >= atBottomThreshold) {
      nextActive = SiteSection.about;
    }

    if (nextActive != _activeSection) {
      AnalyticsService.track(
        'section_view',
        params: {'section': nextActive.name},
      );
      setState(() => _activeSection = nextActive);
    }

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
    // Special case for About - scroll to bottom
    if (section == SiteSection.about) {
      AnalyticsService.track(
        'navigate_section',
        params: {'section': section.name},
      );

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

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
                      child: _FooterSection(
                        key: _sectionKeys[SiteSection.about],
                        onLaunch: _launchUrl,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: _TopHeader(
                    activeSection: _activeSection,
                    onSelectSection: _scrollToSection,
                    onMicrobotTap: () => _scrollToSection(SiteSection.home),
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
  final SiteSection activeSection;
  final ValueChanged<SiteSection> onSelectSection;
  final VoidCallback onMicrobotTap;

  const _TopHeader({
    required this.activeSection,
    required this.onSelectSection,
    required this.onMicrobotTap,
  });

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onMicrobotTap,
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Logo/logo.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.memory,
                    color: AppTokens.colorOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTokens.spacingXs),
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
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavItem(
                label: 'Home',
                isActive: activeSection == SiteSection.home,
                onTap: () => onSelectSection(SiteSection.home),
              ),
              const SizedBox(width: AppTokens.spacingMd),
              _NavItem(
                label: 'Store',
                isActive: activeSection == SiteSection.store,
                onTap: () => onSelectSection(SiteSection.store),
              ),
              const SizedBox(width: AppTokens.spacingMd),
              _NavItem(
                label: 'About',
                isActive: activeSection == SiteSection.about,
                onTap: () => onSelectSection(SiteSection.about),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spacingMd,
            vertical: AppTokens.spacingXs,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppTokens.colorOrange.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTokens.radiusXl),
            border: Border.all(
              color: isActive
                  ? AppTokens.colorOrange.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: AppTokens.bodySmall.copyWith(
              color: isActive
                  ? AppTokens.colorOrange
                  : AppTokens.colorLightGrey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterSection extends StatefulWidget {
  final void Function(String url) onLaunch;

  const _FooterSection({super.key, required this.onLaunch});

  @override
  State<_FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<_FooterSection> {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Logo/logo.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.memory,
                  color: AppTokens.colorOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTokens.spacingXs),
              Text(
                'MICROBOT',
                style: AppTokens.labelLarge.copyWith(
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacingMd),
              child: Column(
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
                      widget.onLaunch('mailto:microps.ph@gmail.com');
                    },
                    child: Text(
                      'Contact us now at microps.ph@gmail.com',
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
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'GitHub',
                onPressed: () => widget.onLaunch('https://github.com/horysheeet'),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: const EdgeInsets.all(4),
                iconSize: 18,
                icon: const Icon(Icons.code),
              ),
              IconButton(
                tooltip: 'Shopee',
                onPressed: () => widget.onLaunch('https://shopee.ph/'),
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
