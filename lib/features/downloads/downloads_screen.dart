import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_buttons.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads'), titleSpacing: 20),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: p.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.download_rounded,
                  size: 44,
                  color: p.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No downloads yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Movies you download appear here so you can watch them offline.',
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Find something to download',
                expand: false,
                height: 48,
                fontSize: 15,
                onPressed: () => context.go('/'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
