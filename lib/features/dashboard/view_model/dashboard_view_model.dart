import 'package:cooli/features/dashboard/model/dashboard_model.dart';
import 'package:cooli/features/dashboard/repo/dashboard_repo.dart';
import 'package:cooli/providers/view_model.dart';

class DashboardViewModel extends ViewModel {
  final DashboardRepo _repo;

  DashboardViewModel({DashboardRepo? repo}) : _repo = repo ?? DashboardRepo() {
    loadDashboardData();
  }

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  List<ServiceCategory> _categories = [];
  List<ServiceCategory> get categories => _categories;

  List<RecentActivityItem> _recentActivities = [];
  List<RecentActivityItem> get recentActivities => _recentActivities;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void loadDashboardData() {
    _categories = _repo.getServiceCategories();
    _recentActivities = _repo.getRecentActivities();
    notifyListeners();
  }
}
