import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helha/Controller/login_controller.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _idController = new TextEditingController();
    TextEditingController _pwdController = new TextEditingController();
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
                Center(child: Text('헬하')),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '아이디를 넣어주세요',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호를 넣어주세요',
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
