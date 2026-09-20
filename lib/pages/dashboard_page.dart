import 'package:cs_elective_2/utils/breakpoints.dart';
import 'package:cs_elective_2/utils/platform_adaptive.dart';
import 'package:cs_elective_2/widgets/adaptive_action_button.dart';
import 'package:cs_elective_2/widgets/adaptive_navigation_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DashboardNavItem _selectedNav = DashboardNavItem.dashboard;
  bool _overlayDrawerOpen = false;

  void _onNavSelected(DashboardNavItem item) {
    setState(() => _selectedNav = item);
    _closeDrawer();
    if (item == DashboardNavItem.logout) {
      _showLogoutMessage();
    }
  }

  void _closeDrawer() {
    if (PlatformAdaptive.useCupertino) {
      setState(() => _overlayDrawerOpen = false);
    } else {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _openDrawer() {
    if (PlatformAdaptive.useCupertino) {
      setState(() => _overlayDrawerOpen = true);
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  void _showLogoutMessage() {
    final cupertino = PlatformAdaptive.useCupertino;
    if (cupertino) {
      showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Logout'),
          content: const Text('Wireframe demo — no session to end.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout tapped (demo)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = Breakpoints.isDesktop(width);

        if (isDesktop) {
          return _DesktopDashboardShell(
            selectedNav: _selectedNav,
            onNavSelected: _onNavSelected,
            body: _DashboardBody(width: width),
          );
        }

        if (PlatformAdaptive.useCupertino) {
          return _CupertinoMobileShell(
            overlayDrawerOpen: _overlayDrawerOpen,
            onCloseDrawer: () => setState(() => _overlayDrawerOpen = false),
            onOpenDrawer: _openDrawer,
            selectedNav: _selectedNav,
            onNavSelected: _onNavSelected,
            body: _DashboardBody(width: width),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'responsivedashboard',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Open menu',
              onPressed: _openDrawer,
            ),
          ),
          drawer: Drawer(
            child: AdaptiveNavigationDrawer(
              selected: _selectedNav,
              onSelected: _onNavSelected,
            ),
          ),
          body: _DashboardBody(width: width),
        );
      },
    );
  }
}

class _CupertinoMobileShell extends StatelessWidget {
  const _CupertinoMobileShell({
    required this.overlayDrawerOpen,
    required this.onCloseDrawer,
    required this.onOpenDrawer,
    required this.selectedNav,
    required this.onNavSelected,
    required this.body,
  });

  final bool overlayDrawerOpen;
  final VoidCallback onCloseDrawer;
  final VoidCallback onOpenDrawer;
  final DashboardNavItem selectedNav;
  final ValueChanged<DashboardNavItem> onNavSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            border: null,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onOpenDrawer,
              child: const Icon(
                CupertinoIcons.bars,
                color: CupertinoColors.white,
              ),
            ),
            middle: const Text(
              'responsivedashboard',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.white,
              ),
            ),
          ),
          child: SafeArea(child: body),
        ),
        if (overlayDrawerOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: onCloseDrawer,
              child: Container(color: Colors.black54),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          left: overlayDrawerOpen ? 0 : -280,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: !overlayDrawerOpen,
            child: AdaptiveNavigationDrawer(
              selected: selectedNav,
              onSelected: onNavSelected,
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopDashboardShell extends StatelessWidget {
  const _DesktopDashboardShell({
    required this.selectedNav,
    required this.onNavSelected,
    required this.body,
  });

  final DashboardNavItem selectedNav;
  final ValueChanged<DashboardNavItem> onNavSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final cupertino = PlatformAdaptive.useCupertino;
    final mouseFriendly = PlatformAdaptive.preferMouseInteractions(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'responsivedashboard',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (cupertino)
            AdaptiveNavigationDrawer(
              selected: selectedNav,
              onSelected: onNavSelected,
            )
          else
            NavigationRail(
              extended: mouseFriendly,
              backgroundColor: Colors.white,
              selectedIndex: selectedNav.index,
              onDestinationSelected: (i) =>
                  onNavSelected(DashboardNavItem.values[i]),
              labelType: mouseFriendly
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('About'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                ),
              ],
            ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.width});

  final double width;

  int get _gridCrossAxisCount {
    if (Breakpoints.isMobile(width)) return 2;
    return 4;
  }

  int get _listItemCount {
    if (Breakpoints.isMobile(width)) return 3;
    if (Breakpoints.isTablet(width)) return 5;
    return 6;
  }

  double get _horizontalPadding {
    if (Breakpoints.isDesktop(width)) return 32;
    if (Breakpoints.isTablet(width)) return 24;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final cupertino = PlatformAdaptive.useCupertino;
    final mouseFriendly = PlatformAdaptive.preferMouseInteractions(context);
    final gridSpacing = Breakpoints.isMobile(width) ? 12.0 : 16.0;
    final gridTileAspect = Breakpoints.isMobile(width) ? 1.0 : 1.15;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            _horizontalPadding,
            16,
            _horizontalPadding,
            8,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _gridCrossAxisCount,
              mainAxisSpacing: gridSpacing,
              crossAxisSpacing: gridSpacing,
              childAspectRatio: gridTileAspect,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, index) => _WireframeTile(
                cupertino: cupertino,
                mouseFriendly: mouseFriendly,
              ),
              childCount: 4,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AdaptiveActionButton(
                  label: 'Click Me',
                  icon: cupertino
                      ? CupertinoIcons.heart_fill
                      : Icons.favorite,
                  onPressed: () {},
                ),
                AdaptiveActionButton(
                  label: 'Disabled',
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            _horizontalPadding,
            16,
            _horizontalPadding,
            24,
          ),
          sliver: SliverList.separated(
            itemCount: _listItemCount,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => _WireframeListBar(
              cupertino: cupertino,
              mouseFriendly: mouseFriendly,
            ),
          ),
        ),
      ],
    );
  }
}

class _WireframeTile extends StatefulWidget {
  const _WireframeTile({
    required this.cupertino,
    required this.mouseFriendly,
  });

  final bool cupertino;
  final bool mouseFriendly;

  @override
  State<_WireframeTile> createState() => _WireframeTileState();
}

class _WireframeTileState extends State<_WireframeTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final base = widget.cupertino
        ? CupertinoColors.systemGrey4
        : Colors.grey.shade400;
    final hover = widget.cupertino
        ? CupertinoColors.systemGrey3
        : Colors.grey.shade500;

    Widget tile = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: widget.mouseFriendly && _hovered ? hover : base,
        borderRadius: BorderRadius.circular(widget.cupertino ? 12 : 4),
      ),
    );

    if (widget.mouseFriendly) {
      tile = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: tile,
      );
    }

    return tile;
  }
}

class _WireframeListBar extends StatefulWidget {
  const _WireframeListBar({
    required this.cupertino,
    required this.mouseFriendly,
  });

  final bool cupertino;
  final bool mouseFriendly;

  @override
  State<_WireframeListBar> createState() => _WireframeListBarState();
}

class _WireframeListBarState extends State<_WireframeListBar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.cupertino ? 12.0 : 8.0;
    final height = Breakpoints.isDesktop(MediaQuery.sizeOf(context).width)
        ? 56.0
        : 48.0;
    final base = widget.cupertino
        ? CupertinoColors.systemGrey5
        : Colors.grey.shade300;
    final hover = widget.cupertino
        ? CupertinoColors.systemGrey4
        : Colors.grey.shade400;

    Widget bar = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: height,
      decoration: BoxDecoration(
        color: widget.mouseFriendly && _hovered ? hover : base,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    if (widget.mouseFriendly) {
      bar = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: bar,
      );
    }

    return bar;
  }
}
