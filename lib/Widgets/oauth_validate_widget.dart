import 'package:flutter/material.dart';
import 'package:helha/Const/common_size.dart';

InputDecoration oauthValidateWidget({String? hint, IconData? iconData}) {
  return InputDecoration(
    hintText: hint,
    //아이콘 색을 설정해 줘야 텍스트폼필드 활성화시 사라지는것처럼 안보임.
    prefixIcon: iconData != null
        ? Icon(
            iconData,
            color: Colors.grey,
          )
        : null,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(common_gap),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(common_gap),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(common_gap),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(common_gap),
    ),
  );
}
