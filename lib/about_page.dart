import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design_tokens.dart';
import 'main.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, String>> testimonials = [
    {
      "quote":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ultricies felis et elit fermentum tincidunt.",
      "author": "Ryan Mendoza, Research Engineer"
    },
    {
      "quote":
          "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "author": "Ryan Mendoza, Product Designer"
    },
    {
      "quote":
          "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
      "author": "Ryan Mendoza, Robotics Investor"
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % testimonials.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    _startAutoScroll();
  }

  void _goToNext() {
    if (testimonials.isEmpty) return;
    if (!_pageController.hasClients) return;
    setState(() {
      _currentPage = (_currentPage + 1) % testimonials.length;
    });
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.colorBlack,
      appBar: buildAppBar(context, title: 'About Us'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hero Section ---
            Center(
              child: Column(
                children: [
                  Text(
                    "About Company Name",
                    style: AppTokens.headingLarge.copyWith(
                      fontSize: 42,
                      color: AppTokens.colorOrange,
                    ),
                  ),
                  SizedBox(height: AppTokens.spacingSm),
                  Text(
                    "Discover the minds shaping the future of robotics.",
                    style: AppTokens.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTokens.spacing2xl),

            // --- Mission / Vision / Tech / Testimonials / Contact ---
            _sectionTitle("Our Mission"),
            _sectionText(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            ),
            SizedBox(height: AppTokens.spacingLg),

            _sectionTitle("Our Vision"),
            _sectionText(
              "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
            ),
            const SizedBox(height: 24),

            // --- Team Section ---
            _sectionTitle("Our Team"),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _teamMember('Ryan Mendoza', 'Lead Engineer'),
                    const SizedBox(height: 12),
                    _teamMember('Ryan Mendoza', 'AI Developer'),
                    const SizedBox(height: 12),
                    _teamMember('Ryan Mendoza', 'Product Designer'),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _teamMember('Ryan Mendoza', 'Lead Engineer'),
                  _teamMember('Ryan Mendoza', 'AI Developer'),
                  _teamMember('Ryan Mendoza', 'Product Designer'),
                ],
              );
            }),
            const SizedBox(height: 24),

            _sectionTitle("Technologies We Use"),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _techChip("Flutter"),
                _techChip("TensorFlow"),
                _techChip("Raspberry Pi"),
                _techChip("Arduino"),
                _techChip("Python"),
              ],
            ),
            const SizedBox(height: 32),

            _sectionTitle("What Our Clients Say"),
            const SizedBox(height: 12),
            MouseRegion(
              onEnter: (_) => _pauseAutoScroll(),
              onExit: (_) => _resumeAutoScroll(),
              child: SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: testimonials.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    final t = testimonials[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _goToNext,
                      child: _testimonialCard(t['quote']!, t['author']!),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  testimonials.length,
                  (i) => Container(
                    margin: const EdgeInsets.all(4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? const Color(0xFFED5833)
                          : Colors.white24,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            _sectionTitle("Contact Us"),
            const SizedBox(height: 12),
            Text(
              "Got questions or want to collaborate? Send us a message below:",
              style: GoogleFonts.openSans(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _contactForm(),

            const SizedBox(height: 40),
            // Footer — orange background to match theme
            Container(
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
                      // Social icons
                      IconButton(
                        tooltip: 'GitHub',
                        onPressed: () =>
                            _launchUrl('https://github.com/yourorg'),
                        icon: const Icon(Icons.code, color: Colors.white),
                      ),
                      IconButton(
                        tooltip: 'LinkedIn',
                        onPressed: () =>
                            _launchUrl('https://linkedin.com/company/yourorg'),
                        icon: const Icon(Icons.work, color: Colors.white),
                      ),
                      IconButton(
                        tooltip: 'Email',
                        onPressed: () => _launchUrl('mailto:info@company.com'),
                        icon: const Icon(Icons.email, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Section Widgets ---

  static Widget _sectionTitle(String text) {
    return Text(text,
        style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFED5833)));
  }

  static Widget _sectionText(String text) {
    return Text(text,
        style: GoogleFonts.openSans(
            fontSize: 16, color: Colors.white70, height: 1.6));
  }

  static Widget _techChip(String label) {
    return Chip(
        backgroundColor: const Color(0xFF232828),
        label: Text(label,
            style: GoogleFonts.openSans(color: const Color(0xFFE3EEF1))));
  }

  static Widget _testimonialCard(String quote, String author) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFED5833), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('"$quote"',
                style: GoogleFonts.openSans(color: Colors.white70),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('- $author',
                style: GoogleFonts.poppins(
                    color: const Color(0xFFED5833),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  static Widget _contactForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFED5833), width: 1)),
      child: Column(
        children: [
          TextField(
            style: GoogleFonts.openSans(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFED5833)))),
          ),
          const SizedBox(height: 12),
          TextField(
            style: GoogleFonts.openSans(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFED5833)))),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            style: GoogleFonts.openSans(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Your Message',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFED5833)))),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED5833),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {},
              child: Text('Send Message',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _teamMember(String name, String role) {
    return Column(
      children: [
        const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFED5833),
            child: Icon(Icons.person, color: Colors.white)),
        const SizedBox(height: 8),
        Text(name,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        Text(role,
            style: GoogleFonts.openSans(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }
}
