import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/activity_model.dart';
import '../../../../data/providers/activity_provider.dart';
import '../../../widgets/glassmorphism_container.dart';

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

    return GlassmorphismContainer(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.3),
                      AppTheme.secondaryColor.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.track_changes,
                  color: AppTheme.primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Today\'s Goals',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildGoalItem(
            icon: '💧',
            title: 'Water',
            current: activityProvider.getTodayTotalByType(ActivityType.water),
            goal: user.waterGoal.toDouble(),
            unit: 'glasses',
            color: const Color(0xFF4FC3F7),
          ),
          SizedBox(height: 20.h),
          _buildGoalItem(
            icon: '🏃‍♂️',
            title: 'Exercise',
            current: activityProvider.getTodayTotalByType(ActivityType.exercise),
            goal: user.exerciseGoal.toDouble(),
            unit: 'minutes',
            color: const Color(0xFFFF9800),
          ),
          SizedBox(height: 20.h),
          _buildGoalItem(
            icon: '😴',
            title: 'Sleep',
            current: activityProvider.getTodayTotalByType(ActivityType.sleep),
            goal: user.sleepGoal.toDouble(),
            unit: 'hours',
            color: const Color(0xFF9C27B0),
          ),
          SizedBox(height: 20.h),
          _buildGoalItem(
            icon: '🍽️',
            title: 'Calories',
            current: activityProvider.getTodayTotalByType(ActivityType.meal),
            goal: user.calorieGoal.toDouble(),
            unit: 'cal',
            color: AppTheme.secondaryColor,
          ),
        ],
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
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 22.sp),
                ),
              ),
              SizedBox(width: 14.w),
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
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${current.toInt()} / ${goal.toInt()} $unit',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }
}
