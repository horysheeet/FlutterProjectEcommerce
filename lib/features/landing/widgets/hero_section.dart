import 'package:flutter/material.dart';

import '../../../shared/theme/design_tokens.dart';

class HeroSection extends StatefulWidget {
  final double sectionHeight;
  final VoidCallback onBrowseStore;

  const HeroSection({
    super.key,
    required this.sectionHeight,
    required this.onBrowseStore,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _brandOpacity;
  late final Animation<Offset> _brandOffset;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _bodyOpacity;
  late final Animation<Offset> _bodyOffset;
  late final Animation<double> _ctaOpacity;
  late final Animation<Offset> _ctaOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _brandOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _brandOffset = Tween<Offset>(
      begin: const Offset(0, 0.16),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    );
    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _bodyOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );
    _bodyOffset = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _ctaOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _ctaOffset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.sectionHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _brandOpacity,
            child: SlideTransition(
              position: _brandOffset,
              child: Text(
                'MICROBOT',
                style: AppTokens.labelSmall.copyWith(
                  color: AppTokens.colorOrange,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.spacingSm),
          FadeTransition(
            opacity: _titleOpacity,
            child: SlideTransition(
              position: _titleOffset,
              child: Text(
                'Future Robotics.\nBuilt for Real-World Use.',
                style: width >= AppTokens.breakpointTablet
                    ? AppTokens.headingLarge
                    : AppTokens.headingMedium.copyWith(
                        color: AppTokens.colorWhite,
                        fontSize: 38,
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.spacingMd),
          FadeTransition(
            opacity: _bodyOpacity,
            child: SlideTransition(
              position: _bodyOffset,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'Explore practical robotic components and systems through a streamlined, secure buying experience.',
                  style: AppTokens.bodyLarge.copyWith(
                    color: AppTokens.colorLightGrey.withValues(alpha: 0.9),
                    height: 1.7,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.spacingXl),
          FadeTransition(
            opacity: _ctaOpacity,
            child: SlideTransition(
              position: _ctaOffset,
              child: ElevatedButton(
                onPressed: widget.onBrowseStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.colorOrange,
                  foregroundColor: AppTokens.colorWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.spacing2xl,
                    vertical: AppTokens.spacingMd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTokens.radiusXl),
                  ),
                ),
                child: const Text('Browse Store'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
