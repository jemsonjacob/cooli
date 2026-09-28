import 'package:cooli/features/auth/model/auth_model.dart';
import 'package:cooli/features/profile/repo/profile_repo.dart';
import 'package:cooli/providers/view_model.dart';

class ProfileViewModel extends ViewModel {
  final ProfileRepo _repo;

  ProfileViewModel({ProfileRepo? repo}) : _repo = repo ?? ProfileRepo() {
    loadUser();
  }

  UserModel? _user;
  UserModel? get user => _user;

  void loadUser() {
    _user = _repo.getUserProfile();
    notifyListeners();
  }
}
