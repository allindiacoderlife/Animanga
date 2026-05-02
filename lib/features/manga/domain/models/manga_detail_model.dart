class MangaDetailModel {
  final int malId;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final List<String> titleSynonyms;
  final String type;
  final String imageUrl;
  final double? score;
  final int? scoredBy;
  final int? rank;
  final int? popularity;
  final int? favorites;
  final String? status;
  final bool publishing;
  final int? chapters;
  final int? volumes;
  final String? synopsis;
  final String? background;
  final String? source;
  final List<AuthorModel> authors;
  final List<GenreModel> genres;
  final List<GenreModel> themes;
  final List<GenreModel> demographics;
  final List<RelationModel> relations;
  final List<ExternalLinkModel> externalLinks;
  final PublishedModel? published;

  MangaDetailModel({
    required this.malId,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    required this.titleSynonyms,
    required this.type,
    required this.imageUrl,
    this.score,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.favorites,
    this.status,
    required this.publishing,
    this.chapters,
    this.volumes,
    this.synopsis,
    this.background,
    this.source,
    required this.authors,
    required this.genres,
    required this.themes,
    required this.demographics,
    required this.relations,
    required this.externalLinks,
    this.published,
  });

  factory MangaDetailModel.fromJson(Map<String, dynamic> json) {
    return MangaDetailModel(
      malId: json['mal_id'],
      title: json['title'] ?? 'Unknown',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      titleSynonyms: (json['title_synonyms'] as List?)?.cast<String>() ?? [],
      type: json['type'] ?? 'Manga',
      imageUrl: json['images']?['webp']?['large_image_url'] ??
                json['images']?['jpg']?['large_image_url'] ?? '',
      score: (json['score'] as num?)?.toDouble(),
      scoredBy: json['scored_by'],
      rank: json['rank'],
      popularity: json['popularity'],
      favorites: json['favorites'],
      status: json['status'],
      publishing: json['publishing'] ?? false,
      chapters: json['chapters'],
      volumes: json['volumes'],
      synopsis: json['synopsis'],
      background: json['background'],
      source: json['source'],
      authors: (json['authors'] as List?)
              ?.map((item) => AuthorModel.fromJson(item))
              .toList() ?? [],
      genres: (json['genres'] as List?)
              ?.map((item) => GenreModel.fromJson(item))
              .toList() ?? [],
      themes: (json['themes'] as List?)
              ?.map((item) => GenreModel.fromJson(item))
              .toList() ?? [],
      demographics: (json['demographics'] as List?)
              ?.map((item) => GenreModel.fromJson(item))
              .toList() ?? [],
      relations: (json['relations'] as List?)
              ?.map((item) => RelationModel.fromJson(item))
              .toList() ?? [],
      externalLinks: (json['external'] as List?)
              ?.map((item) => ExternalLinkModel.fromJson(item))
              .toList() ?? [],
      published: json['published'] != null ? PublishedModel.fromJson(json['published']) : null,
    );
  }
}

class AuthorModel {
  final int malId;
  final String name;
  final String type;
  final String url;

  AuthorModel({
    required this.malId,
    required this.name,
    required this.type,
    required this.url,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      malId: json['mal_id'],
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class GenreModel {
  final int malId;
  final String name;
  final String type;
  final String url;

  GenreModel({
    required this.malId,
    required this.name,
    required this.type,
    required this.url,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      malId: json['mal_id'],
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class RelationModel {
  final String relation;
  final List<RelationEntryModel> entries;

  RelationModel({
    required this.relation,
    required this.entries,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    return RelationModel(
      relation: json['relation'] ?? '',
      entries: (json['entry'] as List?)
              ?.map((item) => RelationEntryModel.fromJson(item))
              .toList() ?? [],
    );
  }
}

class RelationEntryModel {
  final int malId;
  final String type;
  final String name;
  final String url;

  RelationEntryModel({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  factory RelationEntryModel.fromJson(Map<String, dynamic> json) {
    return RelationEntryModel(
      malId: json['mal_id'],
      type: json['type'] ?? '',
      name: json['name'] ?? 'Unknown',
      url: json['url'] ?? '',
    );
  }
}

class ExternalLinkModel {
  final String name;
  final String url;

  ExternalLinkModel({
    required this.name,
    required this.url,
  });

  factory ExternalLinkModel.fromJson(Map<String, dynamic> json) {
    return ExternalLinkModel(
      name: json['name'] ?? 'Link',
      url: json['url'] ?? '',
    );
  }
}

class PublishedModel {
  final String? from;
  final String? to;
  final String? string;

  PublishedModel({
    this.from,
    this.to,
    this.string,
  });

  factory PublishedModel.fromJson(Map<String, dynamic> json) {
    return PublishedModel(
      from: json['from'],
      to: json['to'],
      string: json['string'],
    );
  }
}
