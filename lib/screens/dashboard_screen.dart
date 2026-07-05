import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

// Import screens
import 'mentor_chat_screen.dart';
import 'career_simulator_screen.dart';
import 'branch_simulator_screen.dart';
import 'academic_tracker_screen.dart';
import 'planner_screen.dart';
import 'gap_analyzer_screen.dart';
import 'learning_hub_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    // Define navigation items with localized titles
    final navItems = [
      {'title': appProvider.translate('ai_mentor'), 'icon': Icons.smart_toy},
      {'title': appProvider.translate('career_simulator'), 'icon': Icons.electric_bolt},
      {'title': appProvider.translate('branch_compare'), 'icon': Icons.compare_arrows},
      {'title': appProvider.translate('academic_tracker'), 'icon': Icons.school},
      {'title': appProvider.translate('semester_planner'), 'icon': Icons.event_available},
      {'title': appProvider.translate('skill_gap'), 'icon': Icons.analytics},
      {'title': appProvider.translate('learning_hub'), 'icon': Icons.play_circle},
      {'title': appProvider.translate('interview_reviews'), 'icon': Icons.rate_review},
      {'title': appProvider.translate('settings'), 'icon': Icons.tune},
    ];

    // Select view based on current index
    Widget getActiveView(int index) {
      switch (index) {
        case 0:
          return const MentorChatScreen();
        case 1:
          return const CareerSimulatorScreen();
        case 2:
          return const BranchSimulatorScreen();
        case 3:
          return const AcademicTrackerScreen();
        case 4:
          return const PlannerScreen();
        case 5:
          return const GapAnalyzerScreen();
        case 6:
          return const LearningHubScreen();
        case 7:
          return const ReviewScreen();
        case 8:
          return const SettingsScreen();
        default:
          return const MentorChatScreen();
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              // Sidebar Navigation for Desktop/Web
              if (isDesktop)
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border(
                      right: BorderSide(color: AppTheme.borderOverlay, width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Sidebar Header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                 errorBuilder: (_, __, ___) => Icon(Icons.rocket_launch, color: AppTheme.primaryColor, size: 28),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              appProvider.translate('app_title'),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Navigation List
                      Expanded(
                        child: ListView.builder(
                          itemCount: navItems.length,
                          itemBuilder: (context, i) {
                            final item = navItems[i];
                            final isSelected = appProvider.activePageIndex == i;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  onTap: () => appProvider.setPageIndex(i),
                                  selected: isSelected,
                                  selectedTileColor: AppTheme.primaryColor.withOpacity(0.15),
                                  leading: Icon(
                                    item['icon'] as IconData,
                                    size: 18,
                                    color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                  ),
                                  title: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Sidebar Footer (User Profile Card)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                                child: Text(
                                  appProvider.profile.displayName.isNotEmpty
                                      ? appProvider.profile.displayName[0].toUpperCase()
                                      : 'S',
                                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      appProvider.profile.displayName,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${appProvider.profile.branch} • ${appProvider.profile.currentYear}',
                                      style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Main content area
              Expanded(
                child: Column(
                  children: [
                    // Mobile Top Navbar
                    if (!isDesktop)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          border: Border(
                            bottom: BorderSide(color: AppTheme.borderOverlay, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 26,
                                    height: 26,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(Icons.rocket_launch, color: AppTheme.primaryColor, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  appProvider.translate('app_title'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.person, size: 13, color: AppTheme.primaryColor),
                                  const SizedBox(width: 5),
                                  Text(
                                    appProvider.profile.displayName.isNotEmpty ? appProvider.profile.displayName : 'Student',
                                    style: TextStyle(color: AppTheme.primaryColor, fontSize: 11.5, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Active View with slide-in & fade transitions on tab switches
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.04, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(appProvider.activePageIndex),
                          child: getActiveView(appProvider.activePageIndex),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar for Mobile
      bottomNavigationBar: !isDesktop
          ? Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.borderOverlay, width: 1),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: appProvider.activePageIndex == 0
                    ? 0
                    : (appProvider.activePageIndex == 1
                        ? 1
                        : (appProvider.activePageIndex == 4
                            ? 2
                            : (appProvider.activePageIndex == 7 ? 3 : 4))),
                onTap: (index) {
                  if (index == 0) appProvider.setPageIndex(0); // Mentor
                  if (index == 1) appProvider.setPageIndex(1); // Career Simulation
                  if (index == 2) appProvider.setPageIndex(4); // Planner
                  if (index == 3) appProvider.setPageIndex(7); // Reviews
                  if (index == 4) appProvider.setPageIndex(8); // Settings
                },
                backgroundColor: AppTheme.surfaceColor,
                selectedItemColor: AppTheme.primaryColor,
                unselectedItemColor: AppTheme.textSecondary,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.smart_toy, size: 16),
                    label: appProvider.translate('ai_mentor'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.electric_bolt, size: 16),
                    label: appProvider.translate('career_simulator'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.event_available, size: 16),
                    label: appProvider.translate('semester_planner'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.rate_review, size: 16),
                    label: appProvider.translate('interview_reviews'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.tune, size: 16),
                    label: appProvider.translate('settings'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
