class AuthResponse {
  final String accessToken;
  final String tokenType;

  AuthResponse({required this.accessToken, this.tokenType = 'Bearer'});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? json['token'],
      tokenType: json['tokenType'] ?? 'Bearer',
    );
  }
}
