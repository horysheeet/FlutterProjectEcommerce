import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: AppTokens.transitionSlow)
          ..repeat();
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
              colors: [
                AppTokens.colorLightGrey,
                AppTokens.colorOrange,
                AppTokens.colorLightGrey
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
