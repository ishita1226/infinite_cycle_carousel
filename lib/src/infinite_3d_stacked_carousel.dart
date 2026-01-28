// import 'package:flutter/material.dart';

// class Infinite3DStackedCarousel extends StatefulWidget {
//   final int itemCount;
//   final IndexedWidgetBuilder itemBuilder;
//   final double height;
//   final double viewportFraction;

//   const Infinite3DStackedCarousel({
//     super.key,
//     required this.itemCount,
//     required this.itemBuilder,
//     this.height = 200,
//     this.viewportFraction = 0.94, // 🔥 wider to show glimpses
//   });

//   @override
//   State<Infinite3DStackedCarousel> createState() =>
//       _Infinite3DStackedCarouselState();
// }

// class _Infinite3DStackedCarouselState
//     extends State<Infinite3DStackedCarousel> {
//   late final PageController _controller;
//   final int _initialPage = 10000;

//   @override
//   void initState() {
//     super.initState();
//     _controller = PageController(
//       viewportFraction: widget.viewportFraction,
//       initialPage: _initialPage,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.height,
//       child: PageView.builder(
//         controller: _controller,
//         physics: const BouncingScrollPhysics(),
//         itemBuilder: (context, index) {
//           return AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               double page = _initialPage.toDouble();
//               if (_controller.position.haveDimensions) {
//                 page = _controller.page ?? page;
//               }

//               final double relative = index - page;
//               final double abs = relative.abs();

//               // ---------- STRONGER 3D ----------
//               final double translateX = relative * 90; // 👈 glimpse control
//               final double rotateY = -relative * 0.55; // 👈 tilt
//               final double scale =
//                   (1 - abs * 0.2).clamp(0.78, 1.0);

//               final Matrix4 transform = Matrix4.identity()
//                 ..setEntry(3, 2, 0.0018) // 👈 perspective (KEY)
//                 ..translate(translateX, 0.0, -abs * 30) // 👈 depth
//                 ..rotateY(rotateY)
//                 ..scale(scale);

//               final double opacity =
//                   (1 - abs * 0.45).clamp(0.35, 1.0);

//               final double elevation =
//                   (1 - abs).clamp(0.0, 1.0);

//               return Transform(
//                 alignment: Alignment.center,
//                 transform: transform,
//                 child: Opacity(
//                   opacity: opacity,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black
//                               .withOpacity(0.4 * elevation),
//                           blurRadius: 35 * elevation,
//                           offset: Offset(0, 22 * elevation),
//                         ),
//                       ],
//                     ),
//                     child: child,
//                   ),
//                 ),
//               );
//             },
//             child: widget.itemBuilder(
//               context,
//               index % widget.itemCount,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

class StackedCarousel extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double height;

  const StackedCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14), // 🔑 LEFT + RIGHT
        child: PageView.builder(
          controller: PageController(
            viewportFraction: 0.88,
          ),
          padEnds: false,
          physics: const BouncingScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: itemBuilder(context, index),
            );
          },
        ),
      ),
    );
  }
}
