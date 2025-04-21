import 'package:ecomanga/models/models.dart';

class BillingAddress {
  const BillingAddress({
    required this.address,
    required this.user,
    required this.id,
    required this.createdAt,
    required this.updateAt,
  });

  final Address address;
  final User user;
  final String id;
  final DateTime createdAt, updateAt;

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'user': user.toJson(),
      'id': id,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    return BillingAddress(
      address: json['address'],
      user: json['user'],
      id: json['id'],
      createdAt: json['createdAt'],
      updateAt: json['updateAt'],
    );
  }
}
