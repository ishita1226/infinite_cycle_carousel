// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_cycle_carousel/infinite_cycle_carousel.dart';

void main() {
  group('InfiniteCycleCarousel', () {
    testWidgets('should render carousel with items', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CycleCarousel(
              items: [
                Container(key: const Key('item1'), color: Colors.red),
                Container(key: const Key('item2'), color: Colors.blue),
                Container(key: const Key('item3'), color: Colors.green),
              ],
              options: const CarouselOptions(height: 200),
            ),
          ),
        ),
      );

      // Verify that the carousel is rendered
      expect(find.byType(CycleCarousel), findsOneWidget);
    });

    testWidgets('should respect height option', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CycleCarousel(
              items: [
                Container(color: Colors.red),
                Container(color: Colors.blue),
              ],
              options: const CarouselOptions(height: 300),
            ),
          ),
        ),
      );

      // Find the SizedBox that wraps the carousel
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 300);
    });
  });

  group('InfiniteCycleCarouselController', () {
    test('should initialize with correct values', () {
      final controller = InfiniteCycleCarouselController();

      controller.initialize(
        initialPage: 0,
        itemCount: 5,
        enableInfiniteScroll: true,
        viewportFraction: 1.0,
      );

      expect(controller.currentPage, 0);
      expect(controller.realItemCount, 5);
    });

    test('should update current page', () {
      final controller = InfiniteCycleCarouselController();

      controller.initialize(
        initialPage: 0,
        itemCount: 5,
        enableInfiniteScroll: true,
        viewportFraction: 1.0,
      );

      controller.updatePage(7);
      expect(controller.currentPage, 2); // 7 % 5 = 2
    });
  });

  group('CarouselOptions', () {
    test('should create options with default values', () {
      const options = CarouselOptions();

      expect(options.aspectRatio, 16 / 9);
      expect(options.enableInfiniteScroll, true);
      expect(options.autoPlay, false);
      expect(options.enlargeCenterPage, false);
      expect(options.scrollDirection, Axis.horizontal);
      expect(options.viewportFraction, 1.0);
    });

    test('should create options with custom values', () {
      const options = CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      );

      expect(options.height, 200);
      expect(options.autoPlay, true);
      expect(options.enlargeCenterPage, true);
      expect(options.viewportFraction, 0.8);
    });

    test('should copy options with modifications', () {
      const original = CarouselOptions(height: 200, autoPlay: true);
      final copied = original.copyWith(autoPlay: false, height: 300);

      expect(copied.height, 300);
      expect(copied.autoPlay, false);
    });
  });

  group('CarouselIndicator', () {
    testWidgets('should render indicators', (WidgetTester tester) async {
      final controller = InfiniteCycleCarouselController();
      controller.initialize(
        initialPage: 0,
        itemCount: 3,
        enableInfiniteScroll: true,
        viewportFraction: 1.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarouselIndicator(controller: controller, itemCount: 3),
          ),
        ),
      );

      expect(find.byType(CarouselIndicator), findsOneWidget);
    });
  });
}
