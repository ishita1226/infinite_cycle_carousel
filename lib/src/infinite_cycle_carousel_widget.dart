import 'dart:async';
import 'package:flutter/material.dart';
import 'infinite_cycle_carousel_controller.dart';
import 'models/carousel_options.dart';

/// A widget that creates an infinite cycle carousel
class CycleCarousel extends StatefulWidget {
  /// List of widgets to display in the carousel
  final List<Widget> items;

  /// Carousel customization options
  final CarouselOptions options;

  /// Custom carousel controller
  final InfiniteCycleCarouselController? controller;

  const CycleCarousel({
    super.key,
    required this.items,
    this.options = const CarouselOptions(),
    this.controller,
  }) : assert(items.length > 0, 'items must not be empty');

  @override
  State<CycleCarousel> createState() => _InfiniteCycleCarouselState();
}

class _InfiniteCycleCarouselState extends State<CycleCarousel> {
  late InfiniteCycleCarouselController _controller;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? InfiniteCycleCarouselController();
    _initializeCarousel();
    _startAutoPlay();
  }

  void _initializeCarousel() {
    _controller.initialize(
      initialPage: widget.options.initialPage,
      itemCount: widget.items.length,
      enableInfiniteScroll: widget.options.enableInfiniteScroll,
      viewportFraction: widget.options.viewportFraction,
    );
  }

  void _startAutoPlay() {
    if (widget.options.autoPlay && widget.items.length > 1) {
      _autoPlayTimer = Timer.periodic(widget.options.autoPlayInterval, (timer) {
        if (!_isUserInteracting || !widget.options.pauseAutoPlayOnTouch) {
          _autoPlayNext();
        }
      });
    }
  }

  void _autoPlayNext() {
    if (_controller.pageController != null) {
      final currentPage = _controller.pageController!.page ?? 0;
      final nextPage = widget.options.reverseAutoPlay
          ? currentPage - 1
          : currentPage + 1;

      _controller.pageController!.animateToPage(
        nextPage.toInt(),
        duration: widget.options.autoPlayAnimationDuration,
        curve: widget.options.autoPlayCurve,
      );
    }
  }

  @override
  void didUpdateWidget(CycleCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length ||
        oldWidget.options.initialPage != widget.options.initialPage ||
        oldWidget.options.enableInfiniteScroll !=
            widget.options.enableInfiniteScroll ||
        oldWidget.options.viewportFraction != widget.options.viewportFraction) {
      _initializeCarousel();
    }

    if (oldWidget.options.autoPlay != widget.options.autoPlay ||
        oldWidget.options.autoPlayInterval != widget.options.autoPlayInterval) {
      _autoPlayTimer?.cancel();
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.options.height,
      child: AspectRatio(
        aspectRatio: widget.options.height != null
            ? 1.0
            : widget.options.aspectRatio,
        child: Listener(
          onPointerDown: widget.options.pauseAutoPlayOnTouch
              ? (_) => setState(() => _isUserInteracting = true)
              : null,
          onPointerUp: widget.options.pauseAutoPlayOnTouch
              ? (_) => setState(() => _isUserInteracting = false)
              : null,
          onPointerCancel: widget.options.pauseAutoPlayOnTouch
              ? (_) => setState(() => _isUserInteracting = false)
              : null,
          child: PageView.builder(
            controller: _controller.pageController,
            scrollDirection: widget.options.scrollDirection,
            physics: widget.options.enableTouchInteraction
                ? (widget.options.scrollPhysics ?? const PageScrollPhysics())
                : const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              if (widget.items.isEmpty) return;
              final realIndex = index % widget.items.length;
              _controller.updatePage(index);
              widget.options.onPageChanged?.call(realIndex);
            },
            itemBuilder: (context, index) {
              if (widget.items.isEmpty) {
                return const SizedBox.shrink();
              }
              final realIndex = index % widget.items.length;
              return _buildCarouselItem(context, realIndex, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    int realIndex,
    int pageIndex,
  ) {
    // Safety check for valid index
    if (realIndex < 0 || realIndex >= widget.items.length) {
      return const SizedBox.shrink();
    }

    Widget item = widget.items[realIndex];

    if (widget.options.itemPadding != null) {
      item = Padding(padding: widget.options.itemPadding!, child: item);
    }

    if (widget.options.enlargeCenterPage) {
      return AnimatedBuilder(
        animation: _controller.pageController!,
        builder: (context, child) {
          double value = 1.0;
          if (_controller.pageController!.position.haveDimensions) {
            final page =
                _controller.pageController!.page ?? pageIndex.toDouble();
            value = (page - pageIndex).abs();
            value = (1 - (value * widget.options.enlargeFactor)).clamp(
              0.0,
              1.0,
            );
          }

          return Center(
            child: SizedBox(
              height: widget.options.scrollDirection == Axis.horizontal
                  ? null
                  : Curves.easeOut.transform(value) *
                        (widget.options.height ??
                            MediaQuery.of(context).size.height),
              width: widget.options.scrollDirection == Axis.vertical
                  ? null
                  : Curves.easeOut.transform(value) *
                        MediaQuery.of(context).size.width *
                        widget.options.viewportFraction,
              child: child,
            ),
          );
        },
        child: item,
      );
    }

    return item;
  }
}
