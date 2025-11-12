import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/activity_model.dart';
import '../../../../data/providers/activity_provider.dart';

class DailyGoalsCard extends StatelessWidget {
  final UserModel user;
  final ActivityProvider activityProvider;

  const DailyGoalsCard({
    super.key,
    required this.user,
    required this.activityProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                Icon(
                  Icons.track_changes,
                  color: AppTheme.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Today\'s Goals',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildGoalItem(
              icon: '💧',
              title: 'Water',
              current: activityProvider.getTodayTotalByType(ActivityType.water),
              goal: user.waterGoal.toDouble(),
              unit: 'glasses',
              color: Colors.blue,
            ),
            SizedBox(height: 16.h),
            _buildGoalItem(
              icon: '🏃‍♂️',
              title: 'Exercise',
              current: activityProvider.getTodayTotalByType(ActivityType.exercise),
              goal: user.exerciseGoal.toDouble(),
              unit: 'minutes',
              color: Colors.orange,
            ),
            SizedBox(height: 16.h),
            _buildGoalItem(
              icon: '😴',
              title: 'Sleep',
              current: activityProvider.getTodayTotalByType(ActivityType.sleep),
              goal: user.sleepGoal.toDouble(),
              unit: 'hours',
              color: Colors.purple,
            ),
            SizedBox(height: 16.h),
            _buildGoalItem(
              icon: '🍽️',
              title: 'Calories',
              current: activityProvider.getTodayTotalByType(ActivityType.meal),
              goal: user.calorieGoal.toDouble(),
              unit: 'cal',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem({
    required String icon,
    required String title,
    required double current,
    required double goal,
    required String unit,
    required Color color,
  }) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).round();
    
    return Column(
      children: [
        Row(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${current.toInt()} / ${goal.toInt()} $unit',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6.h,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ],
    );
  }
}
