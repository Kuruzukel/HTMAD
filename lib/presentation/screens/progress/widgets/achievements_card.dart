import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key});

  static final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'First Step',
      'description': 'Log your first activity',
      'icon': '🎯',
      'unlocked': true,
    },
    {
      'title': 'Hydration Hero',
      'description': 'Drink 8 glasses of water in a day',
      'icon': '💧',
      'unlocked': true,
    },
    {
      'title': 'Workout Warrior',
      'description': 'Exercise for 30 minutes',
      'icon': '🏃‍♂️',
      'unlocked': false,
    },
    {
      'title': 'Sleep Champion',
      'description': 'Get 8 hours of sleep',
      'icon': '😴',
      'unlocked': false,
    },
    {
      'title': 'Consistency King',
      'description': 'Log activities for 7 days straight',
      'icon': '👑',
      'unlocked': false,
    },
    {
      'title': 'Health Master',
      'description': 'Meet all daily goals for a week',
      'icon': '🏆',
      'unlocked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final unlockedAchievements = _achievements.where((a) => a['unlocked'] == true).toList();
    final lockedAchievements = _achievements.where((a) => a['unlocked'] == false).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: AppTheme.warningColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${unlockedAchievements.length}/${_achievements.length}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Progress bar
            Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: unlockedAchievements.length / _achievements.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            
            // Unlocked achievements
            if (unlockedAchievements.isNotEmpty) ...[
              Text(
                'Unlocked (${unlockedAchievements.length})',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryColor,
                ),
              ),
              SizedBox(height: 12.h),
              ...unlockedAchievements.map((achievement) => 
                _buildAchievementItem(achievement, true)),
              SizedBox(height: 16.h),
            ],
            
            // Locked achievements
            if (lockedAchievements.isNotEmpty) ...[
              Text(
                'Locked (${lockedAchievements.length})',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              ...lockedAchievements.map((achievement) => 
                _buildAchievementItem(achievement, false)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement, bool unlocked) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: unlocked 
            ? AppTheme.secondaryColor.withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: unlocked 
              ? AppTheme.secondaryColor.withOpacity(0.3)
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: unlocked 
                  ? AppTheme.secondaryColor.withOpacity(0.2)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Center(
              child: unlocked
                  ? Text(
                      achievement['icon'],
                      style: TextStyle(fontSize: 24.sp),
                    )
                  : Icon(
                      Icons.lock,
                      color: Colors.grey[500],
                      size: 24.sp,
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: unlocked 
                        ? AppTheme.secondaryColor
                        : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  achievement['description'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: unlocked 
                        ? Colors.grey[700]
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
        ],
      ),
    );
  }
}
