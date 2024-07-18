import 'dart:convert';

UserPereferenceModel userPereferenceModelFromJson(String str) =>
    UserPereferenceModel.fromJson(json.decode(str));


class UserPereferenceModel {
  UserPereferenceModel({
    this.message,
    this.detail,
  });

  String? message;
  UserPereferenceDetail? detail;

  factory UserPereferenceModel.fromJson(Map<String, dynamic> json) =>
      UserPereferenceModel(
        message: json['message'],
        detail: json['detail'] == null
            ? null
            : UserPereferenceDetail.fromJson(json['detail']),
      );


}

class UserPereferenceDetail {
  UserPereferenceDetail({
    this.id,
    this.language,
    this.theme,
  });

  String? id;
  String? language;
  String? theme;

  factory UserPereferenceDetail.fromJson(Map<String, dynamic> json) =>
      UserPereferenceDetail(
        id: json['_id'],
        language: json['language'],
        theme: json['theme'],
      );


}
