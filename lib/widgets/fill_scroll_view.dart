import 'package:flutter/material.dart';

/// Lets a Column with Spacers fill the screen, but scroll instead of
/// overflowing on short screens or with large text.
class FillScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const FillScrollView({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - padding.vertical,
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
