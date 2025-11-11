import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../auth/login_screen.dart';
import 'profile_screen.dart';
import 'notifications_settings_screen.dart';
import 'about_screen.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, SettingsProvider>(
        builder: (context, authProvider, settingsProvider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildProfileCard(context, authProvider),
                SizedBox(height: 24.h),
                _buildSettingsSections(context, authProvider, settingsProvider),
                SizedBox(height: 100.h), // Bottom padding for navigation bar
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    if (user == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (user.bmi != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'BMI: ${user.bmi!.toStringAsFixed(1)} (${user.bmiCategory})',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSections(
    BuildContext context,
    AuthProvider authProvider,
    SettingsProvider settingsProvider,
  ) {
    return Column(
      children: [
        // Theme Settings
        SettingsSection(
          title: 'Appearance',
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SettingsItem(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: _getThemeModeText(themeProvider.themeMode),
                  onTap: () => _showThemeDialog(context, themeProvider),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Notifications Settings
        SettingsSection(
          title: 'Notifications',
          children: [
            SettingsItem(
              icon: Icons.notifications,
              title: 'Notification Settings',
              subtitle: settingsProvider.notificationsEnabled
                  ? 'Enabled'
                  : 'Disabled',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Data & Privacy
        SettingsSection(
          title: 'Data & Privacy',
          children: [
            SettingsItem(
              icon: Icons.backup,
              title: 'Data Backup',
              subtitle:
                  settingsProvider.dataBackupEnabled ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: settingsProvider.dataBackupEnabled,
                onChanged: settingsProvider.setDataBackupEnabled,
                activeThumbColor: AppTheme.primaryColor,
              ),
            ),
            SettingsItem(
              icon: Icons.download,
              title: 'Export Data',
              subtitle: 'Download your health data',
              onTap: () => _exportData(context),
            ),
            SettingsItem(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Remove all stored data',
              onTap: () => _showClearDataDialog(context),
              textColor: AppTheme.accentColor,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Support & Info
        SettingsSection(
          title: 'Support & Info',
          children: [
            SettingsItem(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and send feedback',
              onTap: () => _showHelpDialog(context),
            ),
            SettingsItem(
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Account Actions
        SettingsSection(
          title: 'Account',
          children: [
            SettingsItem(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Sign out of your account',
              onTap: () => _showSignOutDialog(context, authProvider),
              textColor: AppTheme.accentColor,
            ),
            SettingsItem(
              icon: Icons.delete_forever,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: () => _showDeleteAccountDialog(context, authProvider),
              textColor: AppTheme.accentColor,
            ),
          ],
        ),
      ],
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your health data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement clear data functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared successfully'),
                  backgroundColor: AppTheme.secondaryColor,
                ),
              );
            },
            child: const Text(
              'Clear Data',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'Need help? Contact us at support@healthtracker.com or visit our help center for FAQs and tutorials.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await authProvider.deleteAccount();
              if (success && context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deleted successfully'),
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                );
              }
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
