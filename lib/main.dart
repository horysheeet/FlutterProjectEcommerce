import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'about_page.dart';

Future<void> _launchEmail(String email, {String subject = ''}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: subject.isNotEmpty ? {'subject': subject} : null,
  );
  if (!await launchUrl(uri)) {
    // ignore: use_build_context_synchronously
    // couldn't launch mail app - show snackbar via context when available
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFED5833),
            secondary: Color(0xFFE3EEF1),
          ),
          scaffoldBackgroundColor: const Color(0xFF0D0D0D),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFED5833),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED5833)),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ),
        home: const HomePage(),
      ),
    ),
  );
}

// Support Chat page — user messages appear on the right (black bubble),
// support messages appear on the left (orange bubble). The input area is
// orange and the send control is an orange circular send icon.
class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Each message is usually a map {'text': String, 'isUser': bool} but
  // on web or after a hot-reload the stored state may appear as a
  // List<String>. Use a dynamic list and defensively handle both shapes.
  final List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    // welcome message from support
    _messages.add({'text': 'Hi — how can we help you today?', 'isUser': false});
    // slight delay to let the list render before scrolling to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _ctrl.clear();
    });
    _scrollToBottom();

    // fake support reply for demo
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text':
              'Thanks for your message — a support agent will reply shortly.',
          'isUser': false
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    // delay slightly to allow ListView to update sizes
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Support',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [cartNavButton(context)],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text('No messages yet — send us a question',
                        style: GoogleFonts.openSans(color: Colors.white70)),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final item = _messages[i];

                      // normalize item to text + isUser
                      String text;
                      bool isUser;
                      if (item is Map) {
                        text = (item['text'] ?? '').toString();
                        isUser = item['isUser'] == true;
                      } else {
                        // fallback: treat plain strings as user messages
                        text = item?.toString() ?? '';
                        isUser = true;
                      }

                      final bubbleColor = isUser ? Colors.black : primary;
                      final textColor = Colors.white;

                      // align right for user, left for support
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.72),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: bubbleColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(isUser ? 12 : 4),
                                    topRight: Radius.circular(isUser ? 4 : 12),
                                    bottomLeft: const Radius.circular(12),
                                    bottomRight: const Radius.circular(12),
                                  ),
                                ),
                                child: Text(text,
                                    style: GoogleFonts.openSans(
                                        color: textColor, fontSize: 15)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Input area — orange background text field and circular send icon
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _ctrl,
                        style: GoogleFonts.openSans(color: Colors.white),
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle:
                              GoogleFonts.openSans(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // larger tappable send 'blobb' — uses InkWell to ensure
                  // taps are registered across platforms (web included)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        if (_ctrl.text.trim().isEmpty) return;
                        _sendMessage();
                      },
                      child: const Center(
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// StoreMenuButton with hover dropdown animation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: ShinyText(
          text: 'COMPANY NAME',
          speed: 3,
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFE3EEF1),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child:
                Text('Home', style: GoogleFonts.poppins(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const StorePage()));
            },
            child:
                Text('Store', style: GoogleFonts.poppins(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SupportChatPage()));
            },
            child: Text('Support',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              _launchEmail('support@company.com', subject: 'Support request');
            },
            child: Text('Contact',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutPage()));
            },
            child:
                Text('About', style: GoogleFonts.poppins(color: Colors.white)),
          ),
          cartNavButton(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO - fill viewport so products are below the fold
            LayoutBuilder(builder: (context, constraints) {
              final height =
                  MediaQuery.of(context).size.height - kToolbarHeight;
              return Container(
                width: double.infinity,
                height: height,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                color: const Color(0xFFED5833),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSplitText(
                      text: 'Discover the Future of Robotics',
                      style: GoogleFonts.poppins(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    TextType(
                      text: [
                        'AI-powered machines designed to revolutionize everyday life.'
                      ],
                      typingSpeed: 40,
                      pauseDuration: 1800,
                      textStyle: GoogleFonts.openSans(
                          fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const StorePage()));
                      },
                      child: Text('Explore Our Products',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFFED5833),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Featured Products',
                  style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFED5833))),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 260, child: const FutureProductCarousel()),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StorePage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED5833)),
                child: Text('View All Products',
                    style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
            // CTA
            Container(
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                children: [
                  Text('Join the Future of Robotics',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                      'Collaborate, invest, or explore our latest breakthroughs in AI automation.',
                      style: GoogleFonts.openSans(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FutureProductCarousel extends StatefulWidget {
  const FutureProductCarousel({super.key});

  @override
  State<FutureProductCarousel> createState() => _FutureProductCarouselState();
}

class _FutureProductCarouselState extends State<FutureProductCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _index = 0;

  final List<Map<String, String>> featuredProducts = [
    {
      'name': 'RoboArm X1',
      'desc': 'Precision robotic arm with adaptive AI control.',
      'price': '₱24,999'
    },
    {
      'name': 'DroneEye 360',
      'desc': 'Autonomous drone with panoramic navigation sensors.',
      'price': '₱49,999'
    },
    {
      'name': 'AutoBot Z',
      'desc': 'Self-learning mobile assistant robot for industrial use.',
      'price': '₱149,999'
    },
  ];

  @override
  void initState() {
    super.initState();
    // simple auto-scroll
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    _index = (_index + 1) % featuredProducts.length;
    _controller.animateToPage(_index,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: featuredProducts.length,
      itemBuilder: (context, i) {
        final p = featuredProducts[i];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final next = (i + 1) % featuredProducts.length;
            _controller.animateToPage(next,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFED5833),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFED5833)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.smart_toy, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(p['name']!,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(p['desc']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(p['price']!,
                      style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// StoreMenuButton with hover dropdown animation
class StoreMenuButton extends StatefulWidget {
  const StoreMenuButton({super.key});

  @override
  State<StoreMenuButton> createState() => _StoreMenuButtonState();
}

class _StoreMenuButtonState extends State<StoreMenuButton> {
  OverlayEntry? _dropdownOverlay;
  final LayerLink _layerLink = LayerLink();

  final List<String> componentTypes = [
    'Insert type of component here 1',
    'Insert type of component here 2',
    'Insert type of component here 3',
    'Insert type of component here 4',
    'Insert type of component here 5',
  ];

  void _showDropdown() {
    if (_dropdownOverlay != null) return;
    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 180,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 40),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFED5833),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(componentTypes.length, (index) {
                    return ListTile(
                      title: Text(
                        componentTypes[index],
                        style: const TextStyle(color: Color(0xFFE3EEF1)),
                      ),
                      onTap: () {
                        // Add navigation or action here
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _showDropdown(),
        onExit: (_) => _hideDropdown(),
        child: TextButton(
          onPressed: () {},
          child: const Text('Store', style: TextStyle(color: Colors.white)),
        ),
      ),
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

// Cart Model
// Typing animation used in StorePage and elsewhere
class TextType extends StatefulWidget {
  final List<String> text;
  final int typingSpeed; // ms per character
  final int pauseDuration; // ms between texts
  final bool showCursor;
  final String cursorCharacter;
  final TextStyle? textStyle;

  const TextType({
    super.key,
    required this.text,
    this.typingSpeed = 75,
    this.pauseDuration = 1500,
    this.showCursor = true,
    this.cursorCharacter = '|',
    this.textStyle,
  });

  @override
  State<TextType> createState() => _TextTypeState();
}

class _TextTypeState extends State<TextType> {
  int _textIndex = 0;
  int _charIndex = 0;
  String _displayed = '';
  bool _typing = true;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  Future<void> _startTyping() async {
    if (widget.text.isEmpty) return;
    while (mounted) {
      final current = widget.text[_textIndex % widget.text.length];
      while (_charIndex < current.length) {
        await Future.delayed(Duration(milliseconds: widget.typingSpeed));
        if (!mounted) return;
        setState(() {
          _charIndex++;
          _displayed = current.substring(0, _charIndex);
        });
      }
      // finished one word
      await Future.delayed(Duration(milliseconds: widget.pauseDuration));
      if (!mounted) return;
      setState(() {
        _textIndex = (_textIndex + 1) % widget.text.length;
        _charIndex = 0;
        _displayed = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.showCursor
          ? '$_displayed${_typing ? widget.cursorCharacter : ''}'
          : _displayed,
      style: widget.textStyle ??
          GoogleFonts.poppins(
              fontSize: 18,
              color: const Color(0xFFED5833),
              fontWeight: FontWeight.w600),
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<int> _cartItems = [];
  List<int> get cartItems => _cartItems;

  void addToCart(int index) {
    _cartItems.add(index);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.remove(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

// Cart Page Widget
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Offset _buttonOffset = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const StorePage()),
                (route) => false,
              );
            },
            child: const Text('Store', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const SupportChatPage()),
              );
            },
            child: const Text('Support', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
            child: const Text('About', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Listener(
        onPointerHover: (event) {
          setState(() {
            _buttonOffset = event.localPosition;
          });
        },
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: cart.cartItems.length,
              itemBuilder: (context, i) {
                final idx = cart.cartItems[i];
                return Card(
                  child: ListTile(
                    title: Text('Product ${idx + 1}'),
                    subtitle: const Text(
                        'Short description of the product goes here.'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () => cart.removeFromCart(idx),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              left: _buttonOffset.dx,
              top: _buttonOffset.dy,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFED5833),
                  foregroundColor: Colors.white,
                ),
                onPressed: cart.cartItems.isEmpty
                    ? null
                    : () {
                        cart.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchase successful!')),
                        );
                      },
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Update navigation bars in HomePage, StorePage, SupportChatPage to include Cart icon:
Widget cartNavButton(BuildContext context) {
  final cart = Provider.of<CartModel>(context);
  return Stack(
    children: [
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
      ),
      if (cart.cartItems.isNotEmpty)
        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${cart.cartItems.length}',
              style: const TextStyle(color: Color(0xFFE3EEF1), fontSize: 12),
            ),
          ),
        ),
    ],
  );
}

// Example for StorePage (repeat for other pages):
class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShinyText(
          text: 'STORE - COMPANY NAME',
          speed: 3,
          style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE3EEF1)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
            child: Text('Home',
                style: GoogleFonts.poppins(color: const Color(0xFFE3EEF1))),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Store',
                style: GoogleFonts.poppins(color: const Color(0xFFE3EEF1))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const SupportChatPage()),
              );
            },
            child: Text('Support',
                style: GoogleFonts.poppins(color: const Color(0xFFE3EEF1))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
            child: Text('About',
                style: GoogleFonts.poppins(color: const Color(0xFFE3EEF1))),
          ),
          cartNavButton(context),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          TextType(
            text: [
              "What are you interested in?",
              "have a look around",
              "Happy Shopping",
              "Sales are open soon!"
            ],
            typingSpeed: 75,
            pauseDuration: 1500,
            showCursor: true,
            cursorCharacter: "|",
            textStyle: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFED5833),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                return AnimatedProductCard(
                    index: index, delay: Duration(milliseconds: 100 * index));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Add this widget below _ProductCard:
class AnimatedProductCard extends StatefulWidget {
  final int index;
  final Duration delay;
  const AnimatedProductCard(
      {super.key, required this.index, required this.delay});

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _offset =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: PixelTransitionCard(index: widget.index),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final int index;
  const _ProductCard({required this.index});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EEF1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: const Color(0xFFED5833).withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF232828).withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: _hovering
              ? Border.all(color: const Color(0xFFED5833), width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        margin: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy, size: 48, color: Color(0xFFED5833)),
            const SizedBox(height: 12),
            Text(
              'Product ${widget.index + 1}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF232828),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Short description of the product goes here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(color: const Color(0xFF232828)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse('https://shopee.ph/product/1234567890');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not launch Shopee link'),
                    ),
                  );
                }
              },
              child: Text('Shop Now', style: GoogleFonts.openSans()),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this widget above your pages:
class ShinyText extends StatefulWidget {
  final String text;
  final double speed;
  final TextStyle? style;
  final bool disabled;

  const ShinyText({
    super.key,
    required this.text,
    this.speed = 3,
    this.style,
    this.disabled = false,
  });

  @override
  State<ShinyText> createState() => _ShinyTextState();
}

class _ShinyTextState extends State<ShinyText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.speed.toInt()),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return Text(widget.text, style: widget.style);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFFE3EEF1),
                Color(0xFFED5833),
                Color(0xFFE3EEF1)
              ],
              stops: [
                (_controller.value - 0.2).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.2).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style ??
                const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        );
      },
    );
  }
}

class PixelTransitionCard extends StatefulWidget {
  final int index;
  const PixelTransitionCard({super.key, required this.index});

  @override
  State<PixelTransitionCard> createState() => _PixelTransitionCardState();
}

class _PixelTransitionCardState extends State<PixelTransitionCard>
    with SingleTickerProviderStateMixin {
  static const int gridSize = 7;
  bool _hovering = false;
  bool _showText = false;
  List<bool> _pixelVisible = List.generate(gridSize * gridSize, (_) => false);
  late final AnimationController _bounceController;
  late final Animation<double> _scale;
  final Random _random = Random();

  void _startPixelAnimation() async {
    setState(() {
      _pixelVisible = List.generate(gridSize * gridSize, (_) => false);
      _showText = false;
    });
    final indices = List.generate(gridSize * gridSize, (i) => i)..shuffle();
    for (final i in indices) {
      await Future.delayed(const Duration(milliseconds: 8));
      setState(() {
        _pixelVisible[i] = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _showText = true;
    });
  }

  void _resetPixelAnimation() {
    setState(() {
      _pixelVisible = List.generate(gridSize * gridSize, (_) => false);
      _showText = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeOut));
    _startBounceLoop();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _startBounceLoop() async {
    while (mounted) {
      final seconds = 2 + _random.nextInt(7); // 2..8s
      await Future.delayed(Duration(seconds: seconds));
      if (!mounted) break;
      try {
        await _bounceController.forward();
        await _bounceController.reverse();
      } catch (_) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovering = true);
        _startPixelAnimation();
      },
      onExit: (_) {
        setState(() => _hovering = false);
        _resetPixelAnimation();
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _hovering
                ? [Color(0xFFED5833), Colors.teal]
                : [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: Color(0xFFED5833).withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Color(0xFF232828).withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: _hovering
              ? Border.all(color: Color(0xFFED5833), width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        margin: const EdgeInsets.all(4),
        child: Stack(
          children: [
            // Card content
            AnimatedOpacity(
              opacity: _hovering ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.smart_toy, size: 48, color: Color(0xFFED5833)),
                    const SizedBox(height: 12),
                    Text('Product ${widget.index + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF232828))),
                    const SizedBox(height: 8),
                    const Text('Short description of the product goes here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF232828))),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final url =
                            Uri.parse('https://shopee.ph/product/1234567890');
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Could not launch Shopee link')),
                          );
                        }
                      },
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              ),
            ),
            // Pixel grid overlay (covers entire card)
            if (_hovering)
              Positioned.fill(
                child: Stack(
                  children: [
                    Column(
                      children: List.generate(gridSize, (row) {
                        return Expanded(
                          child: Row(
                            children: List.generate(gridSize, (col) {
                              int i = row * gridSize + col;
                              return Expanded(
                                child: AnimatedOpacity(
                                  opacity: _pixelVisible[i] ? 1 : 0,
                                  duration: const Duration(milliseconds: 80),
                                  child: Container(
                                    margin: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFED5833),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    ),
                    // Smooth fade-in for "Lorem Ipsum" after pixels
                    if (_showText)
                      AnimatedOpacity(
                        opacity: _showText ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFFED5833).withOpacity(0.85),
                            child: Text(
                              "Lorem Ipsum",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE3EEF1),
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 8,
                                    color: Color(0xFF232828).withOpacity(0.26),
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            // Bouncing Buy Now pill
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
              child: ScaleTransition(
                scale: _scale,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      final cart =
                          Provider.of<CartModel>(context, listen: false);
                      cart.addToCart(widget.index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFED5833),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF232828).withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text('Buy Now',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
