# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-01-29

### Fixed
- Fixed deprecated Matrix4.translate() calls in 3D carousel and stacked carousel
- Shortened pubspec description to meet pub.dev requirements  
- Updated GitHub repository URLs

## [0.1.0] - 2026-01-29

### Added
- Initial release of infinite_cycle_carousel package
- **Multiple Carousel Variants:**
  - `CycleCarousel` - Basic 2D infinite scrolling carousel
  - `InfiniteCycleCarousel3D` - 3D cylindrical carousel with perspective effects
  - `InfiniteCycleViewPager` - Android ViewPager-style with overlapping cards
  - `CircularCarousel` - Unique circular positioning with depth and scale effects
  - `StackedGlimpseCarousel` - Stacked cards with glimpse of side items
- `InfiniteCycleCarouselController` for programmatic control
- `CarouselIndicator` widget with multiple styles (dot, line, scale)
- `CarouselOptions` for extensive customization
- `InfiniteCycleConfig` for ViewPager-style carousel configuration
- Auto play functionality with customizable intervals
- Enlarge center page effect
- Support for both horizontal and vertical scrolling
- Touch interaction controls with drag gestures
- Pause auto play on touch feature
- Custom scroll physics support
- Page change callbacks
- 3D transformations with glass effects
- Circular positioning with radius-based layouts
- Comprehensive example app demonstrating 9 carousel variants
- Full documentation and README

### Features
- **9 Different Carousel Styles** to choose from
- Infinite scrolling on all carousel types
- Auto play with customizable intervals and curves
- Multiple indicator styles and positions
- Programmatic navigation (next, previous, jump to page, animate to page)
- Center page enlargement effect
- Flexible viewport fraction
- Custom item padding
- Touch gesture controls
- Both horizontal and vertical scroll directions
- 3D perspective transformations
- Circular depth effects with scaling
- Responsive and adaptive layouts
- No external dependencies (pure Flutter)

[0.1.0]: https://github.com/yourusername/infinite_cycle_carousel/releases/tag/v0.1.0
