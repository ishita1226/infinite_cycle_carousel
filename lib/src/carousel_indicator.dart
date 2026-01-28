import 'package:flutter/material.dart';
import 'infinite_cycle_carousel_controller.dart';

/// Style options for carousel indicators
enum IndicatorStyle { dot, line, scale }

/// Position of the indicator
enum IndicatorPosition { top, bottom, left, right }

/// A widget that displays indicators for the carousel
class CarouselIndicator extends StatelessWidget {
  /// Controller for the carousel
  final InfiniteCycleCarouselController controller;

  /// Total number of items
  final int itemCount;

  /// Style of the indicator
  final IndicatorStyle style;

  /// Position of the indicator
  final IndicatorPosition position;

  /// Active indicator color
  final Color activeColor;

  /// Inactive indicator color
  final Color inactiveColor;

  /// Size of the indicator
  final double size;

  /// Spacing between indicators
  final double spacing;

  /// Active indicator scale (for scale style)
  final double activeScale;

  /// Border radius for indicators
  final BorderRadius? borderRadius;

  /// Alignment of indicators
  final MainAxisAlignment alignment;

  /// Padding around the indicator widget
  final EdgeInsets padding;

  const CarouselIndicator({
    super.key,
    required this.controller,
    required this.itemCount,
    this.style = IndicatorStyle.dot,
    this.position = IndicatorPosition.bottom,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
    this.size = 8.0,
    this.spacing = 8.0,
    this.activeScale = 1.5,
    this.borderRadius,
    this.alignment = MainAxisAlignment.center,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return _buildIndicatorByStyle();
        },
      ),
    );
  }

  Widget _buildIndicatorByStyle() {
    // Safety check: Don't build if itemCount is invalid
    if (itemCount <= 0) {
      return const SizedBox.shrink();
    }

    final isVertical =
        position == IndicatorPosition.left ||
        position == IndicatorPosition.right;

    return Flex(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: List.generate(itemCount, (index) {
        final isActive = controller.currentPage == index;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isVertical ? 0 : spacing / 2,
            vertical: isVertical ? spacing / 2 : 0,
          ),
          child: _buildIndicatorItem(index, isActive),
        );
      }),
    );
  }

  Widget _buildIndicatorItem(int index, bool isActive) {
    switch (style) {
      case IndicatorStyle.dot:
        return _buildDotIndicator(isActive);
      case IndicatorStyle.line:
        return _buildLineIndicator(isActive);
      case IndicatorStyle.scale:
        return _buildScaleIndicator(isActive);
    }
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLineIndicator(bool isActive) {
    final isVertical =
        position == IndicatorPosition.left ||
        position == IndicatorPosition.right;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isVertical ? size : (isActive ? size * 2.5 : size),
      height: isVertical ? (isActive ? size * 2.5 : size) : size,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
      ),
    );
  }

  Widget _buildScaleIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? size * activeScale : size,
      height: isActive ? size * activeScale : size,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        shape: BoxShape.circle,
        border: isActive
            ? Border.all(color: activeColor.withValues(alpha: 0.3), width: 2)
            : null,
      ),
    );
  }
}

/// Builder for custom carousel indicators
class CarouselIndicatorBuilder extends StatelessWidget {
  /// Controller for the carousel
  final InfiniteCycleCarouselController controller;

  /// Total number of items
  final int itemCount;

  /// Builder function for custom indicator
  final Widget Function(BuildContext context, int index, bool isActive) builder;

  const CarouselIndicatorBuilder({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return builder(context, controller.currentPage, true);
      },
    );
  }
}
