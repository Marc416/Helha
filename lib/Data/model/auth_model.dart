class AuthModel {
  final String accessToken;
  AuthModel(
    this.accessToken,
  );

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
    };
  }
}
