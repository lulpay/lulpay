import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/utility/debug_log.dart';
import '../../common/services/global_service.dart';

import '../../../routing/router.gr.dart';
import '../../common/controllers/global_controller.dart';
import '../../common/services/http/exception_handler.dart';
import '../../common/models/user_profile_model.dart';
import '../../common/widgets/kabbee_snackbars.dart';
import '../services/auth_service.dart';
import '../../common/services/db_access.dart';

typedef UserEmail = String;
typedef NumberOfTries = int;
typedef AuthSuccess = bool;

class LoginController extends GetxController {
  GlobalKey<FormState>? formKey;

  RxBool isRemember = false.obs;

  String? email;
  String? password;

  RxBool isAuthenticating = false.obs;
  RxBool enableLoginButton = false.obs;
  bool shouldValidateGlobally = false;

  String? serverMessage;
  RxBool lockAccount = false.obs;
  int? lockDuration;

  final Map<UserEmail, NumberOfTries> wrongCredentials = {};

  @override
  void onInit() async {
    await rememberMe();
    super.onInit();
  }

  GlobalKey<FormState> get loginFormKey => formKey ??= GlobalKey<FormState>();

  Future<Map<AuthSuccess, NumberOfTries>> loginWithEmailPassword() async {
    isAuthenticating(true);

    try {
      var authResult = await AuthServices.loginWithEmailPassword(
        {
          'email': email!,
          'password': password!,
        },
      );

      DbAccess.userDB
        ..put('email', email)
        ..put('user_password', password);

      saveUserData(authResult);

      enableLoginButton(false);

      if (isRemember.isFalse) email = null;
      loginFormKey.currentState?.reset();
      formKey = null;
      return {true: 0};
    } catch (e, s) {
      safeLog(e.toString());
      safeLog(s.toString());
      kabbeeSnackBar(
        e.toString(),
        isSuccessMsg: false,
      );

      if (e is KabbeeException && (e.statusCode?.contains('452') ?? false)) {
        lockAccountTemporarily();
      }

      if (e.toString() == 'err_code_108') {
        wrongCredentials['$email'] = (wrongCredentials['$email'] ?? 0) + 1;
      }

      return {false: wrongCredentials['$email'] ?? 0};
    } finally {
      isAuthenticating(false);
    }
  }

  Future<bool> loginViaOAuth(User user) async {
    try {
      formKey = null;

      var userNames = (user.displayName ?? '').split(' ');
      var firstName = userNames.first;
      String? lastName;

      if (userNames.length > 1) {
        lastName = '';
        for (int i = 1; i < userNames.length; i++) {
          lastName = '${lastName!} ${userNames.elementAt(i)}';
        }
      }

      lastName ??= '';

      var authResult = await AuthServices.loginWithEmailPassword(
        {
          'provider': 'google',
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'email': user.email,
        },
      );

      DbAccess.writeData('email', user.email ?? '');

      saveUserData(authResult);

      // await GlobalService.refreshToken();

      return true;
    } catch (e, s) {
      safeLog('$e \n $s');
      var error = e.toString();

      // if (error.contains('err_code_1101')) {
      // error = 'err_code_500';
      FirebaseAuth.instance.signOut().onError((_, __) => null);
      GoogleSignIn().signOut().onError((_, __) => null);

      // }

      kabbeeSnackBar(
        error,
        isSuccessMsg: false,
      );
      return false;
    }
  }

  void saveUserData(Map<String, dynamic> data) {
    UserProfile userProfile = data['profile'];

    DbAccess.userDB
      ..put('token', data['token'])
      ..put('refresh-token', data['refresh-token'])
      ..put('userId', userProfile.id)
      ..put('firstName', userProfile.firstName)
      ..put('middleName', userProfile.middleName ?? '')
      ..put('lastName', userProfile.lastName)
      ..put('chatUserName',
          '${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}'.trim())
      ..put('gender', userProfile.gender)
      ..put('profilePic', userProfile.profilePic)
      ..put('dob', userProfile.dob)
      ..put('country', userProfile.address?.country ?? '')
      ..put('userEnabled', userProfile.isPublicUserEnabled)
      ..put('ccEnabled', userProfile.isContentCreatorEnabled)
      ..put('subscriptionId',
          userProfile.currentSubscription?.subscriptionId ?? '')
      ..put(
          'subscriptionType', userProfile.currentSubscription?.subscriptionType)
      ..put('acceptTerms', userProfile.agent?.acceptTerms)
      ..put('isKidsEULAAccepted', userProfile.isKidsEULAAccepted)
      ..put('follows', userProfile.follows ?? [])
      ..delete('referralId');

    // set user roles from token extraction
    GlobalService.updateUserInfoFromToken();

    if (userProfile.userPreference?.theme != null) {
      DbAccess.userDB.put(
        'isDarkMode',
        userProfile.userPreference!.theme!.toLowerCase().contains('dark'),
      );
    }

    if (userProfile.userPreference?.language != null) {
      DbAccess.userDB.put('lang', userProfile.userPreference!.language!.trim());
    }

    Get.find<GlobalController>().isAuthed = true;
  }

  Future rememberMe() async {
    isRemember(DbAccess.readData('rememberMe', defaultValue: false));

    if (isRemember.isTrue) email = DbAccess.readData('email');
  }

  void setEmail(String value) {
    email = value.trim().toLowerCase();
    if (shouldValidateGlobally) {
      enableLoginButton(loginFormKey.currentState!.validate());
    }
  }

  void setPassword(String value) {
    password = value.toString();
    enableLoginButton(loginFormKey.currentState!.validate());
    shouldValidateGlobally = true;
  }

  void setRememberMe(bool? value) =>
      DbAccess.writeData('rememberMe', isRemember(value));

  void lockAccountTemporarily() {
    // helps in preventing user from logging in until lock duration is over

    // holds lock expirey date time if available. Otherwise it gets assigned past time
    // to help us in calculating difference with now
    String lockExpiresAt =
        DbAccess.readData('lockExpiresAt', defaultValue: '2021-01-01');

    // checks if lock expirey date time is greater than now
    bool didLockTimeExpire = DateTime.parse(lockExpiresAt)
            .difference(DateTime.now())
            .inMilliseconds <=
        0;

    // locked email, if available
    String lockedAccount = DbAccess.readData('lockedAccount', defaultValue: '');

    // if lock time haven't expired, and locked account is same as log in email,
    // resume timer from the remained lock duration.
    // otherwise start the lock time as new, 15 minutes
    if (!didLockTimeExpire && lockedAccount == email) {
      lockDuration =
          DateTime.parse(lockExpiresAt).difference(DateTime.now()).inSeconds;
    } else {
      DbAccess.userDB.put('lockedAccount', email);

      DbAccess.userDB.put('lockExpiresAt',
          DateTime.now().add(const Duration(minutes: 15)).toString());
    }
    lockAccount(true);
  }

  void goToChatPage(BuildContext context) {
    if (DbAccess.readData('chatUserName')?.toString().isEmpty ?? true) {
      context.navigateTo(ChatUserIdentificationRoute());
      return;
    }
    context.navigateTo(
      ChatRoute(
        userId: '',
        peerId: 'gyaNbVfwPOWn0idZ8v1hHxrN2Kd2',
        peerUserName: 'Customer Service',
      ),
    );
  }
}
