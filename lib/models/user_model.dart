import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      password: json["password"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "password": password,
    };
  }
}
