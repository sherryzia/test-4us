// lib/model/profile_model.dart
class ProfileModel {
  final String id;
  final String name;
  final String profileImage;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// lib/model/restaurant_model.dart
class RestaurantModel {
  final String id;
  final String name;
  final String location;
  final String image;
  final double rating;
  final bool isFavorite;
  final bool isRecommended;
  final bool isTrending;
  final DateTime createdAt;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    this.isFavorite = false,
    this.isRecommended = false,
    this.isTrending = false,
    required this.createdAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      isFavorite: json['is_favorite'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      isTrending: json['is_trending'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'image': image,
      'rating': rating,
      'is_favorite': isFavorite,
      'is_recommended': isRecommended,
      'is_trending': isTrending,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// lib/model/user_favorite_model.dart
class UserFavoriteModel {
  final String id;
  final String userId;
  final String restaurantId;
  final DateTime createdAt;

  UserFavoriteModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.createdAt,
  });

  factory UserFavoriteModel.fromJson(Map<String, dynamic> json) {
    return UserFavoriteModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
