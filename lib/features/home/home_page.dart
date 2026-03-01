import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/theme/design_tokens.dart';
import '../../shared/widgets/app_footer.dart';
import '../../shared/widgets/typing_text.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onBrowseCatalog;

  const HomePage({super.key, required this.onBrowseCatalog});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final height = MediaQuery.of(context).size.height - kToolbarHeight;
        final isMobile = MediaQuery.of(context).size.width < 600;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                      style:
                          isMobile ? AppTokens.headingMedium : AppTokens.headingLarge,
                    ),
                    SizedBox(height: AppTokens.spacingSm),
                    TextType(
                      text: [
                        'Browse our catalog. All purchases securely completed on Shopee.'
                      ],
                      typingSpeed: 40,
                      pauseDuration: 1800,
                      textStyle: AppTokens.bodyLarge,
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
                        widget.onBrowseCatalog();
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
              AppFooter(onLaunch: _launchUrl),
            ],
          ),
        );
      }),
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
