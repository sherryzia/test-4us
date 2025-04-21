class Comments {
  const Comments({
    required this.id,
    required this.targetId,
    this.parentId,
    required this.content,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });
  final int id;
  final targetId, parentId;
  final String content, user;
  final DateTime createdAt, updatedAt;

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      targetId: json['targetId'],
      content: json['content'],
      user: json['user'],
      createdAt: DateTime.parse(json['createdAt'] ?? ""),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ""),
    );
  }
}
