import 'package:cooli/features/onboarding/model/onboarding_model.dart';
import 'package:cooli/features/onboarding/repo/onboarding_repo.dart';
import 'package:cooli/providers/view_model.dart';

class OnboardingViewModel extends ViewModel {
  final OnboardingRepo _repo;

  OnboardingViewModel({OnboardingRepo? repo}) : _repo = repo ?? OnboardingRepo() {
    _items = _repo.getOnboardingItems();
  }

  late List<OnboardingItem> _items;
  List<OnboardingItem> get items => _items;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
