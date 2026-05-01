import 'dart:async';
import 'package:animanga/core/constants/asset_path.dart';
import 'package:animanga/features/home/presentation/widgets/category_card.dart';
import 'package:animanga/features/home/presentation/widgets/hero_background.dart';
import 'package:animanga/features/home/presentation/widgets/home_hero_carousel.dart';
import 'package:animanga/features/home/presentation/widgets/home_search_bar.dart';
import 'package:animanga/features/home/presentation/widgets/manga_sections.dart';
import 'package:animanga/features/home/widget/manga_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final ScrollController _mainScrollController;
  int _currentHeroIndex = 0;
  int _refreshCount = 0;
  Timer? _autoScrollTimer;
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);

    _mainScrollController = ScrollController();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentHeroIndex + 1) % dummyManga.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _entranceController.dispose();
    _pageController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> dummyManga = [
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
      'genre': 'Action • Fantasy',
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
      'genre': 'Action • Supernatural',
    },
    {
      'title': 'ONE PIECE',
      'chapters': '1100+',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
      'genre': 'Action • Adventure',
    },
    {
      'title': 'Spy x Family',
      'chapters': '95',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
      'genre': 'Action • Comedy',
    },
  ];
  // Helper method to create the Slide + Fade effect with specific intervals
  Widget _buildAnimatedContent({
    required Widget child,
    required double start,
    required double end,
    Offset beginOffset = const Offset(
      0,
      0.2,
    ), // Default slides slightly up from bottom
  }) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Reset and restart animations for a fresh feel
    _entranceController.reset();
    _entranceController.forward();

    if (mounted) {
      setState(() {
        _refreshCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151517),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        backgroundColor: const Color(0xFF252527),
        color: const Color(0xFFECA4F5),
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Hero & Header Section
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  _buildAnimatedContent(
                    start: 0.0,
                    end: 0.5,
                    beginOffset: Offset.zero,
                    child: HeroBackground(
                      heroIndex: _currentHeroIndex,
                      bannerUrl:
                          dummyManga[_currentHeroIndex %
                              dummyManga.length]['bannerUrl'],
                    ),
                  ),
                  Column(
                    children: [
                      _buildAnimatedContent(
                        start: 0.0,
                        end: 0.5,
                        beginOffset: const Offset(0, -0.3),
                        child: const HomeSearchBar(),
                      ),
                      _buildAnimatedContent(
                        start: 0.1,
                        end: 0.6,
                        child: HomeHeroCarousel(
                          controller: _pageController,
                          mangaList: dummyManga,
                          onPageChanged: (index) =>
                              setState(() => _currentHeroIndex = index),
                          cardBuilder: (manga) => _buildHeroCard(manga),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedContent(
                                start: 0.2,
                                end: 0.7,
                                beginOffset: const Offset(-0.3, 0),
                                child: CategoryCard(
                                  title: 'GENRES',
                                  imageUrl: AssetPath.bannerTwo,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedContent(
                                start: 0.3,
                                end: 0.8,
                                beginOffset: const Offset(-0.3, 0),
                                child: CategoryCard(
                                  title: 'TOP SCORE',
                                  imageUrl: AssetPath.bannerThree,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trending Sections with staggered entrance
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.3,
                end: 0.7,
                child: _buildSection('Trending Manga'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.4,
                end: 0.8,
                child: _buildSection('Trending Manhwa'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.5,
                end: 0.9,
                child: _buildSection('Trending Novel'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.6,
                end: 1.0,
                child: _buildSection('Top rated'),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.7,
                end: 1.0,
                child: _buildSection('Most Favourite'),
              ),
            ),

            // Popular Manga List
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.8,
                end: 1.0,
                child: const SectionTitle(title: 'Popular Manga'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final manga = dummyManga[index % dummyManga.length];
                final animation = _getEntranceAnimation(index);

                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: AnimatedBuilder(
                        animation: _mainScrollController,
                        builder: (context, child) {
                          double scale = 1.0;
                          double opacity = 1.0;
                          double yOffset = 0.0;
                          bool isScrolling = false;

                          if (_mainScrollController.hasClients) {
                            isScrolling = _mainScrollController
                                    .position
                                    .userScrollDirection !=
                                ScrollDirection.idle;

                            if (isScrolling) {
                              const scrollOffsetBeforeList = 2000.0;
                              const itemHeight = 120.0;

                              final itemPosition =
                                  scrollOffsetBeforeList + (index * itemHeight);
                              final scrollOffset = _mainScrollController.offset;
                              final viewportHeight = _mainScrollController
                                  .position
                                  .viewportDimension;

                              final distanceToCenter =
                                  (itemPosition + itemHeight / 2) -
                                  (scrollOffset + viewportHeight / 2);
                              final normalizedDistance =
                                  (distanceToCenter / (viewportHeight / 2))
                                      .abs();

                              if (normalizedDistance > 0.6) {
                                final factor = (normalizedDistance - 0.6) / 0.4;
                                scale = 1.0 - (factor * 0.15).clamp(0.0, 0.15);
                                opacity = 1.0 - (factor * 0.5).clamp(0.0, 0.5);
                                yOffset = distanceToCenter > 0
                                    ? factor * 20
                                    : -factor * 20;
                              }
                            }
                          }

                          return TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            tween: Tween<double>(
                              begin: 0.0,
                              end: isScrolling ? 1.0 : 0.0,
                            ),
                            builder: (context, intensity, child) {
                              final finalScale = 1.0 + (scale - 1.0) * intensity;
                              final finalOpacity = 1.0 + (opacity - 1.0) * intensity;
                              final finalYOffset = yOffset * intensity;

                              return Opacity(
                                opacity: finalOpacity,
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..setTranslationRaw(0.0, finalYOffset, 0.0)
                                    ..scale(finalScale, finalScale, 1.0),
                                  alignment: Alignment.center,
                                  child: child,
                                ),
                              );
                            },
                            child: child,
                          );
                        },
                        child: MangaCard(
                          title: manga['title']!,
                          chapters: manga['chapters']!,
                          score: manga['score']!,
                          coverUrl: manga['coverUrl']!,
                          bannerUrl: manga['bannerUrl']!,
                          showStatusDot: index >= 2,
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: 10),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      key: ValueKey('section_${title}_$_refreshCount'),
      children: [
        SectionTitle(title: title),
        HorizontalMangaList(mangaList: dummyManga),
      ],
    );
  }

  CurvedAnimation _getEntranceAnimation(int index) {
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(
        (index * 0.05).clamp(0.0, 1.0),
        (index * 0.05 + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _buildHeroCard(Map<String, String> manga) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              manga['coverUrl']!,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(width: 120, height: 180, color: Colors.grey[800]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScoreBadge(manga['score']!),
                const SizedBox(height: 8),
                Text(
                  manga['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'RELEASING',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                _buildHeroFooter(manga),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(String score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECA4F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$score ★',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeroFooter(Map<String, String> manga) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${manga['chapters']} Chapters',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Expanded(
          child: Text(
            manga['genre']!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
