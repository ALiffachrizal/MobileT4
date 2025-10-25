class News {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? sourceName;

  News({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.sourceName,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    title: json['title'] as String?,
    description: json['description'] as String?,
    url: json['url'] as String?,
    urlToImage: json['urlToImage'] as String?,
    sourceName: json['source']?['name'] as String?,
  );
}
