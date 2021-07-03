import 'package:helha/data/repositories/i_user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImpl implements IUserRepo {
  static final SharedPreferencesImpl _instance =
      SharedPreferencesImpl._makeInstance();
  factory SharedPreferencesImpl() {
    return _instance;
  }

  SharedPreferencesImpl._makeInstance() {
    //Init
  }

  @override
  void saveAccessToken(String? accessToken) async {
    final sharedPreferencesInstance = await getSharedPreferences();
    await sharedPreferencesInstance.setString('accessToken', accessToken!);
  }

  @override
  void getAccessToekn() async {
    final sharedPreferencesInstance = await getSharedPreferences();
    print(sharedPreferencesInstance.getString('accessToken'));
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }
}
