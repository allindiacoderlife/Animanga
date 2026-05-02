import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animanga/features/manga/data/repositories/manga_repository.dart';
import 'package:animanga/features/manga/domain/models/manga_detail_model.dart';
import 'package:animanga/features/manga/domain/models/manga_character_model.dart';

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
  List<MangaCharacterModel> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final results = await Future.wait([
        _repository.getMangaFull(widget.mangaId),
        _repository.getMangaCharacters(widget.mangaId),
      ]);

      if (mounted) {
        setState(() {
          _mangaDetail = results[0] as MangaDetailModel?;
          _characters = results[1] as List<MangaCharacterModel>;
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
            ..._buildContentSlivers(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: const Color(0xFF151517),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
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
                if (_mangaDetail?.imageUrl != null ||
                    widget.initialImageUrl != null)
                  Image.network(
                    _mangaDetail?.imageUrl ?? widget.initialImageUrl!,
                    fit: BoxFit.cover,
                  ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withValues(alpha: 0.4)),
                ),
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
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Opacity(
                    opacity: opacity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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

  List<Widget> _buildContentSlivers() {
    if (_mangaDetail == null) return [];

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 16),
            SectionEntranceAnimation(
              child: SizedBox(
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
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_mangaDetail!.titleSynonyms.isNotEmpty)
              SectionEntranceAnimation(
                delayIndex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Synonyms',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _mangaDetail!.titleSynonyms.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) =>
                            _buildSmallChip(_mangaDetail!.titleSynonyms[index]),
                      ),
                    ),
                  ],
                ),
              ),

            SectionEntranceAnimation(
              delayIndex: 3,
              child: _buildRelationsSection('Adaptation'),
            ),

            SectionEntranceAnimation(
              delayIndex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SectionEntranceAnimation(
              delayIndex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Genres'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._mangaDetail!.genres.map(
                        (g) => _buildGenreChip(g.name),
                      ),
                      ..._mangaDetail!.themes.map(
                        (t) => _buildGenreChip(t.name),
                      ),
                      ..._mangaDetail!.demographics.map(
                        (d) => _buildGenreChip(d.name, isDemographic: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_mangaDetail!.externalLinks.isNotEmpty)
              SectionEntranceAnimation(
                delayIndex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('External Links'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _mangaDetail!.externalLinks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) =>
                            _buildExternalLinkButton(
                              _mangaDetail!.externalLinks[index],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ]),
        ),
      ),

      if (_characters.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Characters'),
                const SizedBox(height: 16),
                AnimatedHorizontalList(
                  height: 180,
                  itemCount: _characters.length.clamp(0, 20),
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedCard(
                      _buildHorizontalCharacterCard(_characters[index]),
                      animation,
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

      if (_mangaDetail!.authors.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Staff'),
                const SizedBox(height: 16),
                AnimatedHorizontalList(
                  height: 160,
                  itemCount: _mangaDetail!.authors.length,
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedCard(
                      _buildAuthorCard(_mangaDetail!.authors[index]),
                      animation,
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isVertical = false,
  }) {
    if (isVertical) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Row(
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
        if (onSeeAll != null)
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
            onPressed: onSeeAll,
          ),
      ],
    );
  }

  Widget _buildRelationsSection(String type) {
    final adaptation = _mangaDetail!.relations.firstWhere(
      (r) => r.relation == type,
      orElse: () => RelationModel(relation: '', entries: []),
    );

    if (adaptation.entries.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          'Mean Score',
          '${_mangaDetail!.score ?? 'N/A'} / 10',
          valueColor: const Color(0xFFECA4F5),
        ),
        _buildInfoRow('Status', _mangaDetail!.status?.toUpperCase() ?? 'N/A'),
        _buildInfoRow('Total Chapters', '${_mangaDetail!.chapters ?? '??'}'),
        _buildInfoRow('Format', _mangaDetail!.type.toUpperCase()),
        _buildInfoRow('Source', _mangaDetail!.source?.toUpperCase() ?? 'N/A'),
        _buildInfoRow('Popularity', '#${_mangaDetail!.popularity ?? 'N/A'}'),
        _buildInfoRow('Favourites', '${_mangaDetail!.favorites ?? 'N/A'}'),
        _buildInfoRow('Name Romaji', _mangaDetail!.title),
        if (_mangaDetail!.titleJapanese != null)
          _buildInfoRow('Name', _mangaDetail!.titleJapanese!),
        _buildSectionTitle('Anime Adaptation'),
        const SizedBox(height: 8),
        ...adaptation.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              entry.name,
              style: const TextStyle(color: Color(0xFFECA4F5), fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSmallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildGenreChip(String label, {bool isDemographic = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDemographic
            ? const Color(0xFFECA4F5).withValues(alpha: 0.1)
            : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(10),
        border: isDemographic
            ? Border.all(color: const Color(0xFFECA4F5).withValues(alpha: 0.3))
            : null,
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isDemographic ? const Color(0xFFECA4F5) : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExternalLinkButton(ExternalLinkModel link) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          link.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildHorizontalCharacterCard(MangaCharacterModel character) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                character.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            character.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            character.role,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorCard(AuthorModel author) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF222222),
            child: Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            author.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            author.type,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AnimatedHorizontalList extends StatefulWidget {
  final double height;
  final int itemCount;
  final Widget Function(BuildContext, int, Animation<double>) itemBuilder;

  const AnimatedHorizontalList({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<AnimatedHorizontalList> createState() => _AnimatedHorizontalListState();
}

class _AnimatedHorizontalListState extends State<AnimatedHorizontalList>
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
      height: widget.height,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.itemCount,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index * 0.1).clamp(0.0, 1.0),
              (index * 0.1 + 0.5).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          );
          return AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double scale = 1.0;
              if (_scrollController.hasClients) {
                // Estimate item width = card width + separator (12)
                final double itemWidth = widget.height * 0.6 + 12;
                final itemPosition = index * itemWidth;
                final scrollOffset = _scrollController.offset;
                final viewportWidth =
                    _scrollController.position.viewportDimension;

                final distanceToCenter =
                    (itemPosition + itemWidth / 2) -
                    (scrollOffset + viewportWidth / 2);
                final normalizedDistance =
                    (distanceToCenter / (viewportWidth / 2)).abs();

                scale = (1.0 - (normalizedDistance * 0.1)).clamp(0.9, 1.0);
              }
              return Transform.scale(scale: scale, child: child);
            },
            child: widget.itemBuilder(context, index, animation),
          );
        },
      ),
    );
  }
}

class SectionEntranceAnimation extends StatelessWidget {
  final Widget child;
  final int delayIndex;

  const SectionEntranceAnimation({
    super.key,
    required this.child,
    this.delayIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (delayIndex * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
