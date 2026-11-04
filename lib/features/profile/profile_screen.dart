import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.card,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Guest User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              'guest@tufu.com',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          const SizedBox(height: 30),
          _menuItem(Icons.bookmark_outline, 'My Watchlist'),
          _menuItem(Icons.history, 'Watch History'),
          _menuItem(Icons.settings_outlined, 'Settings'),
          _menuItem(Icons.language, 'Language'),
          _menuItem(Icons.help_outline, 'Help & Support'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            child: const Text('Login / Register'),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: () {},
    );
  }
}
