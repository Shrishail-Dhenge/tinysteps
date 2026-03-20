import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import 'parent_home_screen.dart';

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({super.key});

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ParentHomeScreen(),
    const _PlaceholderScreen(title: 'My Children', icon: Icons.face_rounded),
    const _PlaceholderScreen(title: 'Attendance', icon: Icons.assignment_rounded),
    const _PlaceholderScreen(title: 'Account', icon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      extendBody: true, // Let body extend behind bottom nav
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavBarItem(icon: Icons.home_rounded, label: 'Home'),
          BottomNavBarItem(icon: Icons.face_rounded, label: 'Children'),
          BottomNavBarItem(icon: Icons.assignment_rounded, label: 'Attendance'),
          BottomNavBarItem(icon: Icons.settings_rounded, label: 'Account'),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.heading2),
        backgroundColor: AppColors.bgLight,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: colorScheme.primary.withOpacity(0.5)),
            const SizedBox(height: AppSpacing.md),
            Text('$title Coming Soon...', style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}
