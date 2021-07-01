import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helha/Data/repositories/sharedpreferences.dart';

class LoginController extends GetxController {
  FireBaseAuthStatus _fireBaseAuthStatus = FireBaseAuthStatus.signout;
  final _sharedPreferencesController = Get.put(SharedPreferencesRepository());
  User? _firebaseUser;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void watchAuthChange() {
    ///스트림으로 파이어베이스 User데이터를 스트림으로 바뀔때마다 계속 받아 온다
    ///Stream<User>라는 것은 User데이터를 넘겨준다는 것임
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (_firebaseUser == null && firebaseUser == null) {
        ///처음에 파이어베이스로부터 받는 user 정보가 null 이기 때문에 Progress 상태에서
        ///Sign out 상태로 바꿔주기 위함.
        changeFireBaseAuthStatus();
      } else if (_firebaseUser != firebaseUser) {
        _firebaseUser = firebaseUser;
        FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
        final accessToken = await _firebaseMessaging.getToken();
        _sharedPreferencesController.saveAccessToken(accessToken!);
        changeFireBaseAuthStatus();
      }
    });
  }

  // Future<void> mobileLogin(String phoneNumber, BuildContext context) async {
  //   _firebaseAuth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     //메시지를 받기까지 최대 몇초기다리게 할 것인
  //     timeout: Duration(seconds: 10),
  //     //이미 가임되서 아이디가 있는경우
  //     verificationCompleted: (phoneAuthCredential) async {
  //       var authResult =
  //           await _firebaseAuth.signInWithCredential(phoneAuthCredential);
  //       _firebaseUser = authResult.user;
  //       if (_firebaseUser == null) {
  //         SnackBar snackBar = SnackBar(
  //             content: Text(
  //           '오류가 떴으니 나중에 다시해주세요.',
  //         ));
  //         Scaffold.of(context).showSnackBar(snackBar);
  //       }
  //     },
  //     verificationFailed: (error) {
  //       Get.defaultDialog(middleText: '에러 : $error');
  //     codeSent: (verificationId, forceResendingToken) {
  //       try {
  //         showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (context) {
  //               return ConfirmOTP(
  //                 verificationId: verificationId,
  //                 firebaseAuth: _firebaseAuth,
  //                 firebaseUser: _firebaseUser,
  //                 context: context,
  //               );
  //             });
  //       } catch (e) {
  //         print('codeSent :$e');
  //       }
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) {
  //       verificationId = verificationId;
  //       print(verificationId);
  //       print('timeOut');
  //     },
  //   );
  // }

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
      );
    });
    _firebaseUser = authResult.user;
    watchAuthChange();
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

  Future<bool> findPassWord({required String email}) async {
    bool result = true;

    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .catchError((onError) {
      return result = false;
    });
    return result;
  }

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
    watchAuthChange();
    update();
  }

  void signOut() {
    _fireBaseAuthStatus = FireBaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      _firebaseAuth.signOut();
    }
    update();
  }

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

  FireBaseAuthStatus get fireBaseAuthStatus => _fireBaseAuthStatus;
  FirebaseAuth get fireBaseAuth => _firebaseAuth;

  set fireBaseAuthStatus(FireBaseAuthStatus status) {
    _fireBaseAuthStatus = status;
    update();
  }
}

enum FireBaseAuthStatus { progress, signin, signout }
