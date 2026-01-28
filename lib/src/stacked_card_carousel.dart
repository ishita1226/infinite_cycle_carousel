import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularCarousel extends StatefulWidget {
  final List<Widget> cards;
  final double radius;

  const CircularCarousel({super.key, required this.cards, this.radius = 100});

  @override
  State<CircularCarousel> createState() => _CircularCarouselState();
}

class _CircularCarouselState extends State<CircularCarousel>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  double dragDelta = 0.0;
  late AnimationController _controller;
  double animationStart = 0.0;
  double animationEnd = 0.0;
  bool isDragging = false;
  double get cardWidth => 280.0;
  double get cardHeight => 180.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _controller.addListener(() {
      setState(() {
        dragDelta = lerpDouble(
          animationStart,
          animationEnd,
          _controller.value,
        )!;
      });
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          dragDelta = 0.0;
          isDragging = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _controller.stop();
    isDragging = true;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragDelta += details.primaryDelta! / cardWidth;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    double threshold = 0.2;
    int move = 0;
    double target = 0.0;
    if (dragDelta.abs() > threshold) {
      move = dragDelta > 0 ? -1 : 1;
      target = dragDelta > 0 ? 1.0 : -1.0;
    }
    int newIndex = (currentIndex + move) % widget.cards.length;
    if (newIndex < 0) newIndex += widget.cards.length;
    animationStart = dragDelta;
    animationEnd = target;
    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        currentIndex = newIndex;
        dragDelta = 0.0;
      });
    });
  }

  int _getCardIndex(int offset) {
    if (widget.cards.isEmpty) return 0;
    int idx = (currentIndex + offset) % widget.cards.length;
    if (idx < 0) idx += widget.cards.length;
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final stackWidth = screenWidth;
    // Calculate center offset: screen center minus half of card width
    // Add small adjustment to shift right for perfect centering
    final centerOffset = (screenWidth - cardWidth) / 2 ;

    final double angle = dragDelta * (math.pi / 2);
    final List<_CardConfig> configs = [
      _CardConfig(offset: -2),
      _CardConfig(offset: -1),
      _CardConfig(offset: 0),
      _CardConfig(offset: 1),
      _CardConfig(offset: 2),
    ];

    configs.sort((a, b) {
      int za = a.offset == 0 ? 3 : (a.offset.abs() == 1 ? 2 : 1);
      int zb = b.offset == 0 ? 3 : (b.offset.abs() == 1 ? 2 : 1);
      return za.compareTo(zb);
    });

    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: SizedBox(
        width: stackWidth,
        height: cardHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: configs.map((cfg) {
            int idx = _getCardIndex(cfg.offset);
            double t = dragDelta.clamp(-1.0, 1.0);
            double baseAngle = cfg.offset * (math.pi / 2);
            double localAngle = baseAngle + angle;
            double x = widget.radius * math.sin(localAngle);
            double z = 1.0;
            double scale = 0.4;
            if (cfg.offset == 0) {
              // Center card
              scale = 1.0 - 0.4 * t.abs();
              z = 2 + (1 - t.abs());
            } else if (cfg.offset == -1) {
              // Left card
              double scaleFactor = 0.4;
              if (dragDelta < 0) {
                scaleFactor = 0.2;
              }
              scale = 0.6 + scaleFactor * t;
              z = -1 + t;
            } else if (cfg.offset == 1) {
              // Right card
              double scaleFactor = 0.4;
              if (dragDelta > 0) {
                scaleFactor = 0.2;
              }
              scale = 0.6 + scaleFactor * (-t);
              z = 1 + (1 - t.abs());
            } else if (cfg.offset == -2) {
              // Far left, entering
              scale = 0.4 + 0.2 * t;
              z = 0 + t;
            } else if (cfg.offset == 2) {
              // Far right, entering
              if (dragDelta < 0) {
                t = -t;
              }
              scale = 0.4 + 0.2 * t;
              z = 0 + t;
            }
            double opacity = scale > 0.5 ? 1.0 : 0.3;

            // Center the card in Stack and add circular offset
            double leftPosition = centerOffset + (x * 0.75);

            return Positioned(
              left: leftPosition,
              top: cardHeight * 0.1,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0, z)
                  ..scale(scale, scale),
                child: Opacity(
                  opacity: opacity,
                  child: IgnorePointer(
                    ignoring: cfg.offset != 0,
                    child: widget.cards[idx],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CardConfig {
  final int offset;
  _CardConfig({required this.offset});
}

double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
