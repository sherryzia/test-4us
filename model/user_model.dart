// lib/model/user_model.dart

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  // Convert model to JSON for sending to the API
  // Convert model to JSON for sending to the API
Map<String, dynamic> toJson() {
  Map<String, dynamic> json = {
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
  };
  
  // Include ID if it exists
  if (id != null) {
    json['id'] = id;
  }
  
  return json;
}

  // Convert JSON from API to model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Copy with function for immutability
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
