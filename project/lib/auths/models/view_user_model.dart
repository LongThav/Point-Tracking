// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    this.code,
    this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final Data data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };

  @override
  List<Object?> get props => [code, message, data];
}

class Data extends Equatable {
  const Data({
    required this.access_token,
    this.tokenType,
    this.expiresIn,
    this.user,
    required this.role,
  });

  final String access_token;
  final String? tokenType;
  final int? expiresIn;
  final User? user;
  final String role;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        access_token: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        user: User.fromJson(json["user"]),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": access_token,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "user": user != null ? user!.toJson() : null,
        "role": role,
      };

  @override
  List<Object?> get props => [access_token, tokenType, expiresIn, user, role];
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.avatar,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.text,
    this.avatarUrl,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? avatar;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? text;
  String? avatarUrl;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        avatar: json["avatar"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        text: json["text"],
        avatarUrl: json["avatar_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "avatar": avatar,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "text": text,
        "avatar_url": avatarUrl,
      };
}
