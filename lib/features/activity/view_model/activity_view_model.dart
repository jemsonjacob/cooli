import 'package:cooli/features/activity/model/activity_model.dart';
import 'package:cooli/features/activity/repo/activity_repo.dart';
import 'package:cooli/providers/view_model.dart';

class ActivityViewModel extends ViewModel {
  final ActivityRepo _repo;

  ActivityViewModel({ActivityRepo? repo}) : _repo = repo ?? ActivityRepo() {
    loadActivities();
  }

  List<ActivityModel> _activities = [];
  List<ActivityModel> get activities => _activities;

  ActivityType? _selectedFilter;
  ActivityType? get selectedFilter => _selectedFilter;

  void loadActivities() {
    _activities = _repo.getAllActivities();
    notifyListeners();
  }

  void setFilter(ActivityType? filter) {
    _selectedFilter = filter;
    if (filter == null) {
      _activities = _repo.getAllActivities();
    } else {
      _activities = _repo.getAllActivities().where((a) => a.type == filter).toList();
    }
    notifyListeners();
  }
}
