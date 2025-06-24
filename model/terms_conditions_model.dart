// lib/model/terms_conditions_model.dart

class TermsConditionsModel {
  final String id;
  final String title;
  final String content; // HTML content
  final String version;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TermsConditionsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.version,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      version: json['version'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'version': version,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}