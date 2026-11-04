/// Form validators for the auth screens. Return null when valid.
class AuthValidators {
  AuthValidators._();

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? name(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your name';
    if (value.length < 2) return 'Name is too short';
    return null;
  }

  static String? email(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your email';
    if (!_email.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? loginPassword(String? v) =>
      (v == null || v.isEmpty) ? 'Enter your password' : null;

  static String? newPassword(String? v) {
    final value = v ?? '';
    if (value.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(value) ||
        !RegExp(r'\d').hasMatch(value)) {
      return 'Use letters and numbers';
    }
    return null;
  }
}
