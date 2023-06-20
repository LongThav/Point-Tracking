import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
        required this.code,
        required this.message,
        required this.data,
    });

    int code;
    String message;
    Data data;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.accessToken,
        required this.tokenType,
        required this.expiresIn,
        required this.user,
        required this.role,
    });

    String accessToken;
    String tokenType;
    int expiresIn;
    User user;
    String role;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        user: User.fromJson(json["user"]),
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "user": user.toJson(),
        "role": role,
    };
}

class User {
    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        this.emailVerifiedAt,
        this.avatar,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.text,
        required this.avatarUrl,
    });

    int id;
    String name;
    String email;
    String phone;
    dynamic emailVerifiedAt;
    dynamic avatar;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    String text;
    String avatarUrl;

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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "text": text,
        "avatar_url": avatarUrl,
    };
}
