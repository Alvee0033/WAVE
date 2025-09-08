import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SideNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCollapsed;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
  });

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.public,
      label: 'Explore',
      description: 'Interactive Earth Data',
      color: AppTheme.primaryColor,
    ),
    NavigationItem(
      icon: Icons.warning_amber_rounded,
      label: 'Alerts',
      description: 'AI Anomaly Detection',
      color: AppTheme.warningColor,
    ),
    NavigationItem(
      icon: Icons.people_alt_rounded,
      label: 'Collaborate',
      description: 'Multi-user Features',
      color: AppTheme.secondaryColor,
    ),
    NavigationItem(
      icon: Icons.view_in_ar_rounded,
      label: 'AR/VR',
      description: 'Immersive Experiences',
      color: AppTheme.accentColor,
    ),
    NavigationItem(
      icon: Icons.settings_rounded,
      label: 'Settings',
      description: 'User Preferences',
      color: AppTheme.textSecondaryColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isCollapsed ? 80 : 280,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.sidebarColor,
        border: const Border(
          right: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: _buildNavigationItems(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: widget.isCollapsed
          ? const Icon(
              Icons.public,
              size: 32,
              color: AppTheme.primaryColor,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.public,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'WAVE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Earth Observation Platform',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNavigationItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _navigationItems.length,
      itemBuilder: (context, index) {
        final item = _navigationItems[index];
        final isSelected = widget.selectedIndex == index;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildNavigationItem(item, index, isSelected),
        );
      },
    );
  }

  Widget _buildNavigationItem(NavigationItem item, int index, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onItemSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? 12 : 16,
            vertical: 12,
          ),
          decoration: AppTheme.sidebarItemDecoration(
            isSelected: isSelected,
          ),
          child: widget.isCollapsed
              ? Icon(
                  item.icon,
                  color: isSelected ? item.color : AppTheme.textSecondaryColor,
                  size: 24,
                )
              : Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? item.color.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        color: isSelected ? item.color : AppTheme.textSecondaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? item.color : AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: widget.isCollapsed
          ? const Icon(
              Icons.account_circle,
              size: 32,
              color: AppTheme.textSecondaryColor,
            )
          : Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      Text(
                        'Research Scientist',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle profile menu
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.textSecondaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String description;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });
}

