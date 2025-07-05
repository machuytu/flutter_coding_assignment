class ImageEntity {
  final String id;
  final String url;
  final String title;
  final String description;

  const ImageEntity({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageEntity &&
        other.id == id &&
        other.url == url &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ url.hashCode ^ title.hashCode ^ description.hashCode;
  }

  @override
  String toString() {
    return 'ImageEntity(id: $id, url: $url, title: $title, description: $description)';
  }
}
