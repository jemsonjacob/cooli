import 'package:cooli/features/ride/model/ride_model.dart';
import 'package:cooli/features/ride/repo/ride_repo.dart';
import 'package:cooli/providers/view_model.dart';

class RideViewModel extends ViewModel {
  final RideRepo _repo;

  RideViewModel({RideRepo? repo}) : _repo = repo ?? RideRepo() {
    loadRideOptions();
  }

  String _pickupLocation = 'Current Location';
  String get pickupLocation => _pickupLocation;

  String _dropLocation = 'Cochin International Airport';
  String get dropLocation => _dropLocation;

  List<RideOption> _rideOptions = [];
  List<RideOption> get rideOptions => _rideOptions;

  RideOption? _selectedOption;
  RideOption? get selectedOption => _selectedOption;

  DriverModel? _driver;
  DriverModel? get driver => _driver;

  int _userRating = 5;
  int get userRating => _userRating;

  void loadRideOptions() {
    _rideOptions = _repo.getRideOptions();
    if (_rideOptions.length > 1) {
      _selectedOption = _rideOptions[1]; // Comfort
    }
    _driver = _repo.getAssignedDriver();
    notifyListeners();
  }

  void setPickup(String location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDrop(String location) {
    _dropLocation = location;
    notifyListeners();
  }

  void selectOption(RideOption option) {
    _selectedOption = option;
    notifyListeners();
  }

  void setRating(int rating) {
    _userRating = rating;
    notifyListeners();
  }
}
