import 'package:cooli/providers/view_model.dart';

class SplashViewModel extends ViewModel{

   bool? _checkBoxVal;

  bool? get checkBoxVal => _checkBoxVal;

  set checkBoxVal(bool? val) {
    _checkBoxVal = val;
    notifyListeners();
  }
     bool? _checkRadioButtonVal;

  bool? get checkRadioButtonVal => _checkRadioButtonVal;

  set checkRadioButtonVal(bool? val) {
    _checkRadioButtonVal = val;
    notifyListeners();
  }
}