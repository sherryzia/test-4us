import 'package:ecomanga/models/models.dart';

class User {
  const User({
    required this.userId,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.picture,
    required this.role,
    required this.balance,
    required this.gender,
    this.dob,
    this.isBlockedUntil,
    this.emailVerifiedAt,
    this.phoneNoVerifiedAt,
    required this.joinedAt,
    this.updatedAt,
    required this.isVerified,
    this.shippingAddresses = const [],
    this.badges = const [],
    this.communities = const [],
    this.followers = const [],
    this.socialAccounts = const [],
    this.challenges = const [],
  });
  final String userId, email, username, firstName;
  final String lastName, phoneNo;
  final String? picture;
  final Role role;
  final int balance;
  final Gender? gender;
  final DateTime joinedAt;
  final DateTime? dob, isBlockedUntil, emailVerifiedAt;
  final DateTime? phoneNoVerifiedAt, updatedAt;
  final bool isVerified;
  final List shippingAddresses, badges, communities, followers;
  final List socialAccounts, challenges;

  String get fullName => "${firstName} ${lastName}";
  // String get age => DateTime.now().difference(dob);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNo': phoneNo,
      'picture': picture,
      'role': role,
      'balance': balance,
      'gender': gender,
      'dob': dob,
      'isBlockedUntil': isBlockedUntil,
      'emailVerifiedAt': emailVerifiedAt,
      'phoneNoVerifiedAt': phoneNoVerifiedAt,
      'joinedAt': joinedAt,
      'updatedAt': updatedAt,
      'isVerified': isVerified,
      'shippingAddresses': shippingAddresses,
      'badges': badges,
      'communities': communities,
      'followers': followers,
      'socialAccounts': socialAccounts,
      'challenges': challenges,
    };
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      userId: json['userId'],
      email: json['email'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNo: json['phoneNo'],
      picture: json['picture'],
      role: switch (json['role']) {
        'user' => Role.user,
        'admin' => Role.admin,
        _ => Role.guest,
      },
      balance: json['balance'],
      gender: switch (json['gender']) {
        'user' => Gender.male,
        'admin' => Gender.female,
        _ => null,
      },
      dob: DateTime.tryParse(json['dob'] ?? ""),
      isBlockedUntil: DateTime.tryParse(json['isBlockedUntil'] ?? ""),
      isVerified: json['isVerified'],
      emailVerifiedAt: DateTime.tryParse(json['emailVerifiedAt'] ?? ""),
      phoneNoVerifiedAt: DateTime.tryParse(json['phoneNoVerifiedAt'] ?? ""),
      joinedAt: DateTime.parse(json['joinedAt'] ?? ""),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ""),
      shippingAddresses: json['shippingAddresses'] ?? [],
      badges: json['badges'] ?? [],
      communities: json['communities'] ?? [],
      followers: json['followers'] ?? [],
      socialAccounts: json['socialAccounts'] ?? [],
      challenges: json['challenges'] ?? [],
    );
  }
}
