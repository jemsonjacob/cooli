import 'package:cooli/features/auth/model/auth_model.dart';

class ProfileRepo {
  UserModel getUserProfile() {
    return const UserModel(
      id: 'usr_1001',
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+91 98765 43210',
    );
  }
}
