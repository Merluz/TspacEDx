class TalkTag {
  final String slug;
  final String speakers;
  final String title;
  final String url;
  final String description;
  final String duration;
  final String publishedAt;
  final String imageUrl;
  final List<String> tags;

  TalkTag({
    required this.slug,
    required this.speakers,
    required this.title,
    required this.url,
    required this.description,
    required this.duration,
    required this.publishedAt,
    required this.imageUrl,
    required this.tags,
  });

  factory TalkTag.fromJson(Map<String, dynamic> json) {
    return TalkTag(
      slug: json['slug'] ?? '',
      speakers: json['speakers'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      imageUrl: json['image_url'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
