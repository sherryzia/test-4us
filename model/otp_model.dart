// lib/model/otp_model.dart

class OtpModel {
  final String? id;
  final String email;
  final String otp;
  final bool isVerified;
  final DateTime? createdAt;

  OtpModel({
    this.id,
    required this.email,
    required this.otp,
    this.isVerified = false,
    this.createdAt,
  });

  // Convert model to JSON for sending to the API
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'is_verified': isVerified,
    };
  }

  // Convert JSON from API to model
  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      id: json['id'],
      email: json['email'],
      otp: json['otp'],
      isVerified: json['is_verified'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}