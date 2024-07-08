class Talk {
  final String id;
  final String slug;
  final String speakers;
  final String title;
  final String url;
  final String description;
  final String duration;
  final String publishedAt;
  final String imageUrl;
  final List<String> tags;

  Talk({
    required this.id,
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

  factory Talk.fromJson(Map<String, dynamic> json) {
    return Talk(
      id: json['_id'],
      slug: json['slug'],
      speakers: json['speakers'],
      title: json['title'],
      url: json['url'],
      description: json['description'],
      duration: json['duration'],
      publishedAt: json['publishedAt'],
      imageUrl: json['image_url'],
      tags: List<String>.from(json['tags']),
    );
  }
}
