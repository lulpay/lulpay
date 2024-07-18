import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/services/http/api_end_points.dart';
import '../../common/services/http/kabbee_http.dart';
import '../models/registration_model.dart';
import '../../common/models/simple_message.dart';
import '../models/user_preference_model.dart';
import '../../common/services/db_access.dart';

class AuthServices {
  /// User service for account authentication
  /// using email and password
  static Future<Map<String, dynamic>> loginWithEmailPassword(
      Map<String, dynamic> authBody) async {
    var result = await KabbeeHttp.authPost(
      body: jsonEncode(authBody),
    );

    // save fcmTokens used for sending notifications from firebase functions
    FirebaseFirestore.instance
        .collection('fcm_tokens')
        .doc(DbAccess.deviceToken(returnDefault: true).toString())
        .set({});

    return result;
  }

  static Future<Map<String, dynamic>> loginWithOAuth(String idToken) async =>
      await KabbeeHttp.authPost(oauthIdToken: idToken);

  static Future resetPassword(String? email) async => await KabbeeHttp.post(
        ApiEndPoint.forgetPassword,
        jsonEncode(
          {'email': '$email'},
        ),
        shouldSendToken: false,
        parseErrIfAny: false,
      );

//change password using user id and password
  static Future reset(String uid, String token, String? password) async {
    Map data = {'id': uid, 'token': token, 'password': '$password'};
    String body = jsonEncode(data);

    await KabbeeHttp.post(
      ApiEndPoint.resetPassword,
      body,
      shouldSendToken: false,
    );
  }

  /// User service for account registration
  static Future createUserAccount(RegistrationModel registrationModel) async {
    String endPoint = 'user';

    String body = registrationModelToJson(registrationModel);

    await KabbeeHttp.post(
      endPoint,
      body,
      shouldSendToken: false,
    );
  }

  Future changePassword(String? oldPassword, String? newPassword) async {
    String endPoint = 'user/changePassword';
    Map data = {
      'currentPassword': '$oldPassword',
      'newPassword': '$newPassword'
    };
    String body = jsonEncode(data);

    await KabbeeHttp.put(endPoint, body: body);
  }

  static Future<UserPereferenceDetail?> setPreference({
    String? language,
    String? theme,
  }) async {
    Map data = {};

    if (language != null) data.addAll({'language': language});
    if (theme != null) data.addAll({'theme': theme});

    String body = jsonEncode(data);

    var response = await KabbeeHttp.put(ApiEndPoint.userPrefence, body: body);

    return userPereferenceModelFromJson(response).detail;
  }

  static Future<UserPereferenceDetail?> getPreference(String token) async {
    String endPoint = 'user/preference';

    var response = await KabbeeHttp.get(endPoint);

    return userPereferenceModelFromJson(response).detail;
  }

  static Future logout() async {
    String endPoint = 'auth/logout';
    Map<String, String> header = {
      'x-auth-token': DbAccess.token,
      'x-refresh-token': DbAccess.refreshToken,
      'x-device-id': DbAccess.deviceToken(returnDefault: true)!,
    };

    await KabbeeHttp.put(endPoint, headers: header);
  }

  static Future<String> checkEmail(String email) async {
    var response = await KabbeeHttp.get(
      ApiEndPoint.checkEmail + email,
      shouldSendToken: false,
    );

    return simpleMessageFromJson(response).detail;
  }
}
