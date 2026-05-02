import 'package:animanga/features/manga/data/repositories/manga_repository.dart';
import 'package:animanga/features/manga/domain/models/manga_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MangaRepository _repository = MangaRepository();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<MangaModel> _results = [];
  bool _isLoading = false;
  String _selectedType = 'manga';
  String _selectedStatus = 'publishing';

  final List<String> _types = [
    "manga",
    "novel",
    "lightnovel",
    "oneshot",
    "doujin",
    "manhwa",
    "manhua",
  ];
  final List<String> _statuses = [
    "publishing",
    "complete",
    "hiatus",
    "discontinued",
    "upcoming",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _repository.searchManga(
        query: query,
        type: _selectedType,
        status: _selectedStatus,
      );
      if (mounted) {
        setState(() {
          _results = results;
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
      backgroundColor: const Color(0xFF0F0F11),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search Manga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildSearchInput(),
          _buildFilters(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFECA4F5)),
                  )
                : _results.isEmpty
                ? _buildEmptyState()
                : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search for manga...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Color(0xFFECA4F5)),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('Type', _selectedType, _types, (val) {
            setState(() => _selectedType = val);
            if (_searchController.text.isNotEmpty)
              _performSearch(_searchController.text);
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Status', _selectedStatus, _statuses, (val) {
            setState(() => _selectedStatus = val);
            if (_searchController.text.isNotEmpty)
              _performSearch(_searchController.text);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String current,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map(
            (opt) => PopupMenuItem(value: opt, child: Text(opt.toUpperCase())),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFECA4F5).withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              '$label: ${current.toUpperCase()}',
              style: const TextStyle(color: Color(0xFFECA4F5), fontSize: 12),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFFECA4F5)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'Type something to search'
                : 'No results found',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final manga = _results[index];
        return _buildMangaCard(manga);
      },
    );
  }

  Widget _buildMangaCard(MangaModel manga) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E22),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(15),
            ),
            child: Image.network(
              manga.imageUrl,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    manga.genres.join(', '),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        manga.score?.toString() ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        manga.status?.toUpperCase() ?? '',
                        style: const TextStyle(
                          color: Color(0xFFECA4F5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
