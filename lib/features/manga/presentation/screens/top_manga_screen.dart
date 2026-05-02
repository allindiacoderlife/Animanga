import 'package:animanga/features/manga/data/repositories/manga_repository.dart';
import 'package:animanga/features/manga/domain/models/manga_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class TopMangaScreen extends StatefulWidget {
  const TopMangaScreen({super.key});

  @override
  State<TopMangaScreen> createState() => _TopMangaScreenState();
}

class _TopMangaScreenState extends State<TopMangaScreen> {
  final MangaRepository _repository = MangaRepository();
  List<MangaModel>? _mangaList;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchManga();
  }

  Future<void> _fetchManga() async {
    try {
      final list = await _repository.getTopManga();
      if (mounted) {
        setState(() {
          _mangaList = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFECA4F5),
                ),
              ),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final manga = _mangaList![index];
                    return _buildMangaItem(manga, index);
                  },
                  childCount: _mangaList!.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: const Text(
          'Top Manga',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFECA4F5),
                    Color(0xFF0F0F11),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMangaItem(MangaModel manga, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E22),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'manga_${manga.malId}',
                  child: Image.network(
                    manga.imageUrl,
                    width: 110,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECA4F5).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#${manga.rank ?? index + 1}',
                                style: const TextStyle(
                                  color: Color(0xFFECA4F5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${manga.score ?? "N/A"}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                        const SizedBox(height: 4),
                        Text(
                          manga.genres.join(' • '),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              manga.chapters != null
                                  ? '${manga.chapters} Chapters'
                                  : 'Ongoing',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFECA4F5).withValues(alpha: 0.5),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Detail',
                                style: TextStyle(
                                  color: Color(0xFFECA4F5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
