// To parse this JSON data, do
//
//     final categoryUsers = categoryUsersFromJson(jsonString);

import 'dart:convert';

CategoryUsers categoryUsersFromJson(String str) => CategoryUsers.fromJson(json.decode(str));

String categoryUsersToJson(CategoryUsers data) => json.encode(data.toJson());

class CategoryUsers {
    CategoryUsers({
        this.city,
        this.country,
        this.email,
        this.firstName,
        this.lastName,
        this.online,
        this.state,
        this.userId,
    });

    String? city;
    String? country;
    String? email;
    String? firstName;
    String? lastName;
    String? online;
    String? state;
    String? userId;

    factory CategoryUsers.fromJson(Map<String, dynamic> json) => CategoryUsers(
        city: json["city"],
        country: json["country"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        online: json["online"],
        state: json["state"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "online": online,
        "state": state,
        "userId": userId,
    };
}

