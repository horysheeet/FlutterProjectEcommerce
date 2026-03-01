import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_tokens.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final int currentPageIndex;
  final ValueChanged<int> onNavigate;

  const AppHeader({
    super.key,
    required this.currentPageIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppBar(
      backgroundColor: AppTokens.colorDarkGrey,
      title: InkWell(
        onTap: currentPageIndex == 0 ? null : () => onNavigate(0),
        child: Text(
          'MICROBOT',
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 16 : 22,
            fontWeight: FontWeight.w800,
            color: AppTokens.colorLightGrey,
          ),
        ),
      ),
      actions: isMobile
          ? [
              PopupMenuButton<int>(
                icon: Icon(Icons.menu, color: AppTokens.colorWhite),
                onSelected: (index) => onNavigate(index),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text('Home',
                        style: TextStyle(
                      color: currentPageIndex == 0
                          ? AppTokens.colorOrange
                          : AppTokens.colorBlack,
                      fontWeight: currentPageIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Store',
                        style: TextStyle(
                      color: currentPageIndex == 1
                          ? AppTokens.colorOrange
                          : AppTokens.colorBlack,
                      fontWeight: currentPageIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('About',
                        style: TextStyle(
                      color: currentPageIndex == 2
                          ? AppTokens.colorOrange
                          : AppTokens.colorBlack,
                      fontWeight: currentPageIndex == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
                  ),
                ],
              ),
            ]
          : [
              TextButton(
                onPressed: currentPageIndex == 0 ? null : () => onNavigate(0),
                child: Text('Home',
                    style: AppTokens.labelLarge.copyWith(
                  color: currentPageIndex == 0
                      ? AppTokens.colorOrange
                      : AppTokens.colorWhite,
                )),
              ),
              TextButton(
                onPressed: currentPageIndex == 1 ? null : () => onNavigate(1),
                child: Text('Store',
                    style: AppTokens.labelLarge.copyWith(
                  color: currentPageIndex == 1
                      ? AppTokens.colorOrange
                      : AppTokens.colorWhite,
                )),
              ),
              TextButton(
                onPressed: currentPageIndex == 2 ? null : () => onNavigate(2),
                child: Text('About',
                    style: AppTokens.labelLarge.copyWith(
                  color: currentPageIndex == 2
                      ? AppTokens.colorOrange
                      : AppTokens.colorWhite,
                )),
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
