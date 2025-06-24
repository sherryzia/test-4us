// lib/model/auth/session_model.dart

import 'package:restaurant_finder/model/user_model.dart';

class SessionModel {
  final String? sessionId;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final DateTime? expiresAt;

  SessionModel({
    this.sessionId,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.expiresAt,
  });

  // Convert model to JSON for storage

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  // Create model from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['session_id'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  }

  // Check if session is still valid
  bool get isValid {
    if (expiresAt == null || accessToken == null) return false;
    return DateTime.now().isBefore(expiresAt!);
  }
}
