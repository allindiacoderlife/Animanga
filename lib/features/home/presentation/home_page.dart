import 'dart:async';
import 'package:animanga/core/constants/asset_path.dart';
import 'package:animanga/features/home/presentation/widgets/category_card.dart';
import 'package:animanga/features/home/presentation/widgets/hero_background.dart';
import 'package:animanga/features/home/presentation/widgets/home_hero_carousel.dart';
import 'package:animanga/features/home/presentation/widgets/home_search_bar.dart';
import 'package:animanga/features/home/presentation/widgets/manga_sections.dart';
import 'package:animanga/features/home/widget/manga_card.dart';
import 'package:animanga/features/manga/data/repositories/manga_repository.dart';
import 'package:animanga/features/manga/domain/models/manga_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:animanga/config/router/app_routes.dart';

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
  final MangaRepository _mangaRepository = MangaRepository();
  List<MangaModel>? _topMangaList;
  List<MangaModel>? _trendingManga;
  List<MangaModel>? _trendingManhwa;
  List<MangaModel>? _trendingNovel;
  List<MangaModel>? _topRatedManga;
  List<MangaModel>? _mostFavouriteManga;
  bool _isHeroLoading = true;
  bool _isSectionsLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);

    _mainScrollController = ScrollController();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fetchTopManga();
    _fetchSections();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final listLength = (_topMangaList?.length ?? dummyManga.length);
        if (listLength == 0) return;
        final nextPage = (_currentHeroIndex + 1) % listLength;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchTopManga() async {
    try {
      final list = await _mangaRepository.getTopManga();
      if (mounted) {
        setState(() {
          _topMangaList = list;
          _isHeroLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isHeroLoading = false;
        });
      }
    }
  }

  Future<void> _fetchSections() async {
    try {
      final results = await Future.wait([
        _mangaRepository.searchManga(
          type: 'manga',
          orderBy: 'popularity',
          limit: 20,
        ),
        _mangaRepository.searchManga(
          type: 'manhwa',
          orderBy: 'popularity',
          limit: 20,
        ),
        _mangaRepository.searchManga(
          type: 'novel',
          orderBy: 'popularity',
          limit: 20,
        ),
        _mangaRepository.searchManga(orderBy: 'score', limit: 20),
        _mangaRepository.searchManga(orderBy: 'popularity', limit: 20),
      ]);

      if (mounted) {
        setState(() {
          _trendingManga = results[0];
          _trendingManhwa = results[1];
          _trendingNovel = results[2];
          _topRatedManga = results[3];
          _mostFavouriteManga = results[4];
          _isSectionsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSectionsLoading = false;
        });
      }
    }
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
    setState(() {
      _isHeroLoading = true;
      _isSectionsLoading = true;
    });

    await Future.wait([_fetchTopManga(), _fetchSections()]);

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
                    child: _isHeroLoading
                        ? Container(height: 450, color: Colors.grey[900])
                        : HeroBackground(
                            heroIndex: _currentHeroIndex,
                            bannerUrl:
                                _topMangaList != null &&
                                    _topMangaList!.isNotEmpty
                                ? _topMangaList![_currentHeroIndex %
                                          _topMangaList!.length]
                                      .imageUrl
                                : null,
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
                        child: _isHeroLoading
                            ? const SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : HomeHeroCarousel(
                                controller: _pageController,
                                mangaList: _topMangaList ?? [],
                                onPageChanged: (index) =>
                                    setState(() => _currentHeroIndex = index),
                                cardBuilder: (manga) => _buildHeroCardFromModel(
                                  manga as MangaModel,
                                ),
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
                                  onTap: () {
                                    // Handle genres navigation if needed
                                  },
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
                                  onTap: () => context.push(
                                    AppRoutes.mangaList,
                                    extra: {
                                      'title': 'Top Score',
                                      'initialManga': _topMangaList,
                                    },
                                  ),
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
                child: _buildDynamicSection('Trending Manga', _trendingManga),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.4,
                end: 0.8,
                child: _buildDynamicSection('Trending Manhwa', _trendingManhwa),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.5,
                end: 0.9,
                child: _buildDynamicSection('Trending Novel', _trendingNovel),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.6,
                end: 1.0,
                child: _buildDynamicSection('Top rated', _topRatedManga),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.7,
                end: 1.0,
                child: _buildDynamicSection(
                  'Most Favourite',
                  _mostFavouriteManga,
                ),
              ),
            ),

            // Popular Manga List
            SliverToBoxAdapter(
              child: _buildAnimatedContent(
                start: 0.8,
                end: 1.0,
                child: SectionTitle(
                  title: 'Popular Manga',
                  onTap: () => context.push(
                    AppRoutes.mangaList,
                    extra: {
                      'title': 'Popular Manga',
                      'initialManga': _topMangaList,
                    },
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (_topMangaList == null || _topMangaList!.isEmpty) {
                  return const SizedBox();
                }
                final manga = _topMangaList![index % _topMangaList!.length];
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
                            isScrolling =
                                _mainScrollController
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
                              final finalScale =
                                  1.0 + (scale - 1.0) * intensity;
                              final finalOpacity =
                                  1.0 + (opacity - 1.0) * intensity;
                              final finalYOffset = yOffset * intensity;

                              return Opacity(
                                opacity: finalOpacity,
                                child: Transform(
                                  transform: Matrix4.diagonal3Values(
                                    finalScale,
                                    finalScale,
                                    1.0,
                                  )..setTranslationRaw(0.0, finalYOffset, 0.0),
                                  alignment: Alignment.center,
                                  child: child,
                                ),
                              );
                            },
                            child: child,
                          );
                        },
                        child: MangaCard(
                          title: manga.title,
                          chapters: manga.chapters?.toString() ?? '?',
                          score: manga.score?.toString() ?? 'N/A',
                          coverUrl: manga.imageUrl,
                          bannerUrl: manga.imageUrl,
                          showStatusDot: index >= 2,
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: _topMangaList?.length ?? 0),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSection(String title, List<MangaModel>? list) {
    return Column(
      key: ValueKey('section_${title}_$_refreshCount'),
      children: [
        SectionTitle(
          title: title,
          onTap: () => context.push(
            AppRoutes.mangaList,
            extra: {'title': title, 'initialManga': list},
          ),
        ),
        _isSectionsLoading
            ? const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            : HorizontalMangaList(mangaList: list ?? []),
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

  Widget _buildHeroCardFromModel(MangaModel manga) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              manga.imageUrl,
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
                _buildScoreBadge(manga.score?.toString() ?? 'N/A'),
                const SizedBox(height: 8),
                Text(
                  manga.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  manga.status ?? 'UNKNOWN',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                _buildHeroFooterFromModel(manga),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroFooterFromModel(MangaModel manga) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${manga.chapters ?? "?"} Chapters',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Expanded(
          child: Text(
            manga.genres.join(' • '),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
}
