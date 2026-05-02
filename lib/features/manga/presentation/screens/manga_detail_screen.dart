import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animanga/features/manga/data/repositories/manga_repository.dart';
import 'package:animanga/features/manga/domain/models/manga_detail_model.dart';

class MangaDetailScreen extends StatefulWidget {
  final int mangaId;
  final String? heroTag;
  final String? initialTitle;
  final String? initialImageUrl;

  const MangaDetailScreen({
    super.key,
    required this.mangaId,
    this.heroTag,
    this.initialTitle,
    this.initialImageUrl,
  });

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  final MangaRepository _repository = MangaRepository();
  MangaDetailModel? _mangaDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await _repository.getMangaFull(widget.mangaId);
      if (mounted) {
        setState(() {
          _mangaDetail = detail;
          _isLoading = false;
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151517),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          if (_isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFECA4F5)),
              ),
            )
          else if (_mangaDetail == null)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Failed to load manga details',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          else
            SliverToBoxAdapter(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: _buildBottomTabs(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: const Color(0xFF151517),
      elevation: 0,
      automaticallyImplyLeading: false, // Hide default back button
      actions: [
        // Circular translucent close button
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 4),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          // Calculate collapse percentage (0.0 expanded to 1.0 collapsed)
          // Toolbar height is ~56. expandedHeight is 380.
          final collapseProgress = ((380 - top) / (380 - kToolbarHeight)).clamp(
            0.0,
            1.0,
          );
          final opacity = (1.0 - (collapseProgress * 1.5)).clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            centerTitle: true,
            title: Opacity(
              opacity: collapseProgress > 0.8
                  ? (collapseProgress - 0.8) * 5
                  : 0.0,
              child: Text(
                _mangaDetail?.title ?? widget.initialTitle ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background Image (Blurred)
                if (_mangaDetail?.imageUrl != null ||
                    widget.initialImageUrl != null)
                  Image.network(
                    _mangaDetail?.imageUrl ?? widget.initialImageUrl!,
                    fit: BoxFit.cover,
                  ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),

                // 2. Bottom Gradient to blend seamlessly into the scaffold background
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF151517)],
                      ),
                    ),
                  ),
                ),

                // 3. Cover Image and Title (Wrapped in Opacity)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Opacity(
                    opacity: opacity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Cover Image with slight shadow
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Hero(
                              tag:
                                  widget.heroTag ??
                                  'manga_cover_${widget.mangaId}',
                              child:
                                  (_mangaDetail?.imageUrl != null ||
                                      widget.initialImageUrl != null)
                                  ? Image.network(
                                      _mangaDetail?.imageUrl ??
                                          widget.initialImageUrl!,
                                      width: 120,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 120,
                                      height: 170,
                                      color: Colors.grey[900],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title and Status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _mangaDetail?.title ??
                                    widget.initialTitle ??
                                    'Loading...',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _mangaDetail?.status?.toUpperCase() ??
                                    'UNKNOWN',
                                style: const TextStyle(
                                  color: Color(0xFFECA4F5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Add to List Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'ADD TO LIST',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Chapters Info & Share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total of ${_mangaDetail!.chapters ?? '??'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.share, color: Colors.white, size: 22),
            ],
          ),
          const SizedBox(height: 24),

          // Details List
          _buildDetailItem(
            'Mean Score',
            '${_mangaDetail!.score ?? 'N/A'} / 10',
            valueColor: const Color(0xFFECA4F5),
          ),
          _buildDetailItem(
            'Status',
            _mangaDetail!.status?.toUpperCase() ?? 'N/A',
          ),
          _buildDetailItem(
            'Total Chapters',
            '${_mangaDetail!.chapters ?? '??'}',
          ),
          _buildDetailItem('Format', _mangaDetail!.type.toUpperCase()),
          _buildDetailItem(
            'Source',
            _mangaDetail!.source?.toUpperCase() ?? 'N/A',
          ),
          _buildDetailItem(
            'Author',
            _mangaDetail!.authors.map((a) => a.name).join(', '),
            valueColor: const Color(0xFFECA4F5),
          ),
          _buildDetailItem(
            'Start Date',
            _mangaDetail!.published?.from?.split('T')[0] ?? 'N/A',
          ),
          _buildDetailItem(
            'End Date',
            _mangaDetail!.published?.to?.split('T')[0] ?? 'N/A',
          ),
          _buildDetailItem(
            'Popularity',
            '${_mangaDetail!.popularity ?? 'N/A'}',
          ),
          _buildDetailItem('Favourites', '${_mangaDetail!.favorites ?? 'N/A'}'),

          const SizedBox(height: 24),
          _buildDetailItem('Name Romaji', _mangaDetail!.title, vertical: true),
          _buildDetailItem(
            'Name',
            _mangaDetail!.titleJapanese ?? 'N/A',
            vertical: true,
          ),

          const SizedBox(height: 24),
          const Text(
            'Synopsis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _mangaDetail!.synopsis ?? 'No synopsis available.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),
          if (_mangaDetail!.genres.isNotEmpty) ...[
            const Text(
              'Genres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _mangaDetail!.genres
                  .map((genre) => _buildGenreChip(genre.name))
                  .toList(),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    Color? valueColor,
    bool vertical = false,
  }) {
    if (vertical) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF222222), // Slightly lighter than background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF151517),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem('INFO', Icons.info_outline, true),
          _buildTabItem('CHARACTERS', Icons.menu_book, false),
          _buildTabItem('STAFF', Icons.people_outline, false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, IconData icon, bool isActive) {
    final color = isActive ? const Color(0xFFECA4F5) : Colors.grey;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (isActive) ...[
            const Spacer(),
            Container(
              height: 2,
              width: double.infinity,
              color: const Color(0xFFECA4F5),
            ),
          ],
        ],
      ),
    );
  }
}
