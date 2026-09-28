import 'package:cooli/features/splash/model/splash_model.dart';
import 'package:cooli/features/splash/repo/splash_repo.dart';
import 'package:cooli/providers/view_model.dart';

class SplashViewModel extends ViewModel {
  final SplashRepo _repo;

  SplashViewModel({SplashRepo? repo}) : _repo = repo ?? SplashRepo();

  SplashData? _data;
  SplashData? get data => _data;

  Future<void> initSplash() async {
    isLoading = true;
    try {
      _data = await _repo.getSplashData();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
