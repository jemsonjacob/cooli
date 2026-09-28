import 'package:cooli/features/services/model/service_model.dart';
import 'package:cooli/features/services/repo/services_repo.dart';
import 'package:cooli/providers/view_model.dart';

class ServicesViewModel extends ViewModel {
  final ServicesRepo _repo;

  ServicesViewModel({ServicesRepo? repo}) : _repo = repo ?? ServicesRepo() {
    loadServices();
  }

  List<ServiceSubCategory> _categories = [];
  List<ServiceSubCategory> get categories => _categories;

  List<HomeServiceModel> _services = [];
  List<HomeServiceModel> get services => _services;

  HomeServiceModel? _selectedService;
  HomeServiceModel? get selectedService => _selectedService;

  String _selectedDate = '12 Apr 2025';
  String get selectedDate => _selectedDate;

  String _selectedTime = '10:00 AM - 11:00 AM';
  String get selectedTime => _selectedTime;

  String _address = 'Home - Kochi, Kerala';
  String get address => _address;

  void loadServices() {
    _categories = _repo.getSubCategories();
    _services = _repo.getHomeServices();
    if (_services.isNotEmpty) {
      _selectedService = _services.first;
    }
    notifyListeners();
  }

  void selectService(HomeServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  void setDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
}
