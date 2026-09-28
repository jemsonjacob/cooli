class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profilePhoto;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profilePhoto,
  });
}
