import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? role;
  GeoPoint? location;

  UserModel({
    this.name,
    this.email,
    this.role,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        email: json['email'],
        role: json['role'],
        location: json['location'],
      );

  factory UserModel.fromDocument(DocumentSnapshot doc) => UserModel(
        email: doc['email'],
        name: doc['name'],
        role: doc['role'],
        location: doc['location'],
      );

  Map<String, dynamic> toJson() => ({
        "name": name,
        "email": email,
        "role": role,
        "location": location,
      });
}
