import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.grey,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalMangaList extends StatefulWidget {
  final List<Map<String, String>> mangaList;

  const HorizontalMangaList({super.key, required this.mangaList});

  @override
  State<HorizontalMangaList> createState() => _HorizontalMangaListState();
}

class _HorizontalMangaListState extends State<HorizontalMangaList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scrollController = ScrollController();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.mangaList.length,
        itemBuilder: (context, index) {
          final manga = widget.mangaList[index];
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index * 0.1).clamp(0.0, 1.0),
              (index * 0.1 + 0.5).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(animation),
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_scrollController.hasClients) {
                    // Item width (110) + margin (12)
                    const itemWidth = 122.0;
                    final itemPosition = index * itemWidth;
                    final scrollOffset = _scrollController.offset;
                    final viewportWidth =
                        _scrollController.position.viewportDimension;

                    // Calculate distance from center of viewport
                    final distanceToCenter =
                        (itemPosition + itemWidth / 2) -
                        (scrollOffset + viewportWidth / 2);
                    final normalizedDistance =
                        (distanceToCenter / (viewportWidth / 2)).abs();

                    // Pop effect: items in center are 1.0, items at edges scale down slightly
                    scale = (1.0 - (normalizedDistance * 0.1)).clamp(0.9, 1.0);
                  }

                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              manga['coverUrl']!,
                              height: 160,
                              width: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFECA4F5,
                                ).withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    manga['score']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        manga['title']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '• | ${manga['chapters']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
