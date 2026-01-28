import 'package:flutter/material.dart';

/// Configuration for InfiniteCycleCarousel
class InfiniteCycleConfig {
  /// Viewport fraction (0.0 to 1.0) - how much of each side item is visible
  final double viewportFraction;

  /// Scale factor for center item (1.0 = full size)
  final double centerItemScale;

  /// Scale factor for side items (0.0 to 1.0)
  final double sideItemScale;

  /// Opacity for side items (0.0 to 1.0)
  final double sideItemOpacity;

  /// Horizontal overlap factor - negative values create overlap
  final double overlapFactor;

  /// Elevation factor for z-index depth effect
  final double elevationFactor;

  /// Enable auto scroll
  final bool autoScroll;

  /// Auto scroll interval
  final Duration autoScrollInterval;

  /// Animation duration for page transitions
  final Duration animationDuration;

  /// Animation curve
  final Curve animationCurve;

  /// Card height ratio relative to carousel height
  final double cardHeightRatio;

  /// Enable smooth page snapping
  final bool enableSnapping;

  const InfiniteCycleConfig({
    this.viewportFraction = 0.8,
    this.centerItemScale = 1.0,
    this.sideItemScale = 0.85,
    this.sideItemOpacity = 0.7,
    this.overlapFactor = -0.2,
    this.elevationFactor = 20.0,
    this.autoScroll = false,
    this.autoScrollInterval = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeOutCubic,
    this.cardHeightRatio = 0.85,
    this.enableSnapping = true,
  }) : assert(viewportFraction > 0.0 && viewportFraction <= 1.0),
       assert(centerItemScale >= 0.0),
       assert(sideItemScale >= 0.0 && sideItemScale <= 1.0),
       assert(sideItemOpacity >= 0.0 && sideItemOpacity <= 1.0),
       assert(cardHeightRatio > 0.0 && cardHeightRatio <= 1.0);

  InfiniteCycleConfig copyWith({
    double? viewportFraction,
    double? centerItemScale,
    double? sideItemScale,
    double? sideItemOpacity,
    double? overlapFactor,
    double? elevationFactor,
    bool? autoScroll,
    Duration? autoScrollInterval,
    Duration? animationDuration,
    Curve? animationCurve,
    double? cardHeightRatio,
    bool? enableSnapping,
  }) {
    return InfiniteCycleConfig(
      viewportFraction: viewportFraction ?? this.viewportFraction,
      centerItemScale: centerItemScale ?? this.centerItemScale,
      sideItemScale: sideItemScale ?? this.sideItemScale,
      sideItemOpacity: sideItemOpacity ?? this.sideItemOpacity,
      overlapFactor: overlapFactor ?? this.overlapFactor,
      elevationFactor: elevationFactor ?? this.elevationFactor,
      autoScroll: autoScroll ?? this.autoScroll,
      autoScrollInterval: autoScrollInterval ?? this.autoScrollInterval,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      cardHeightRatio: cardHeightRatio ?? this.cardHeightRatio,
      enableSnapping: enableSnapping ?? this.enableSnapping,
    );
  }
}
