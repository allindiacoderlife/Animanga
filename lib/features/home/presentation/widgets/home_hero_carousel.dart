import 'package:flutter/material.dart';

class HomeHeroCarousel extends StatelessWidget {
  final PageController controller;
  final List<Map<String, String>> mangaList;
  final Function(int) onPageChanged;
  final Widget Function(Map<String, String>) cardBuilder;

  const HomeHeroCarousel({
    super.key,
    required this.controller,
    required this.mangaList,
    required this.onPageChanged,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: controller,
        onPageChanged: onPageChanged,
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double value = 1.0;
              if (controller.position.haveDimensions) {
                value = controller.page! - index;
                value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
              } else {
                value = index == 0 ? 1.0 : 0.85;
              }

              return Transform.scale(scale: value, child: child);
            },
            child: cardBuilder(mangaList[index]),
          );
        },
      ),
    );
  }
}
