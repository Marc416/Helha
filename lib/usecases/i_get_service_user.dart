import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_oauthStatus.dart';

abstract class IgetFirebaseAuthUser {
  late FireBaseAuthStatus fireBaseAuthStatus;
  FireBaseAuthStatus _fireBaseAuthStatus = FireBaseAuthStatus.signout;
  void emailLogin();
  void registerUser();
  void signOut();
  Future<String?> getAccessToken();
}
