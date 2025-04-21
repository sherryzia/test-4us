import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefController extends GetxController {
  SharedPreferences? _pref;
  RxBool isloading = false.obs;

  Future<void> initPref() async {
    isloading.value = true;
    _pref = await SharedPreferences.getInstance();
    isloading.value = false;
  }

  void login(String aTk, String rTk, String uId) {
    print("Called login");
    if (!_pref!.containsKey('aTk') && !_pref!.containsKey('rTk')) {
      print("Doesnt have");
      _pref?.setString('aTk', aTk);
      _pref?.setString('rTk', rTk);
      _pref?.setString('uid', uId);
    } else {
      logout();
      login(aTk, rTk, uId);
    }
  }

  void refrsh(String aTk) {
    if (_pref!.containsKey('aTk')) {
      _pref?.remove('aTk');
      _pref?.setString('aTk', aTk);
    }
  }

  void logout() {
    if (_pref!.containsKey('aTk') || _pref!.containsKey('rTk')) {
      _pref?.remove('aTk');
      _pref?.remove('rTk');
      _pref?.remove('uId');
    }
  }

  bool isLoggedin() =>
      _pref!.containsKey('aTk') &&
      _pref!.containsKey('rTk') &&
      _pref!.containsKey('uId');

  // Map gTk() => {
  //       "aTk": _pref?.getString('aTk') ?? "",
  //       "rTk": _pref?.getString('rTk') ?? "",
  //       "uId": _pref?.getString('uId') ?? "",
  //     };

  String get aTk => _pref?.getString('aTk') ?? "";
  String get rTk => _pref?.getString('rTk') ?? "";
  String get uId => _pref?.getString('uId') ?? "";
}
