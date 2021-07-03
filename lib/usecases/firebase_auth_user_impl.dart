import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helha/data/repositories/i_user_repo.dart';
import 'package:helha/data/repositories/shared_preferences_impl.dart';

import 'firebase_oauthStatus.dart';
import 'i_firebase_auth_user.dart';

class FirebaseAuthUserImpl extends GetxController implements IFirebaseAuthUser {
  FireBaseAuthStatus _fireBaseAuthStatus = FireBaseAuthStatus.signout;
  final IUserRepo _userRepo = SharedPreferencesImpl();
  User? _firebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FireBaseAuthStatus get fireBaseAuthStatus => _fireBaseAuthStatus;
  FirebaseAuth get fireBaseAuth => _firebaseAuth;

  @override
  set fireBaseAuthStatus(FireBaseAuthStatus status) {
    _fireBaseAuthStatus = status;
    update();
  }

  @override
  void watchUserAuthChange() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (_firebaseUser == null && firebaseUser == null) {
        changeFireBaseAuthStatus();
      } else if (_firebaseUser != firebaseUser) {
        _firebaseUser = firebaseUser;
        _userRepo.saveAccessToken(await getAccessToken());
        changeFireBaseAuthStatus();
      }
    });
  }

  @override
  void emailLogin(
      {@required String? emailId,
      @required String? password,
      BuildContext? context}) async {
    Get.defaultDialog(middleText: '로그인 시도 중입니다.');
    UserCredential authResult = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: emailId!.trim(), password: password!.trim())
        .catchError((error) {
      String _message = '오류입니다';
      switch (error.code) {
        case 'invalid-email':
          _message = '유효하지 않은 이메일 입니다';
          break;
        case 'user-disabled':
          _message = '차단된 사용자입니다.';
          break;
        case 'user-not-found':
          _message = '없는 이메일 입니다';
          break;
        case 'wrong-password':
          _message = '비밀번호가 틀렸습니다';
          break;
      }
      Get.defaultDialog(
          // TODO : 확인버튼만들기
          middleText: _message,
          confirm: Text('확인'));
    });
    _firebaseUser = authResult.user;
    watchUserAuthChange();
    changeFireBaseAuthStatus();
    if (_firebaseUser!.emailVerified == false) {
      await _firebaseUser?.sendEmailVerification();
      Get.back();
      Get.defaultDialog(middleText: "이메일 인증을 한뒤 다시 로그인 해주세요.");
    } else {
      Get.back();
      Get.defaultDialog(middleText: "로그인 완료되었습니다.");
    }
    if (_firebaseUser == null) {
      Get.back();
      Get.defaultDialog(middleText: '오류가 떴으니 나중에 다시해주세요.');
    }
  }

  @override
  void registerUser(
      {@required String? emailId,
      @required String? password,
      BuildContext? context}) async {
    changeFireBaseAuthStatus(FireBaseAuthStatus.progress);
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailId!.trim(), password: password!.trim())
        .catchError(
      (error) {
        //에러캐치해서 스낵바 실행시키기
        String _message = '알수없는 오류입니';
        print(error.code);
        switch (error.code) {
          case 'email-already-in-use':
            print('사용중');
            _message = '해당 아이디는 이미 사용중입니다';
            break;
          case 'invalid-email':
            _message = '이메일 형식이 아닙니다';
            break;
          case 'operation-not-allowed':
            _message = '아이디나 비밀번호가 일치하지않습니다';
            break;
        }
        Get.defaultDialog(middleText: _message);
      },
    );
    await _firebaseUser?.sendEmailVerification();
    Get.defaultDialog(middleText: '이메일 인증을 한 뒤 로그인 해 주세요.');
    watchUserAuthChange();
    update();
  }

  @override
  void signOut() {
    _fireBaseAuthStatus = FireBaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      _firebaseAuth.signOut();
    }
    update();
  }

  @override
  void changeFireBaseAuthStatus([FireBaseAuthStatus? firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      //매개변수로 받은 변수에 status변수가 null이아니면 private변수인 status변수를 바꿔준다.
      _fireBaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseUser != null) {
        //유저의 데이터가 있다면 로그인된상태이므로 status를 로그인으로 바꿔주
        _fireBaseAuthStatus = FireBaseAuthStatus.signin;
      } else {
        ///유저정보를 받지 못했을 경우 또는 없는 경우
        _fireBaseAuthStatus = FireBaseAuthStatus.signout;
      }
    }
    //상태변화됐으니까 프로바이더들에게 상태변화된 것을 알려주기.
    update();
  }

  @override
  Future<String?> getAccessToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    return await _firebaseMessaging.getToken();
  }
}
