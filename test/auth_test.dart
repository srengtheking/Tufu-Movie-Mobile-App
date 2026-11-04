import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tufu_movie/core/theme/app_theme.dart';
import 'package:tufu_movie/features/auth/data/auth_repository.dart';
import 'package:tufu_movie/features/auth/providers/auth_provider.dart';
import 'package:tufu_movie/features/auth/screens/login_screen.dart';
import 'package:tufu_movie/features/auth/screens/register_screen.dart';
import 'package:tufu_movie/features/auth/validators.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  group('AuthValidators', () {
    test('email', () {
      expect(AuthValidators.email(''), isNotNull);
      expect(AuthValidators.email('bad@'), isNotNull);
      expect(AuthValidators.email('a@b.co'), isNull);
    });
    test('new password needs 8+ chars with letters and numbers', () {
      expect(AuthValidators.newPassword('short1'), isNotNull);
      expect(AuthValidators.newPassword('allletters'), isNotNull);
      expect(AuthValidators.newPassword('secret123'), isNull);
    });
  });

  group('AuthProvider + LocalAuthRepository', () {
    AuthProvider make() => AuthProvider(repository: LocalAuthRepository());

    test('register signs in and the session survives a restart', () async {
      final auth = make();
      final result = await auth.register(
        'Sreng',
        'Sreng@Mail.com',
        'secret123',
      );
      expect(result, RegisterResult.signedIn);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.user!.name, 'Sreng');

      final restarted = make();
      await restarted.checkAuth();
      expect(restarted.isAuthenticated, isTrue);
      expect(restarted.user!.email, 'Sreng@Mail.com');
    });

    test('duplicate email is rejected', () async {
      final auth = make();
      await auth.register('A', 'a@b.co', 'secret123');
      await auth.logout();
      final result = await auth.register('B', 'A@B.CO', 'secret456');
      expect(result, RegisterResult.failed);
      expect(auth.errorMessage, contains('already exists'));
    });

    test('wrong password fails, right password works, logout clears', () async {
      final auth = make();
      await auth.register('A', 'a@b.co', 'secret123');
      await auth.logout();
      expect(auth.isAuthenticated, isFalse);

      expect(await auth.login('a@b.co', 'nope12345'), isFalse);
      expect(auth.errorMessage, 'Incorrect email or password.');

      expect(await auth.login('a@b.co', 'secret123'), isTrue);
      expect(auth.errorMessage, isNull);

      await auth.logout();
      final restarted = make();
      await restarted.checkAuth();
      expect(restarted.status, AuthStatus.unauthenticated);
    });
  });

  group('screens', () {
    Future<AuthProvider> pump(WidgetTester t, Widget screen) async {
      final auth = AuthProvider(repository: LocalAuthRepository());
      await t.pumpWidget(
        ChangeNotifierProvider.value(
          value: auth,
          child: MaterialApp(theme: AppTheme.darkTheme, home: screen),
        ),
      );
      return auth;
    }

    testWidgets('login shows field errors when empty', (t) async {
      await pump(t, const LoginScreen());
      await t.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await t.pump();
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('login shows server error for unknown account', (t) async {
      await pump(t, const LoginScreen());
      await t.enterText(find.byType(TextFormField).at(0), 'x@y.com');
      await t.enterText(find.byType(TextFormField).at(1), 'whatever1');
      await t.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await t.pump(const Duration(seconds: 1));
      await t.pumpAndSettle();
      expect(find.text('Incorrect email or password.'), findsOneWidget);
    });

    testWidgets('register creates account and signs in', (t) async {
      final auth = await pump(t, const RegisterScreen());
      final fields = find.byType(TextFormField);
      await t.enterText(fields.at(0), 'Sreng');
      await t.enterText(fields.at(1), 'sreng@mail.com');
      await t.enterText(fields.at(2), 'short');
      await t.tap(find.widgetWithText(FilledButton, 'Create account'));
      await t.pump();
      expect(find.text('Use at least 8 characters'), findsOneWidget);

      await t.enterText(fields.at(2), 'secret123');
      await t.tap(find.widgetWithText(FilledButton, 'Create account'));
      await t.pump(const Duration(seconds: 2));
      await t.pumpAndSettle();
      expect(auth.isAuthenticated, isTrue);
      expect(auth.user!.email, 'sreng@mail.com');
    });
  });
}
