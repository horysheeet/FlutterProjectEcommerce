import 'package:flutter/material.dart';
import 'about_page.dart';
import 'features/home/home_page.dart';
import 'features/products/store_page.dart';
import 'shared/theme/design_tokens.dart';
import 'shared/widgets/app_header.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTokens.appTheme,
      home: const MainAppWrapper(),
    ),
  );
}

class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  int _currentPageIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onBrowseCatalog: () => _navigateToPage(1)),
      const StorePage(),
      const AboutPage(),
    ];
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        currentPageIndex: _currentPageIndex,
        onNavigate: _navigateToPage,
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pages,
      ),
    );
  }
}
