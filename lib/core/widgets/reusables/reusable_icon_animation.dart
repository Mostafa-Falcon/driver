import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum IconAnimationType {
  rotate, // Rotating overlay icon infinitely
  pulse, // Scaling overlay icon up and down (sonar/pulse effect)
  bounce, // Bouncing overlay icon vertically
  scan, // Moving overlay in a circular/oval scanning sweep
  slide, // Sliding overlay horizontally back and forth
}

class ReusableIconAnimation extends StatefulWidget {
  const ReusableIconAnimation({
    super.key,
    required this.baseIcon,
    required this.overlayIcon,
    this.type = IconAnimationType.scan,
    this.baseSize,
    this.overlaySize,
    this.baseColor,
    this.overlayColor,
    this.duration = const Duration(milliseconds: 1800),
    this.overlayOffset = Offset.zero,
  });

  final IconData baseIcon;
  final IconData overlayIcon;
  final IconAnimationType type;
  final double? baseSize;
  final double? overlaySize;
  final Color? baseColor;
  final Color? overlayColor;
  final Duration duration;
  final Offset overlayOffset;

  @override
  State<ReusableIconAnimation> createState() => _ReusableIconAnimationState();
}

class _ReusableIconAnimationState extends State<ReusableIconAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant ReusableIconAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double defaultBaseSize = widget.baseSize ?? 40.r;
    final double defaultOverlaySize =
        widget.overlaySize ?? (defaultBaseSize * 0.55);
    final Color defaultBaseColor = widget.baseColor ?? Colors.grey[400]!;
    final Color defaultOverlayColor =
        widget.overlayColor ?? Theme.of(context).primaryColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Base Static Icon
        Icon(
          widget.baseIcon,
          size: defaultBaseSize,
          color: defaultBaseColor,
        ),

        // Animated Overlay Icon
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            Widget animatedChild = Icon(
              widget.overlayIcon,
              size: defaultOverlaySize,
              color: defaultOverlayColor,
            );

            // Apply specific transformation based on AnimationType
            switch (widget.type) {
              case IconAnimationType.rotate:
                animatedChild = Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: animatedChild,
                );
                break;

              case IconAnimationType.pulse:
                final double scale =
                    0.8 + (0.4 * math.sin(_controller.value * math.pi));
                animatedChild = Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity:
                        (0.5 + (0.5 * math.sin(_controller.value * math.pi)))
                            .clamp(0.0, 1.0),
                    child: animatedChild,
                  ),
                );
                break;

              case IconAnimationType.bounce:
                final double dy = -6.h * math.sin(_controller.value * math.pi);
                animatedChild = Transform.translate(
                  offset: Offset(0, dy),
                  child: animatedChild,
                );
                break;

              case IconAnimationType.scan:
                // Scan in an oval circular path
                final double angle = _controller.value * 2 * math.pi;
                final double dx = 8.w * math.cos(angle);
                final double dy = 4.h * math.sin(angle);
                animatedChild = Transform.translate(
                  offset: Offset(dx, dy),
                  child: animatedChild,
                );
                break;

              case IconAnimationType.slide:
                // Slide horizontally back and forth
                final double dx =
                    8.w * math.sin(_controller.value * 2 * math.pi);
                animatedChild = Transform.translate(
                  offset: Offset(dx, 0),
                  child: animatedChild,
                );
                break;
            }

            return Transform.translate(
              offset: widget.overlayOffset,
              child: animatedChild,
            );
          },
        ),
      ],
    );
  }
}
