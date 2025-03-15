class UserModel {
  final String email;
  final String password;
  final String name;
  final String id;
  final String userType;

  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.id,
    required this.userType,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'id': id,
      'userType': userType,
    };
  }

  // Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      id: json['id'],
      userType: json['userType'],
    );
  }
}
