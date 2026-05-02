import 'package:animanga/features/home/widget/manga_grid_card.dart';
import 'package:animanga/features/manga/data/repositories/manga_repository.dart';
import 'package:animanga/features/manga/domain/models/manga_model.dart';
import 'package:flutter/material.dart';
import 'package:animanga/features/home/widget/manga_card.dart';

class MangaList extends StatefulWidget {
  final String title;
  final List<MangaModel>? initialManga;

  const MangaList({
    super.key,
    this.title = 'Trending Manga',
    this.initialManga,
  });

  @override
  State<MangaList> createState() => _MangaListState();
}

class _MangaListState extends State<MangaList>
    with SingleTickerProviderStateMixin {
  bool _isGridView = false;
  final MangaRepository _repository = MangaRepository();
  List<MangaModel> _mangaList = [];
  bool _isLoading = true;

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

    if (widget.initialManga != null) {
      _mangaList = widget.initialManga!;
      _isLoading = false;
      _entranceController.forward();
    } else {
      _fetchManga();
    }
  }

  Future<void> _fetchManga() async {
    try {
      final list = await _repository.searchManga(
        orderBy: 'popularity',
        limit: 50,
      );
      if (mounted) {
        setState(() {
          _mangaList = list;
          _isLoading = false;
        });
        _entranceController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

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
                  Text(
                    '${widget.title} (${_mangaList.length})',
                    style: const TextStyle(
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFECA4F5),
                      ),
                    )
                  : _isGridView
                  ? _buildGridView()
                  : _buildListView(),
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
      itemCount: _mangaList.length,
      itemBuilder: (context, index) {
        final manga = _mangaList[index];
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
                title: manga.title,
                chapters: manga.chapters?.toString() ?? '?',
                score: manga.score?.toString() ?? 'N/A',
                coverUrl: manga.imageUrl,
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
      itemCount: _mangaList.length,
      itemBuilder: (context, index) {
        final manga = _mangaList[index];
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
                      transform: Matrix4.diagonal3Values(scale, scale, 1.0)
                        ..setTranslationRaw(0.0, yOffset, 0.0),
                      alignment: Alignment
                          .bottomCenter, // Anchor scale to bottom so it shrinks away from the top
                      child: child,
                    ),
                  );
                },
                child: MangaCard(
                  title: manga.title,
                  chapters: manga.chapters?.toString() ?? '?',
                  score: manga.score?.toString() ?? 'N/A',
                  coverUrl: manga.imageUrl,
                  bannerUrl: manga.imageUrl,
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
