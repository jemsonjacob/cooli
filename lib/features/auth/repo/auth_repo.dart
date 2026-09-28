import 'package:cooli/features/auth/model/auth_model.dart';

class AuthRepo {
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserModel(
      id: 'usr_1001',
      fullName: 'John Doe',
      email: 'johndoe@example.com',
      phoneNumber: phoneNumber.isEmpty ? '+91 98765 43210' : phoneNumber,
    );
  }

  Future<UserModel> register({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserModel(
      id: 'usr_1002',
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  Future<bool> sendOtp({
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return otp.isNotEmpty;
  }
}
