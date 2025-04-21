class Post {
  const Post({
    required this.slug,
    required this.title,
    required this.description,
    // required this.content,
    required this.image,
    required this.author,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  final String slug, title, description;
  // final String content;
  final String? image;
  final String author;
  final int id;
  final DateTime createdAt, updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'slug': slug,
      'title': title,
      'description': description,
      // 'content': content,
      'image': image,
      'author': author,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      // content: json['content'],
      image: json['image'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt'] ?? ""),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ""),
    );
  }
}
