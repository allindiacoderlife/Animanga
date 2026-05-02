class MangaCharacterModel {
  final int malId;
  final String name;
  final String imageUrl;
  final String role;

  MangaCharacterModel({
    required this.malId,
    required this.name,
    required this.imageUrl,
    required this.role,
  });

  factory MangaCharacterModel.fromJson(Map<String, dynamic> json) {
    final character = json['character'];
    return MangaCharacterModel(
      malId: character['mal_id'],
      name: character['name'],
      imageUrl: character['images']['webp']['image_url'] ?? 
                character['images']['jpg']['image_url'],
      role: json['role'] ?? 'Supporting',
    );
  }
}
