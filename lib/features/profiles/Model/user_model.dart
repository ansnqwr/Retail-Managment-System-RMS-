class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String governorate;
  final String city;
  final String? access_token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,

    required this.governorate,
    required this.city,
    this.access_token,
  });

  factory UserModel.guest() {
    return UserModel(
      id: 'guest',
      firstName: 'Guest',
      lastName: 'User',
      email: '',
      phone: '',
      governorate: '',
      city: '',
      access_token: null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      access_token: json['access_token'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'governorate': governorate,
      'city': city,
      'access_token': access_token,
    };
  }
}
