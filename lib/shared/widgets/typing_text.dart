import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextType extends StatefulWidget {
  final List<String> text;
  final int typingSpeed;
  final int pauseDuration;
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
