import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/settings_provider.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_item.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // General Notifications
                SettingsSection(
                  title: 'General',
                  children: [
                    SettingsItem(
                      icon: Icons.notifications,
                      title: 'Enable Notifications',
                      subtitle: 'Allow the app to send notifications',
                      trailing: Switch(
                        value: settingsProvider.notificationsEnabled,
                        onChanged: settingsProvider.setNotificationsEnabled,
                        activeThumbColor: AppTheme.primaryColor,
                      ),
                    ),
                    SettingsItem(
                      icon: Icons.volume_up,
                      title: 'Sound',
                      subtitle: 'Play sound with notifications',
                      trailing: Switch(
                        value: settingsProvider.soundEnabled,
                        onChanged: settingsProvider.notificationsEnabled
                            ? settingsProvider.setSoundEnabled
                            : null,
                        activeThumbColor: AppTheme.primaryColor,
                      ),
                    ),
                    SettingsItem(
                      icon: Icons.vibration,
                      title: 'Vibration',
                      subtitle: 'Vibrate with notifications',
                      trailing: Switch(
                        value: settingsProvider.vibrationEnabled,
                        onChanged: settingsProvider.notificationsEnabled
                            ? settingsProvider.setVibrationEnabled
                            : null,
                        activeThumbColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Activity Reminders
                SettingsSection(
                  title: 'Activity Reminders',
                  children: [
                    SettingsItem(
                      icon: Icons.water_drop,
                      title: 'Water Reminders',
                      subtitle: 'Remind me to drink water',
                      trailing: Switch(
                        value: settingsProvider.waterRemindersEnabled,
                        onChanged: settingsProvider.notificationsEnabled
                            ? settingsProvider.setWaterRemindersEnabled
                            : null,
                        activeThumbColor: Colors.blue,
                      ),
                    ),
                    SettingsItem(
                      icon: Icons.fitness_center,
                      title: 'Exercise Reminders',
                      subtitle: 'Remind me to exercise',
                      trailing: Switch(
                        value: settingsProvider.exerciseRemindersEnabled,
                        onChanged: settingsProvider.notificationsEnabled
                            ? settingsProvider.setExerciseRemindersEnabled
                            : null,
                        activeThumbColor: Colors.orange,
                      ),
                    ),
                    SettingsItem(
                      icon: Icons.bedtime,
                      title: 'Sleep Reminders',
                      subtitle: 'Remind me about bedtime',
                      trailing: Switch(
                        value: settingsProvider.sleepRemindersEnabled,
                        onChanged: settingsProvider.notificationsEnabled
                            ? settingsProvider.setSleepRemindersEnabled
                            : null,
                        activeThumbColor: Colors.purple,
                      ),
                    ),
                    SettingsItem(
                      icon: Icons.restaurant,
                      title: 'Meal Reminders',
                      subtitle: 'Remind me to log meals',
                      trailing: Switch(
                        value: settingsProvider.mealRemindersEnabled,
                        onChanged: settingsProvider.notificationsEnabled
                            ? settingsProvider.setMealRemindersEnabled
                            : null,
                        activeThumbColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Info card
                if (!settingsProvider.notificationsEnabled)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.warningColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Enable notifications to receive reminders and stay on track with your health goals.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
