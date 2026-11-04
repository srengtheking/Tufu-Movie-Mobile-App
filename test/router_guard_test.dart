import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tufu_movie/core/router/app_router.dart';
import 'package:tufu_movie/features/auth/data/auth_repository.dart';
import 'package:tufu_movie/features/auth/providers/auth_provider.dart';
import 'package:tufu_movie/features/auth/screens/login_screen.dart';
import 'package:tufu_movie/features/wallet/providers/wallet_provider.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('signed-out users are sent from Home to Sign in', (t) async {
    FlutterSecureStorage.setMockInitialValues({});
    final auth = AuthProvider(repository: LocalAuthRepository());
    await auth.checkAuth();
    final router = AppRouter.create(auth);
    addTearDown(router.dispose);

    await t.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProvider(create: (_) => WalletProvider()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    router.go('/profile');
    await t.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri.path, '/login');
  });
}
