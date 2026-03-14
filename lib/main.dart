import 'package:flutter/material.dart';
import 'features/landing/single_page_site.dart';
import 'shared/theme/design_tokens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTokens.appTheme,
      home: const SinglePageSite(),
    ),
  );
}
