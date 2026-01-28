import 'dart:async';
import 'package:flutter/material.dart';
import 'models/infinite_cycle_config.dart';

/// A reusable carousel widget that replicates Android's InfiniteCycleViewPager
/// with full configuration support and overlapping card layout
class InfiniteCycleViewPager extends StatefulWidget {
  /// Number of items in the carousel
  final int itemCount;

  /// Builder for each carousel item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Height of the carousel
  final double carouselHeight;

  /// Configuration for carousel behavior and appearance
  final InfiniteCycleConfig config;

  /// Callback when the current item changes
  final void Function(int index)? onItemChanged;

  /// Callback when an item is tapped
  final void Function(int index)? onItemTap;

  const InfiniteCycleViewPager({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.carouselHeight = 300,
    this.config = const InfiniteCycleConfig(),
    this.onItemChanged,
    this.onItemTap,
  }) : assert(itemCount > 0, 'itemCount must be greater than 0');

  @override
  State<InfiniteCycleViewPager> createState() => _InfiniteCycleViewPagerState();
}

class _InfiniteCycleViewPagerState extends State<InfiniteCycleViewPager> {
  late PageController _pageController;
  late int _currentPage;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    // Start at a high page number for infinite scroll illusion
    _currentPage = widget.itemCount * 10000;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: widget.config.viewportFraction,
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (widget.config.autoScroll && widget.itemCount > 1) {
      _autoScrollTimer?.cancel();
      _autoScrollTimer = Timer.periodic(
        widget.config.autoScrollInterval,
        (_) => _nextPage(),
      );
    }
  }

  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: widget.config.animationDuration,
        curve: widget.config.animationCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.carouselHeight,
      child: PageView.builder(
        controller: _pageController,
        physics: widget.config.enableSnapping
            ? const PageScrollPhysics()
            : const ClampingScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          widget.onItemChanged?.call(index % widget.itemCount);
        },
        itemCount: null, // Infinite
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double pageOffset = 0.0;
              if (_pageController.position.haveDimensions) {
                final page = _pageController.page ?? _currentPage.toDouble();
                pageOffset = page - index;
              }
              return _buildCarouselItem(context, index, pageOffset);
            },
          );
        },
      ),
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    int index,
    double pageOffset,
  ) {
    final realIndex = index % widget.itemCount;

    // Calculate transformations based on page offset
    final absOffset = pageOffset.abs();

    // Scale: center item is largest, side items are smaller
    double scale;
    if (absOffset < 1.0) {
      scale =
          widget.config.centerItemScale -
          (absOffset *
              (widget.config.centerItemScale - widget.config.sideItemScale));
    } else {
      scale = widget.config.sideItemScale;
    }

    // Opacity: fade side items
    double opacity;
    if (absOffset < 1.0) {
      opacity = 1.0 - (absOffset * (1.0 - widget.config.sideItemOpacity));
    } else {
      opacity = widget.config.sideItemOpacity;
    }

    // Horizontal translation for overlap effect
    final translateX = pageOffset * widget.config.overlapFactor * 100;

    // Elevation/z-index simulation
    // Center item should have highest elevation
    final elevation = widget.config.elevationFactor * (1.0 - absOffset);

    // Card height based on carousel height
    final cardHeight = widget.carouselHeight * widget.config.cardHeightRatio;

    return GestureDetector(
      onTap: () => widget.onItemTap?.call(realIndex),
      child: Transform.translate(
        offset: Offset(translateX, 0),
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale.clamp(0.0, 2.0),
            child: Container(
              height: cardHeight,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: elevation.clamp(0, 50),
                    offset: Offset(0, elevation.clamp(0, 20) / 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    widget.itemBuilder(context, realIndex),
                    // Overlay to show depth when not center
                    if (absOffset > 0.1)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                              alpha: (absOffset * 0.3).clamp(0, 0.4),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
