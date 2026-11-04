import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../auth/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final auth = context.read<AuthProvider>();
    await Future.wait([_progress.forward(), auth.checkAuth()]);
    if (!mounted) return;
    // The router guard sends signed-out users to /login.
    context.go('/');
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(_image(context)), context);
  }

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Transparent artwork: white "MOVIE" for dark mode, dark for light mode.
  static String _image(BuildContext context) => _isDark(context)
      ? 'assets/images/splash-android-transparent.png'
      : 'assets/images/splash-android-transparent-light.png';

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final dark = _isDark(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: p.background,
          ),
      child: Scaffold(
        backgroundColor: p.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _image(context),
              fit: BoxFit.contain,
              gaplessPlayback: true,
              semanticLabel: 'Tufu Movie',
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 90 + MediaQuery.paddingOf(context).bottom,
              child: Center(
                child: SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: AnimatedBuilder(
                      animation: _progress,
                      builder: (_, _) => LinearProgressIndicator(
                        value: Curves.easeInOut.transform(_progress.value),
                        minHeight: 4,
                        color: AppColors.brand,
                        backgroundColor: p.button,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
