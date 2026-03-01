import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFooter extends StatelessWidget {
  final void Function(String url) onLaunch;

  const AppFooter({super.key, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFED5833),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('© 2025 Company Name. All rights reserved.',
                  style: GoogleFonts.openSans(color: Colors.white)),
              const SizedBox(width: 16),
              IconButton(
                tooltip: 'GitHub',
                onPressed: () => onLaunch('https://github.com/yourorg'),
                icon: const Icon(Icons.code, color: Colors.white),
              ),
              IconButton(
                tooltip: 'LinkedIn',
                onPressed: () => onLaunch('https://linkedin.com/company/yourorg'),
                icon: const Icon(Icons.work, color: Colors.white),
              ),
              IconButton(
                tooltip: 'Email',
                onPressed: () => onLaunch('mailto:info@company.com'),
                icon: const Icon(Icons.email, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
