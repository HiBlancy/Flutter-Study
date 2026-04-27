
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final String? profileImage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
    this.profileImage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      birthDate: json['birthDate'] != null
        ? DateTime.parse(json['birthDate'])
        : null,
      profileImage: json['profileImage'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (birthDate != null) 'birthDate': birthDate,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}