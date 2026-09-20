import 'package:cs_elective_2/utils/breakpoints.dart';
import 'package:cs_elective_2/utils/platform_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DashboardNavItem { dashboard, settings, about, logout }

class AdaptiveNavigationDrawer extends StatelessWidget {
  const AdaptiveNavigationDrawer({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DashboardNavItem selected;
  final ValueChanged<DashboardNavItem> onSelected;

  static const _items = <(DashboardNavItem, IconData, IconData, String)>[
    (
      DashboardNavItem.dashboard,
      Icons.home_outlined,
      CupertinoIcons.house,
      'DASHBOARD',
    ),
    (
      DashboardNavItem.settings,
      Icons.settings_outlined,
      CupertinoIcons.settings,
      'SETTINGS',
    ),
    (
      DashboardNavItem.about,
      Icons.info_outline,
      CupertinoIcons.info,
      'ABOUT',
    ),
    (
      DashboardNavItem.logout,
      Icons.logout,
      CupertinoIcons.arrow_right_square,
      'LOGOUT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cupertino = PlatformAdaptive.useCupertino;
    final width = MediaQuery.sizeOf(context).width;
    final drawerWidth = width >= Breakpoints.desktop ? 280.0 : 260.0;

    return Material(
      color: cupertino ? CupertinoColors.systemBackground : Colors.white,
      child: SizedBox(
        width: drawerWidth,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                cupertino ? CupertinoIcons.heart_fill : Icons.favorite,
                size: 56,
                color: cupertino
                    ? CupertinoColors.systemRed
                    : Colors.grey.shade800,
              ),
              const SizedBox(height: 32),
              ..._items.map((entry) {
                final (item, materialIcon, cupertinoIcon, label) = entry;
                final isSelected = selected == item;
                return _DrawerTile(
                  label: label,
                  icon: cupertino ? cupertinoIcon : materialIcon,
                  selected: isSelected,
                  onTap: () => onSelected(item),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cupertino = PlatformAdaptive.useCupertino;
    final color = selected
        ? (cupertino ? CupertinoColors.activeBlue : Theme.of(context).colorScheme.primary)
        : (cupertino ? CupertinoColors.label : Colors.grey.shade800);

    if (cupertino) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
      selected: selected,
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
    );
  }
}
