import 'dart:convert';

import '../../common/models/accounts_model.dart';

String registrationModelToJson(RegistrationModel data) =>
    json.encode(data.toJson());

class RegistrationModel {
  RegistrationModel({
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.gender,
    this.address,
    this.login,
    this.userPreference,
    this.referredBy,
  });

  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  String? gender;
  Address? address;
  LoginCredential? login;
  UserPreference? userPreference;
  String? referredBy;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        if (middleName != null) 'middleName': middleName,
        'lastName': lastName,
        if (dob != null) 'dob': dob,
        'gender': gender,
        'address': address!.toJson(),
        'login': login!.toJson(),
        'userPreference': userPreference!.toJson(),
        if (referredBy != null) 'referredBy': referredBy,
      };
}

class LoginCredential {
  LoginCredential({
    this.email,
    this.password,
  });

  String? email;
  String? password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class UserPreference {
  UserPreference({
    this.language,
    this.theme,
  });

  String? language;
  String? theme;

  Map<String, dynamic> toJson() => {
        if (language != null) 'language': language,
        if (theme != null) 'theme': theme,
      };
}
