import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// A true 3D carousel widget with circular/cylindrical rotation
class InfiniteCycleCarousel3D extends StatefulWidget {
  /// Number of items in the carousel
  final int itemCount;

  /// Builder for each carousel item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Height of the carousel
  final double height;

  /// Width of each card
  final double itemWidth;

  /// Radius of the 3D cylinder
  final double radius;

  /// Perspective strength (lower = stronger perspective)
  final double perspective;

  /// Enable glass morphism effect
  final bool enableGlassEffect;

  /// Glass effect blur strength
  final double glassBlur;

  /// Glass effect opacity
  final double glassOpacity;

  /// Page change callback
  final void Function(int index)? onPageChanged;

  /// Enable auto play
  final bool autoPlay;

  /// Auto play interval
  final Duration autoPlayInterval;

  const InfiniteCycleCarousel3D({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 300,
    this.itemWidth = 280,
    this.radius = 400,
    this.perspective = 0.002,
    this.enableGlassEffect = true,
    this.glassBlur = 10,
    this.glassOpacity = 0.2,
    this.onPageChanged,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<InfiniteCycleCarousel3D> createState() =>
      _InfiniteCycleCarousel3DState();
}

class _InfiniteCycleCarousel3DState extends State<InfiniteCycleCarousel3D> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.itemCount * 10000;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.4, // Show parts of adjacent cards
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          widget.onPageChanged?.call(index % widget.itemCount);
        },
        itemCount: null, // Infinite
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double pageOffset = 0.0;
              if (_pageController.position.haveDimensions) {
                pageOffset =
                    (_pageController.page ?? _currentPage.toDouble()) - index;
              }
              return _build3DCard(context, index, pageOffset);
            },
          );
        },
      ),
    );
  }

  Widget _build3DCard(BuildContext context, int index, double pageOffset) {
    final realIndex = index % widget.itemCount;

    // Calculate angle for circular positioning
    final angle = pageOffset * (math.pi / 4); // 45 degrees per page

    // Calculate 3D position on cylinder
    final translateX = widget.radius * math.sin(angle);
    final translateZ = widget.radius * (1 - math.cos(angle));

    // Calculate opacity based on angle
    final opacity = (1 - pageOffset.abs().clamp(0.0, 1.0)).clamp(0.3, 1.0);

    // Scale based on depth
    final scale = 1.0 - (translateZ / widget.radius * 0.3);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, widget.perspective) // Perspective
        ..translate(translateX, 0.0, -translateZ)
        ..rotateY(-angle),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale.clamp(0.7, 1.0),
          child: Container(
            width: widget.itemWidth,
            padding: const EdgeInsets.all(16),
            child: widget.enableGlassEffect
                ? _buildGlassCard(context, realIndex)
                : widget.itemBuilder(context, realIndex),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.glassBlur,
          sigmaY: widget.glassBlur,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: widget.glassOpacity),
                Colors.white.withValues(alpha: widget.glassOpacity * 0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: widget.itemBuilder(context, index),
        ),
      ),
    );
  }
}
