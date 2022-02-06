// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.firstName,
        this.lastName,
        this.email,
        this.userId,
        this.state,
        this.country,
        this.category,
    });

    String? firstName;
    String? lastName;
    String? email;
    String? userId;
    String? state;
    String? country;
    List? category;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        userId: json["userId"],
        state: json["state"],
        country: json["country"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "userId": userId,
        "state": state,
        "country": country,
        "category": category,
    };
}
