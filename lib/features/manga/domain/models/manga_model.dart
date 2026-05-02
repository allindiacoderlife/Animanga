class MangaModel {
  final int malId;
  final String title;
  final String imageUrl;
  final double? score;
  final int? rank;
  final String? status;
  final int? chapters;
  final String? synopsis;
  final List<String> genres;

  MangaModel({
    required this.malId,
    required this.title,
    required this.imageUrl,
    this.score,
    this.rank,
    this.status,
    this.chapters,
    this.synopsis,
    required this.genres,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      malId: json['mal_id'],
      title: json['title'] ?? 'Unknown',
      imageUrl: json['images']?['webp']?['large_image_url'] ?? 
                json['images']?['jpg']?['large_image_url'] ?? '',
      score: (json['score'] as num?)?.toDouble(),
      rank: json['rank'],
      status: json['status'],
      chapters: json['chapters'],
      synopsis: json['synopsis'],
      genres: (json['genres'] as List?)?.map((g) => g['name'] as String).toList() ?? [],
    );
  }
}
