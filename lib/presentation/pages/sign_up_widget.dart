import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helha/presentation/widgets/oauth_validate_widget.dart';
import 'package:helha/usecases/firebase_auth_user_impl.dart';

import 'login_widget.dart';

class SignUp extends StatelessWidget {
  final _loginController = Get.put(FirebaseAuthUserImpl());
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _confirmpwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(
      builder: (context) => Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(child: Text('헬하 가입하기')),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailIdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        value.contains('@') &&
                        value.contains('.'))
                      return null;
                    else
                      return '@, .com 가 들어간 이메일을 넣어주세요';
                  },
                  cursorColor: Colors.black,
                  decoration: oauthValidateWidget(
                      hint: 'ex) abc@def.com', iconData: Icons.email_outlined),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pwdController,
                  // decoration: InputDecoration(
                  //   border: OutlineInputBorder(),
                  //   labelText: '비밀번호를 넣어주세요',
                  // ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length >= 6) {
                      return null;
                    } else
                      return '6자리 이상 비밀번호를 입력해 주세요';
                  },
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: oauthValidateWidget(
                    hint: '사용할 비밀번호를 입력하세요',
                    iconData: Icons.lock_outline,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _confirmpwdController,
                  // decoration: InputDecoration(
                  //   border: OutlineInputBorder(),
                  //   labelText: '비밀번호를 넣어주세요',
                  // ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length >= 6) {
                      return null;
                    } else
                      return '6자리 이상 비밀번호를 입력해 주세요';
                  },
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: oauthValidateWidget(
                    hint: '비밀번호를 다시 입력하세요',
                    iconData: Icons.lock_outline,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _loginController.registerUser(
                          emailId: _emailIdController.text,
                          password: _pwdController.text);
                    },
                    child: Text('가입하기')),
                ElevatedButton(
                    onPressed: () {
                      Get.offAll(LoginWidget());
                    },
                    child: Text('로그인 하러가기')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
