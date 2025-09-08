import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/side_navigation.dart';
import '../screens/explore_page.dart';
import '../screens/alerts_page.dart';
import '../screens/collaborate_page.dart';
import '../screens/ar_vr_page.dart';
import '../screens/settings_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<Widget> _pages = [
    const ExplorePage(),
    const AlertsPage(),
    const CollaboratePage(),
    const ARVRPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Side Navigation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarCollapsed ? 80 : 280,
            child: SideNavigation(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              isCollapsed: _isSidebarCollapsed,
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(),
                
                // Page Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: const Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Sidebar Toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            icon: Icon(
              _isSidebarCollapsed ? Icons.menu : Icons.menu_open,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Breadcrumb
          Expanded(
            child: _buildBreadcrumb(),
          ),
          
          // Search Bar
          _buildSearchBar(),
          
          const SizedBox(width: 16),
          
          // Notifications
          _buildNotificationButton(),
          
          const SizedBox(width: 16),
          
          // User Menu
          _buildUserMenu(),
          
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    final pageNames = ['Explore', 'Alerts', 'Collaborate', 'AR/VR', 'Settings'];
    final currentPageName = pageNames[_selectedIndex];
    
    return Row(
      children: [
        const Icon(
          Icons.home,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 8),
        const Text(
          'WAVE',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          currentPageName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search locations, data...',
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppTheme.textSecondaryColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            // Handle notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.errorColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu selection
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 12),
              Text('Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 20),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'help',
          child: Row(
            children: [
              Icon(Icons.help_outline, size: 20),
              SizedBox(width: 12),
              Text('Help'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 12),
              Text('Sign Out'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

