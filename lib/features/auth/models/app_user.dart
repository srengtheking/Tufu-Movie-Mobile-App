class AppUser {
  final String? id;
  final String name;
  final String email;

  const AppUser({this.id, required this.name, required this.email});

  /// Accepts the API's `UserResponse` (`username`) as well as our own `name`.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString(),
      name: (json['name'] ?? json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

/// A user-facing auth failure.
class AuthException implements Exception {
  final String message;

  /// Which field the message belongs to, if any ('email', 'password', 'name').
  final String? field;

  const AuthException(this.message, {this.field});

  @override
  String toString() => message;
}
