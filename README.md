# Infinite Cycle Carousel

A comprehensive Flutter package for creating beautiful, customizable infinite cycle carousels with smooth animations and various display styles. Inspired by Android's InfiniteCycleViewPager, this package provides multiple carousel variants including 2D, 3D, ViewPager-style, and circular carousels.

## Features

✨ **Multiple Carousel Variants** - 9 different carousel styles to choose from  
🔄 **Infinite Scrolling** - Seamlessly loop through items without boundaries  
🎯 **Auto Play** - Automatically cycle through items with customizable intervals  
📐 **Flexible Layout** - Support for both horizontal and vertical scrolling  
🎨 **Customizable Indicators** - Multiple indicator styles (dot, line, scale)  
🎭 **3D Effects** - Cylindrical 3D carousel with glass effects  
🌀 **Circular Carousel** - Unique circular positioning with depth effects  
⚙️ **Full Control** - Programmatic control via controller  
🎬 **Smooth Animations** - Beautiful transitions with customizable curves  
📱 **Responsive** - Adapts to different screen sizes  

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  infinite_cycle_carousel: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### 1. Basic Carousel

```dart
import 'package:infinite_cycle_carousel/infinite_cycle_carousel.dart';

CycleCarousel(
  items: [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
  ],
  options: const CarouselOptions(
    height: 200,
    autoPlay: true,
  ),
)
```

### 2. Carousel with Indicators

```dart
final controller = InfiniteCycleCarouselController();

Column(
  children: [
    CycleCarousel(
      controller: controller,
      items: yourWidgetList,
      options: const CarouselOptions(
        height: 200,
        autoPlay: true,
        viewportFraction: 0.9,
      ),
    ),
    CarouselIndicator(
      controller: controller,
      itemCount: yourWidgetList.length,
      style: IndicatorStyle.dot,
      activeColor: Colors.blue,
      inactiveColor: Colors.grey,
    ),
  ],
)
```

### 3. Carousel with Enlarged Center Page

```dart
CycleCarousel(
  items: yourWidgetList,
  options: const CarouselOptions(
    height: 250,
    viewportFraction: 0.8,
    enlargeCenterPage: true,
    enlargeFactor: 0.3,
    autoPlay: true,
  ),
)
```

### 4. 3D Cylindrical Carousel

```dart
InfiniteCycleCarousel3D(
  itemCount: 5,
  height: 400,
  itemWidth: 350,
  radius: 500,
  perspective: 0.003,
  enableGlassEffect: true,
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(child: Text('Card $index')),
    );
  },
)
```

### 5. ViewPager Style Carousel

```dart
InfiniteCycleViewPager(
  itemCount: 5,
  carouselHeight: 280,
  config: const InfiniteCycleConfig(
    viewportFraction: 0.85,
    centerItemScale: 1.0,
    sideItemScale: 0.8,
    sideItemOpacity: 0.6,
    overlapFactor: -0.3,
    autoScroll: true,
  ),
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(16),
      ),
    );
  },
)
```

### 6. Circular Carousel

```dart
CircularCarousel(
  cards: [
    Container(width: 280, height: 180, color: Colors.red),
    Container(width: 280, height: 180, color: Colors.blue),
    Container(width: 280, height: 180, color: Colors.green),
  ],
  radius: 120,
)
```

### 7. Stacked Carousel

```dart
StackedGlimpseCarousel(
  itemCount: 5,
  height: 180,
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.pink],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  },
)
```

### 8. Controlled Carousel

```dart
final controller = InfiniteCycleCarouselController();

CycleCarousel(
  controller: controller,
  items: yourWidgetList,
  options: CarouselOptions(
    height: 200,
    autoPlay: false,
    onPageChanged: (index) {
      print('Current page: $index');
    },
  ),
)

// Control programmatically
controller.nextPage();
controller.previousPage();
controller.jumpToPage(2);
```

### 9. Vertical Carousel

```dart
CycleCarousel(
  items: yourWidgetList,
  options: const CarouselOptions(
    height: 300,
    scrollDirection: Axis.vertical,
    autoPlay: true,
  ),
)
```

## Available Carousel Widgets

| Widget | Description |
|--------|-------------|
| `CycleCarousel` | Basic 2D carousel with infinite scrolling |
| `InfiniteCycleCarousel3D` | 3D cylindrical carousel with perspective effects |
| `InfiniteCycleViewPager` | ViewPager-style with overlapping cards |
| `CircularCarousel` | Circular positioning with depth and scale effects |
| `StackedGlimpseCarousel` | Stacked cards with glimpse of side items |
| `CarouselIndicator` | Customizable page indicators |

## Carousel Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `height` | `double?` | `null` | Height of the carousel |
| `aspectRatio` | `double` | `16/9` | Aspect ratio when height is null |
| `enableInfiniteScroll` | `bool` | `true` | Enable infinite scrolling |
| `autoPlay` | `bool` | `false` | Enable auto play |
| `autoPlayInterval` | `Duration` | `3s` | Auto play interval |
| `autoPlayAnimationDuration` | `Duration` | `800ms` | Auto play animation duration |
| `autoPlayCurve` | `Curve` | `fastOutSlowIn` | Auto play animation curve |
| `reverseAutoPlay` | `bool` | `false` | Reverse auto play direction |
| `enlargeCenterPage` | `bool` | `false` | Enlarge the center page |
| `enlargeFactor` | `double` | `0.3` | Enlargement factor (0.0-1.0) |
| `scrollDirection` | `Axis` | `horizontal` | Scroll direction |
| `initialPage` | `int` | `0` | Initial page index |
| `viewportFraction` | `double` | `1.0` | Viewport fraction (0.0-1.0) |
| `enableTouchInteraction` | `bool` | `true` | Enable touch gestures |
| `onPageChanged` | `Function(int)?` | `null` | Page changed callback |
| `scrollPhysics` | `ScrollPhysics?` | `null` | Custom scroll physics |
| `pauseAutoPlayOnTouch` | `bool` | `true` | Pause auto play on touch |
| `itemPadding` | `EdgeInsets?` | `null` | Padding around each item |

## Indicator Styles

The package includes three built-in indicator styles:

- **`IndicatorStyle.dot`** - Classic dot indicators
- **`IndicatorStyle.line`** - Line indicators that expand when active
- **`IndicatorStyle.scale`** - Dots that scale up when active

## Controller Methods

| Method | Description |
|--------|-------------|
| `nextPage()` | Navigate to the next page |
| `previousPage()` | Navigate to the previous page |
| `jumpToPage(int page)` | Jump to a specific page |
| `animateToPage(int page)` | Animate to a specific page |
| `currentPage` | Get the current page index |

## Example

Check out the [example](example/lib/main.dart) folder for a complete example app demonstrating all features.

To run the example:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a ⭐ on GitHub!
