import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository extends GetxController {
  SharedPreferences? _sharedPreferences;
  @override
  void onInit() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    super.onInit();
  }

  void saveAccessToken(String? accessToken) async {
    await _sharedPreferences!.setString('accessToken', accessToken!);
  }
}
