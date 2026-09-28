import 'package:cooli/features/auth/model/auth_model.dart';
import 'package:cooli/features/auth/repo/auth_repo.dart';
import 'package:cooli/providers/view_model.dart';

class AuthViewModel extends ViewModel {
  final AuthRepo _repo;

  AuthViewModel({AuthRepo? repo}) : _repo = repo ?? AuthRepo();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  bool _agreeToTerms = true;
  bool get agreeToTerms => _agreeToTerms;

  String _otpCode = '';
  String get otpCode => _otpCode;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setAgreeToTerms(bool value) {
    _agreeToTerms = value;
    notifyListeners();
  }

  void setOtpCode(String code) {
    _otpCode = code;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repo.login(phoneNumber: phone, password: password);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repo.register(
        fullName: fullName,
        phoneNumber: phone,
        email: email,
        password: password,
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendOtp(String phone) async {
    isLoading = true;
    notifyListeners();
    try {
      return await _repo.sendOtp(phoneNumber: phone);
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    isLoading = true;
    notifyListeners();
    try {
      return await _repo.verifyOtp(phoneNumber: phone, otp: otp);
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
