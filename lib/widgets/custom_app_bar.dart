import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  centered,
  minimal,
  withActions,
  withSearch,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final VoidCallback? onSearchTap;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onSearchTap,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.flexibleSpace,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: _shouldCenterTitle(),
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading && showBackButton,
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      scrolledUnderElevation: theme.appBarTheme.scrolledUnderElevation,
      shadowColor: theme.appBarTheme.shadowColor,
      surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: theme.appBarTheme.iconTheme,
      actionsIconTheme: theme.appBarTheme.actionsIconTheme,
    );
  }

  Widget _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.withActions:
        return Text(title);
      case CustomAppBarVariant.centered:
        return Text(title);
      case CustomAppBarVariant.minimal:
        return Text(
          title,
          style: _getTitleTextStyle(context).copyWith(
            fontWeight: FontWeight.w500,
          ),
        );
      case CustomAppBarVariant.withSearch:
        return Row(
          children: [
            Expanded(child: Text(title)),
            IconButton(
              onPressed: onSearchTap,
              icon: const Icon(Icons.search),
              tooltip: 'Search',
            ),
          ],
        );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (variant == CustomAppBarVariant.minimal) {
      return null;
    }

    // Custom back button with financial app styling
    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.centered:
      case CustomAppBarVariant.minimal:
        return actions;

      case CustomAppBarVariant.withActions:
        return [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/analytics-dashboard-screen'),
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Analytics',
          ),
          IconButton(
            onPressed: () {
              // Show notifications or settings
              _showQuickActions(context);
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
          ),
          if (actions != null) ...actions!,
        ];

      case CustomAppBarVariant.withSearch:
        return actions ?? [];
    }
  }

  bool _shouldCenterTitle() {
    switch (variant) {
      case CustomAppBarVariant.centered:
      case CustomAppBarVariant.minimal:
        return true;
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.withActions:
      case CustomAppBarVariant.withSearch:
        return false;
    }
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.withActions:
        return GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        );
      case CustomAppBarVariant.centered:
        return GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        );
      case CustomAppBarVariant.minimal:
        return GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        );
      case CustomAppBarVariant.withSearch:
        return GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        );
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to notifications
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
