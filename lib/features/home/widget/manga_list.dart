import 'package:animanga/core/constants/asset_path.dart';
import 'package:animanga/features/home/widget/manga_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:animanga/features/home/widget/manga_card.dart';

class MangaList extends StatefulWidget {
  const MangaList({super.key});

  @override
  State<MangaList> createState() => _MangaListState();
}

class _MangaListState extends State<MangaList>
    with SingleTickerProviderStateMixin {
  // Add this state variable to track the view mode
  bool _isGridView = false;

  // 1. Add a ScrollController
  late final ScrollController _scrollController;

  // 2. Add an AnimationController for entrance animation
  late AnimationController _entranceController;

  // Define the exact height of your item to calculate positions accurately
  // 150 (Container height) + 16 (Bottom margin) = 166
  final double _itemHeight = 166.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> dummyManga = [
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
    {
      'title': 'Chainsaw Man',
      'chapters': '232',
      'score': '8.5',
      'coverUrl': AssetPath.coverOne,
      'bannerUrl': AssetPath.bannerOne,
    },
    {
      'title': 'Jujutsu Kaisen',
      'chapters': '272',
      'score': '8.0',
      'coverUrl': AssetPath.coverTwo,
      'bannerUrl': AssetPath.bannerTwo,
    },
    {
      'title': 'ONE PIECE',
      'chapters': '??',
      'score': '9.2',
      'coverUrl': AssetPath.coverThree,
      'bannerUrl': AssetPath.bannerThree,
    },
    {
      'title': 'Spy x Family',
      'chapters': '??',
      'score': '9.1',
      'coverUrl': AssetPath.coverFour,
      'bannerUrl': AssetPath.bannerFour,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151517),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Manga (50)',
                    style: TextStyle(
                      color: Color(0xFFECA4F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // List View Button
                      IconButton(
                        onPressed: () {
                          if (_isGridView) {
                            setState(() {
                              _isGridView = false;
                            });
                            _entranceController.reset();
                            _entranceController.forward();
                          }
                        },
                        icon: Icon(
                          Icons.format_list_bulleted,
                          color: !_isGridView
                              ? Colors.white
                              : const Color(0xFF555555),
                          size: 28,
                        ),
                      ),
                      // Grid View Button
                      IconButton(
                        onPressed: () {
                          if (!_isGridView) {
                            setState(() {
                              _isGridView = true;
                            });
                            _entranceController.reset();
                            _entranceController.forward();
                          }
                        },
                        icon: Icon(
                          Icons.grid_view_rounded,
                          color: _isGridView
                              ? Colors.white
                              : const Color(0xFF555555),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              // Switch between Grid and List based on state
              child: _isGridView ? _buildGridView() : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  //! --- The New Grid View Builder ---
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        crossAxisSpacing: 12.0, // Horizontal space between cards
        mainAxisSpacing: 16.0, // Vertical space between rows
        childAspectRatio: 0.52, // Tweak this to adjust the height of the cards
      ),
      itemCount: dummyManga.length,
      itemBuilder: (context, index) {
        final manga = dummyManga[index];
        final showStatusDot = index >= 2;

        final animation = CurvedAnimation(
          parent: _entranceController,
          curve: Interval(
            (index * 0.05).clamp(0.0, 1.0),
            (index * 0.05 + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: MangaGridCard(
                title: manga['title']!,
                chapters: manga['chapters']!,
                score: manga['score']!,
                coverUrl: manga['coverUrl']!,
                showStatusDot: showStatusDot,
              ),
            ),
          ),
        );
      },
    );
  }

  //! --- Your Existing List View Builder ---
  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: dummyManga.length,
      itemBuilder: (context, index) {
        final manga = dummyManga[index];
        final showStatusDot = index >= 2;

        final animation = CurvedAnimation(
          parent: _entranceController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            (index * 0.1 + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  double scale = 1.0;
                  double opacity = 1.0;
                  double yOffset = 0.0;

                  if (_scrollController.hasClients) {
                    double offset = _scrollController.offset;
                    double itemPosition = index * _itemHeight;
                    double difference = offset - itemPosition;

                    // If the item is scrolling up past the top of the viewport
                    if (difference > 0) {
                      // Scale down slightly (shrinks up to 80% of original size)
                      scale = 1.0 - (difference / 400).clamp(0.0, 0.2);
                      // Fade out smoothly
                      opacity = 1.0 - (difference / 250).clamp(0.0, 1.0);
                      // Parallax translate: pushes the item down slightly so it looks stacked
                      yOffset = difference * 0.5;
                    }
                  }

                  return Opacity(
                    opacity: opacity,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setTranslationRaw(0.0, yOffset, 0.0)
                        ..scale(scale, scale, 1.0),
                      alignment: Alignment
                          .bottomCenter, // Anchor scale to bottom so it shrinks away from the top
                      child: child,
                    ),
                  );
                },
                child: MangaCard(
                  title: manga['title']!,
                  chapters: manga['chapters']!,
                  score: manga['score']!,
                  coverUrl: manga['coverUrl']!,
                  bannerUrl: manga['bannerUrl']!,
                  showStatusDot: showStatusDot,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
