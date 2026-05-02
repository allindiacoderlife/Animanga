import 'package:flutter/material.dart';

class MangaGridCard extends StatelessWidget {
  final String title;
  final String chapters;
  final String score;
  final String coverUrl;
  final bool showStatusDot;
  final VoidCallback? onTap;
  final int malId;
  final String? heroTag;

  const MangaGridCard({
    super.key,
    required this.title,
    required this.chapters,
    required this.score,
    required this.coverUrl,
    required this.malId,
    this.heroTag,
    this.showStatusDot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Header
        Expanded(
          child: Stack(
            children: [
              // Cover Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: heroTag ?? 'manga_cover_$malId',
                    child: Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[800]),
                    ),
                  ),
                ),
              ),
              // Status Indicator
              if (showStatusDot)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF53E074),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              // Score Badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFECA4F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        score,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: Colors.black, size: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Text Info
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '~ | $chapters',
          style: const TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    );
  }
}
