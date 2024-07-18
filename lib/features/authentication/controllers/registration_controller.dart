import 'dart:async';

import 'package:get/get.dart';

import '../../common/models/accounts_model.dart';
import '../models/registration_model.dart';
import '../services/auth_service.dart';
import '../../common/services/db_access.dart';

class RegistrationController extends GetxController {
  final RxBool isProcessing = false.obs;
  final RxBool nextButtonEnabled = false.obs;
  final RxBool enableRegisterButton = false.obs;
  final RxBool hidePassword = true.obs;

  String serverMessage = '';

  // initializing our main field entries
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;
  RxInt genderIndex = 0.obs;
  String? dob;
  String? country;

  Future<bool> registerUser() async {
    isProcessing.value = true;

    final RegistrationModel userModel = RegistrationModel(
      login: LoginCredential(
        email: email,
        password: password,
      ),
      firstName: firstName!.capitalize!.trim(),
      lastName: lastName!.capitalize!.trim(),
      gender: genderIndex.value.isEqual(0) ? 'MALE' : 'FEMALE',
      address: Address(country: country),
      userPreference: UserPreference(
        language: DbAccess.readData('lang', defaultValue: 'English'),
      ),
      referredBy: DbAccess.readData('referralId'),
    );

    try {
      await AuthServices.createUserAccount(userModel);
      clearRegistrationData();

      return true;
    } catch (e) {
      serverMessage = e.toString();
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> checkEmail() async {
    isProcessing.value = true;

    try {
      String response = await AuthServices.checkEmail(email!);

      return response == 'true';
    } catch (e) {
      serverMessage = e.toString();
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  ///  Sets first name
  void setFirstName(String value) => firstName = value;

  ///  Sets last name
  void setLastName(String value) => lastName = value;

  /// Sets email field
  void setEmail(String value) => email = value.trim().toLowerCase();

  /// Sets password field
  void setPassword(String value) => password = value;

  /// Sets password confirmation field
  void setConfirmPassword(String value) => confirmPassword = value;

  /// Sets date of birth
  void setDoB(String selectedDoB) => dob = selectedDoB;

  /// Sets gender
  void setGender(int num) => genderIndex.value = num;

  /// Sets country
  void setCountry(String c) => country = c;

  void clearRegistrationData() {
    firstName =
        lastName = email = password = confirmPassword = country = dob = null;

    genderIndex.value = 0;
  }
}
