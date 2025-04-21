class Address {
  const Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  final String street, city, state, zip, country;

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }
}
