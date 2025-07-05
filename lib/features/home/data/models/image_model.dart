class ImageModel {
  final String id;
  final String url;
  final String title;
  final String description;

  ImageModel({
    required this.id,
    required this.url,
    this.title = '',
    this.description = '',
  });

  // Factory constructor for API response (simple string URL)
  factory ImageModel.fromUrl(String url, {int? index}) {
    return ImageModel(
      id: index?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      title: 'Image ${index ?? ''}',
      description: 'Beautiful image from Unsplash',
    );
  }

  // Factory constructor for JSON object (if API changes in future)
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'title': title, 'description': description};
  }
}
