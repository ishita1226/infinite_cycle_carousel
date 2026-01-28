import 'package:flutter/material.dart';
import 'package:infinite_cycle_carousel/infinite_cycle_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Cycle Carousel Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CarouselExamplePage(),
    );
  }
}

class CarouselExamplePage extends StatefulWidget {
  const CarouselExamplePage({super.key});

  @override
  State<CarouselExamplePage> createState() => _CarouselExamplePageState();
}

class _CarouselExamplePageState extends State<CarouselExamplePage> {
  final InfiniteCycleCarouselController _controller =
      InfiniteCycleCarouselController();
  int _currentPage = 0;

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Carousel Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Basic Carousel with Auto Play'),
            _buildBasicCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('2. Carousel with Indicators'),
            _buildCarouselWithIndicators(),
            const SizedBox(height: 20),

            _buildSectionTitle('3. Carousel with Left and Right Display'),
            _buildEnlargeCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('4. Controlled Carousel'),
            _buildControlledCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('5. Vertical Carousel'),
            _buildVerticalCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('6. 3D Carousel'),
            _build3DCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('7. ViewPager Style'),
            _buildViewPagerCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('8. Circular Carousel'),
            _buildStackedCardCarousel(),
            const SizedBox(height: 20),

            _buildSectionTitle('9. Stacked Carousel'),
            _buildStackedCarousel(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBasicCarousel() {
    return CycleCarousel(
      items: _colors.asMap().entries.map((entry) {
        final index = entry.key;
        final color = entry.value;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'Slide ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
      options: const CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enlargeCenterPage: false,
      ),
    );
  }

  Widget _buildCarouselWithIndicators() {
    final controller = InfiniteCycleCarouselController();

    return Column(
      children: [
        CycleCarousel(
          controller: controller,
          items: List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _colors[index],
                    _colors[index].withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Slide ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          options: const CarouselOptions(
            height: 200,
            autoPlay: true,
            viewportFraction: 0.9,
          ),
        ),
        const SizedBox(height: 10),
        CarouselIndicator(
          controller: controller,
          itemCount: 5,
          style: IndicatorStyle.dot,
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildEnlargeCarousel() {
    return CycleCarousel(
      items: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: _colors[index],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Card ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
      options: const CarouselOptions(
        height: 250,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        autoPlay: true,
      ),
    );
  }

  Widget _buildControlledCarousel() {
    return Column(
      children: [
        CycleCarousel(
          controller: _controller,
          items: _colors.map((color) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Item ${_colors.indexOf(color) + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 200,
            autoPlay: false,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _controller.previousPage();
              },
              label: const Text('Previous'),
            ),
            const SizedBox(width: 10),
            Text(
              'Page: ${_currentPage + 1}/${_colors.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                _controller.nextPage();
              },
              label: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalCarousel() {
    final controller = InfiniteCycleCarouselController();

    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            child: CycleCarousel(
              controller: controller,
              items: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: _colors[index],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Item ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
              options: const CarouselOptions(
                height: 300,
                scrollDirection: Axis.vertical,
                autoPlay: true,
                viewportFraction: 0.5,
              ),
            ),
          ),
          CarouselIndicator(
            controller: controller,
            itemCount: 5,
            style: IndicatorStyle.line,
            position: IndicatorPosition.right,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _build3DCarousel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: InfiniteCycleCarousel3D(
        itemCount: _colors.length,
        height: 400,
        itemWidth: 350,
        radius: 500,
        perspective: 0.003,
        enableGlassEffect: true,
        glassBlur: 15,
        glassOpacity: 0.25,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_colors[index], _colors[index].withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Card ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
        onPageChanged: (index) {
          // Handle page change
        },
      ),
    );
  }

  Widget _buildViewPagerCarousel() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey.shade100, Colors.grey.shade300],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: InfiniteCycleViewPager(
        itemCount: _colors.length,
        carouselHeight: 280,
        config: const InfiniteCycleConfig(
          viewportFraction: 0.85,
          centerItemScale: 1.0,
          sideItemScale: 0.8,
          sideItemOpacity: 0.6,
          overlapFactor: -0.3,
          elevationFactor: 25,
          autoScroll: true,
          autoScrollInterval: Duration(seconds: 4),
          animationDuration: Duration(milliseconds: 500),
          animationCurve: Curves.easeOutCubic,
          cardHeightRatio: 0.9,
          enableSnapping: true,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_colors[index], _colors[index].withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Offer ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        onItemChanged: (index) {
          // Handle item change
        },
        onItemTap: (index) {
          // Handle item tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tapped Offer ${index + 1}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStackedCardCarousel() {
    final cards = [
      {
        'name': 'Card 1',
        'color1': Color(0xFF7C3AED),
        'color2': Color(0xFF9333EA),
      },
      {
        'name': 'Card 2',
        'color1': Color(0xFFEC4899),
        'color2': Color(0xFFF43F5E),
      },
      {
        'name': 'Card 3',
        'color1': Color(0xFF14B8A6),
        'color2': Color(0xFF06B6D4),
      },
      {
        'name': 'Card 4',
        'color1': Color(0xFFF59E0B),
        'color2': Color(0xFFEF4444),
      },
      {
        'name': 'Card 5',
        'color1': Color(0xFF8B5CF6),
        'color2': Color(0xFFEC4899),
      },
    ];

    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: CircularCarousel(
        cards: cards.map((card) {
          return Container(
            width: 280,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [card['color1'] as Color, card['color2'] as Color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                card['name'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
        radius: 120,
      ),
    );
  }

  Widget _buildStackedCarousel() {
    final cards = [
      {
        'color1': const Color(0xFF6B46C1),
        'color2': const Color(0xFF9333EA),
        'title': 'Card 1',
      },
      {
        'color1': const Color(0xFF059669),
        'color2': const Color(0xFF10B981),
        'title': 'Card 2',
      },
      {
        'color1': const Color(0xFFDC2626),
        'color2': const Color(0xFFEF4444),
        'title': 'Card 3',
      },
      {
        'color1': const Color(0xFF0891B2),
        'color2': const Color(0xFF06B6D4),
        'title': 'Card 4',
      },
      {
        'color1': const Color(0xFFEA580C),
        'color2': const Color(0xFFF97316),
        'title': 'Card 5',
      },
    ];

    return StackedCarousel(
      itemCount: cards.length,
      height: 180,
      // viewportFraction: 0.9,
      itemBuilder: (context, index) {
        final card = cards[index];

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [card['color1'] as Color, card['color2'] as Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              card['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}