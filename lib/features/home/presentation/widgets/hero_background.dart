import 'package:flutter/material.dart';

class HeroBackground extends StatelessWidget {
  final String? bannerUrl;
  final int heroIndex;

  const HeroBackground({
    super.key,
    required this.bannerUrl,
    required this.heroIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Container(
          key: ValueKey<int>(heroIndex),
          decoration: BoxDecoration(
            image: bannerUrl != null
                ? DecorationImage(
                    image: NetworkImage(bannerUrl!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.5),
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF151517).withValues(alpha: 0.8),
                  const Color(0xFF151517),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
