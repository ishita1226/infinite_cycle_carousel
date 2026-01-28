import 'package:flutter/material.dart';

/// Options for customizing the infinite cycle carousel
class CarouselOptions {
  /// Height of the carousel
  final double? height;

  /// Aspect ratio of the carousel items
  final double aspectRatio;

  /// Whether to enable infinite scrolling
  final bool enableInfiniteScroll;

  /// Whether to enable auto play
  final bool autoPlay;

  /// Auto play interval duration
  final Duration autoPlayInterval;

  /// Auto play animation duration
  final Duration autoPlayAnimationDuration;

  /// Auto play curve
  final Curve autoPlayCurve;

  /// Whether to reverse the auto play direction
  final bool reverseAutoPlay;

  /// Whether to enlarge the center page
  final bool enlargeCenterPage;

  /// Fraction to which the center page should be enlarged
  final double enlargeFactor;

  /// Scroll direction (horizontal or vertical)
  final Axis scrollDirection;

  /// Initial page index
  final int initialPage;

  /// Viewport fraction (0.0 to 1.0)
  final double viewportFraction;

  /// Whether to enable touch gestures
  final bool enableTouchInteraction;

  /// Page changed callback
  final void Function(int index)? onPageChanged;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Whether to pause auto play when touching
  final bool pauseAutoPlayOnTouch;

  /// Padding around each carousel item
  final EdgeInsets? itemPadding;

  const CarouselOptions({
    this.height,
    this.aspectRatio = 16 / 9,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.reverseAutoPlay = false,
    this.enlargeCenterPage = false,
    this.enlargeFactor = 0.3,
    this.scrollDirection = Axis.horizontal,
    this.initialPage = 0,
    this.viewportFraction = 1.0,
    this.enableTouchInteraction = true,
    this.onPageChanged,
    this.scrollPhysics,
    this.pauseAutoPlayOnTouch = true,
    this.itemPadding,
  }) : assert(
         viewportFraction > 0.0 && viewportFraction <= 1.0,
         'viewportFraction must be between 0.0 and 1.0',
       ),
       assert(
         enlargeFactor >= 0.0 && enlargeFactor <= 1.0,
         'enlargeFactor must be between 0.0 and 1.0',
       );

  CarouselOptions copyWith({
    double? height,
    double? aspectRatio,
    bool? enableInfiniteScroll,
    bool? autoPlay,
    Duration? autoPlayInterval,
    Duration? autoPlayAnimationDuration,
    Curve? autoPlayCurve,
    bool? reverseAutoPlay,
    bool? enlargeCenterPage,
    double? enlargeFactor,
    Axis? scrollDirection,
    int? initialPage,
    double? viewportFraction,
    bool? enableTouchInteraction,
    void Function(int index)? onPageChanged,
    ScrollPhysics? scrollPhysics,
    bool? pauseAutoPlayOnTouch,
    EdgeInsets? itemPadding,
  }) {
    return CarouselOptions(
      height: height ?? this.height,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      enableInfiniteScroll: enableInfiniteScroll ?? this.enableInfiniteScroll,
      autoPlay: autoPlay ?? this.autoPlay,
      autoPlayInterval: autoPlayInterval ?? this.autoPlayInterval,
      autoPlayAnimationDuration:
          autoPlayAnimationDuration ?? this.autoPlayAnimationDuration,
      autoPlayCurve: autoPlayCurve ?? this.autoPlayCurve,
      reverseAutoPlay: reverseAutoPlay ?? this.reverseAutoPlay,
      enlargeCenterPage: enlargeCenterPage ?? this.enlargeCenterPage,
      enlargeFactor: enlargeFactor ?? this.enlargeFactor,
      scrollDirection: scrollDirection ?? this.scrollDirection,
      initialPage: initialPage ?? this.initialPage,
      viewportFraction: viewportFraction ?? this.viewportFraction,
      enableTouchInteraction:
          enableTouchInteraction ?? this.enableTouchInteraction,
      onPageChanged: onPageChanged ?? this.onPageChanged,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      pauseAutoPlayOnTouch: pauseAutoPlayOnTouch ?? this.pauseAutoPlayOnTouch,
      itemPadding: itemPadding ?? this.itemPadding,
    );
  }
}
