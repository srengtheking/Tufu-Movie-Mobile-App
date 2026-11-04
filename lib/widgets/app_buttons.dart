import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

const _buttonRadius = BorderRadius.all(Radius.circular(8));

TextStyle _labelStyle(BuildContext context, double fontSize) =>
    Theme.of(context).textTheme.titleMedium!
        .copyWith(fontSize: fontSize, fontWeight: FontWeight.w700);

/// Solid red call-to-action.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final double fontSize;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.height = 52,
    this.fontSize = 16,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
        disabledForegroundColor: Colors.white,
        minimumSize: Size(0, height),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: const RoundedRectangleBorder(borderRadius: _buttonRadius),
        textStyle: _labelStyle(context, fontSize),
      ),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white,
              ),
            )
          : Text(label),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Neutral grey button used next to / below a primary button.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final bool expand;
  final Color? background;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 52,
    this.fontSize = 16,
    this.expand = true,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background ?? p.button,
        foregroundColor: p.textPrimary,
        minimumSize: Size(0, height),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: const RoundedRectangleBorder(borderRadius: _buttonRadius),
        textStyle: _labelStyle(context, fontSize),
      ),
      child: Text(label),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Round back button. [filled] draws a dark circle behind it for use on
/// top of imagery.
class AppBackButton extends StatelessWidget {
  final bool filled;
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.filled = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: filled ? p.background.withValues(alpha: 0.85) : Colors.transparent,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: 'Back',
        onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 22,
          color: p.textPrimary,
        ),
      ),
    );
  }
}
