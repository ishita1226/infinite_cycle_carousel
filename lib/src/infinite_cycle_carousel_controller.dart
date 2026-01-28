import 'package:flutter/material.dart';

/// Controller for the infinite cycle carousel
class InfiniteCycleCarouselController extends ChangeNotifier {
  PageController? _pageController;
  int _currentPage = 0;
  int _realItemCount = 0;
  bool _isInfinite = true;

  /// Get the current page index
  int get currentPage => _currentPage;

  /// Get the real item count
  int get realItemCount => _realItemCount;

  /// Initialize the controller with parameters
  void initialize({
    required int initialPage,
    required int itemCount,
    required bool enableInfiniteScroll,
    required double viewportFraction,
  }) {
    _realItemCount = itemCount;
    _isInfinite = enableInfiniteScroll && itemCount > 1;

    int startPage = _isInfinite ? initialPage + itemCount * 1000 : initialPage;
    _currentPage = initialPage;

    _pageController = PageController(
      initialPage: startPage,
      viewportFraction: viewportFraction,
    );
  }

  /// Get the page controller
  PageController? get pageController => _pageController;

  /// Jump to a specific page
  void jumpToPage(int page) {
    if (_pageController == null || _realItemCount == 0) return;

    final targetPage = _isInfinite ? page + _realItemCount * 1000 : page;
    _pageController!.jumpToPage(targetPage);
    _currentPage = page % _realItemCount;
    notifyListeners();
  }

  /// Animate to a specific page
  Future<void> animateToPage(
    int page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_pageController == null || _realItemCount == 0) return;

    final targetPage = _isInfinite ? page + _realItemCount * 1000 : page;
    await _pageController!.animateToPage(
      targetPage,
      duration: duration,
      curve: curve,
    );
    _currentPage = page % _realItemCount;
    notifyListeners();
  }

  /// Go to next page
  Future<void> nextPage({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_pageController == null || _realItemCount == 0) return;

    await _pageController!.nextPage(duration: duration, curve: curve);
  }

  /// Go to previous page
  Future<void> previousPage({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_pageController == null || _realItemCount == 0) return;

    await _pageController!.previousPage(duration: duration, curve: curve);
  }

  /// Update the current page
  void updatePage(int page) {
    if (_realItemCount == 0 || _realItemCount == 1) {
      _currentPage = 0;
      notifyListeners();
      return;
    }
    _currentPage = page % _realItemCount;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
