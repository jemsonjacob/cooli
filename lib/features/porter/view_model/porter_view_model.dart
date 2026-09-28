import 'package:cooli/features/porter/model/porter_model.dart';
import 'package:cooli/features/porter/repo/porter_repo.dart';
import 'package:cooli/providers/view_model.dart';

class PorterViewModel extends ViewModel {
  final PorterRepo _repo;

  PorterViewModel({PorterRepo? repo}) : _repo = repo ?? PorterRepo() {
    loadVehicles();
  }

  List<PorterVehicleType> _vehicles = [];
  List<PorterVehicleType> get vehicles => _vehicles;

  PorterVehicleType? _selectedVehicle;
  PorterVehicleType? get selectedVehicle => _selectedVehicle;

  String _pickup = 'Select pickup address';
  String get pickup => _pickup;

  String _drop = 'Select drop address';
  String get drop => _drop;

  String _itemDetails = 'Furniture, appliances etc.';
  String get itemDetails => _itemDetails;

  String _dateTime = 'Today, 11:00 AM';
  String get dateTime => _dateTime;

  PorterBookingModel? _currentBooking;
  PorterBookingModel? get currentBooking => _currentBooking;

  void loadVehicles() {
    _vehicles = _repo.getVehicleTypes();
    if (_vehicles.length > 1) {
      _selectedVehicle = _vehicles[1]; // Tata Ace default
    }
    _currentBooking = _repo.getSampleBooking();
    notifyListeners();
  }

  void selectVehicle(PorterVehicleType vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void setPickup(String val) {
    _pickup = val;
    notifyListeners();
  }

  void setDrop(String val) {
    _drop = val;
    notifyListeners();
  }

  void setItemDetails(String val) {
    _itemDetails = val;
    notifyListeners();
  }

  void setDateTime(String val) {
    _dateTime = val;
    notifyListeners();
  }
}
