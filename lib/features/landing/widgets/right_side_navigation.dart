import 'package:flutter/material.dart';

import '../../../shared/theme/design_tokens.dart';
import '../single_page_site.dart';

class RightSideNavigation extends StatelessWidget {
  final SiteSection activeSection;
  final ValueChanged<SiteSection> onSelect;

  const RightSideNavigation({
    super.key,
    required this.activeSection,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTokens.spacingMd,
          horizontal: AppTokens.spacingXs,
        ),
        decoration: BoxDecoration(
          color: AppTokens.colorBlack.withValues(alpha: 0.55),
          border: Border.all(
            color: AppTokens.colorWhite.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(AppTokens.radiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavItem(
              label: 'Home',
              isActive: activeSection == SiteSection.home,
              onTap: () => onSelect(SiteSection.home),
            ),
            const SizedBox(height: AppTokens.spacingSm),
            _NavItem(
              label: 'Store',
              isActive: activeSection == SiteSection.store,
              onTap: () => onSelect(SiteSection.store),
            ),
          ],
        ),
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
    return Tooltip(
      message: label,
      child: Semantics(
        label: '$label section',
        button: true,
        selected: isActive,
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: AppTokens.spacingMd,
                vertical: AppTokens.spacingSm,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.radiusXl),
              ),
            ),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return BorderSide(
                  color: AppTokens.colorOrange.withValues(alpha: 0.8),
                  width: 1.2,
                );
              }
              return BorderSide(
                color: Colors.transparent,
                width: 1.2,
              );
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (isActive) {
                return AppTokens.colorOrange.withValues(alpha: 0.18);
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return AppTokens.colorWhite.withValues(alpha: 0.06);
              }
              return Colors.transparent;
            }),
          ),
          child: Text(
            label,
            style: AppTokens.labelSmall.copyWith(
              color: isActive ? AppTokens.colorOrange : AppTokens.colorLightGrey,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
