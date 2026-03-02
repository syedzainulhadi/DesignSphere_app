// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/theme_provider.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'contact_screen.dart';
import 'team_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _navController;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _navController.forward();
  }

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
    _navController.reset();
    _navController.forward();
  }

  void goToContact()  => _onTabTap(2);
  void goToServices() => _onTabTap(1);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onContactTap: goToContact, onServicesTap: goToServices),
          const ServicesScreen(),
          const ContactScreen(),
          const TeamScreen(),
          const AboutScreen(),
        ],
      ),
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabTap,
        isDark: isDark,
      ),
    );
  }
}

// ── Premium custom bottom nav ─────────────────────────────────────────────────
class _PremiumNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  final bool isDark;

  const _PremiumNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.isDark,
  });

  static const _items = [
    _NavItem(icon: Icons.home_outlined,    activeIcon: Icons.home_rounded,          label: 'Home'),
    _NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded,   label: 'Services'),
    _NavItem(icon: Icons.mail_outline_rounded, activeIcon: Icons.mail_rounded,      label: 'Contact'),
    _NavItem(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded,  label: 'Team'),
    _NavItem(icon: Icons.info_outline_rounded,  activeIcon: Icons.info_rounded,     label: 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;
    final divider = isDark ? AppTheme.dividerDark : AppTheme.dividerLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: divider, width: 0.5)),
        boxShadow: isDark
            ? [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -4))]
            : [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (i) {
              final isActive = i == selectedIndex;
              final item = _items[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.primary.withOpacity(isDark ? 0.18 : 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            color: isActive ? AppTheme.primary : (isDark ? AppTheme.textHintD : AppTheme.textHintL),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                            color: isActive
                                ? AppTheme.primary
                                : (isDark ? AppTheme.textHintD : AppTheme.textHintL),
                            fontFamily: 'Poppins',
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}