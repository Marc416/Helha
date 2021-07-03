import 'package:flutter/material.dart';
import 'package:helha/entities/client_info.dart';

class CredentialModel {
  final String accessToken;
  CredentialModel(
    this.accessToken,
  );

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
    };
  }
}
