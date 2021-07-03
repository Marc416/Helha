import 'firebase_oauthStatus.dart';

abstract class IFirebaseAuthUser {
  late FireBaseAuthStatus fireBaseAuthStatus;
  void emailLogin();
  void registerUser();
  void signOut();
  Future<String?> getAccessToken();
  void watchUserAuthChange();
  void changeFireBaseAuthStatus([FireBaseAuthStatus? firebaseAuthStatus]);
}
