import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/activity_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/providers/activity_provider.dart';

class WeeklySummaryCard extends StatelessWidget {
  final UserModel user;
  final ActivityProvider activityProvider;
  final ActivityType activityType;

  const WeeklySummaryCard({
    super.key,
    required this.user,
    required this.activityProvider,
    required this.activityType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final weeklyData = activityProvider.getWeeklyData(activityType);
    final totalThisWeek = weeklyData.values.fold(0.0, (sum, value) => sum + value);
    final averagePerDay = weeklyData.isNotEmpty ? totalThisWeek / 7 : 0.0;
    final goal = _getGoal();
    final daysMetGoal = weeklyData.values.where((value) => value >= goal).length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getActivityColor().withOpacity(0.1),
              _getActivityColor().withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: _getActivityColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      activityType.icon,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Week\'s ${activityType.displayName}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Track your weekly progress',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark 
                                ? AppTheme.darkTextSecondaryColor 
                                : AppTheme.lightTextSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Total',
                      '${totalThisWeek.toInt()}',
                      _getUnit(),
                      _getActivityColor(),
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Daily Avg',
                      '${averagePerDay.toInt()}',
                      _getUnit(),
                      AppTheme.secondaryColor,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Goals Met',
                      '$daysMetGoal',
                      'days',
                      AppTheme.warningColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildWeeklyProgress(weeklyData, goal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress(Map<String, double> weeklyData, double goal) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Progress',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: dayNames.map((day) {
            final value = weeklyData[day] ?? 0.0;
            final progress = goal > 0 ? (value / goal).clamp(0.0, 1.0) : 0.0;
            final isGoalMet = value >= goal;
            
            return Column(
              children: [
                Container(
                  width: 32.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: _getActivityColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 32.w,
                        height: 60.h * progress,
                        decoration: BoxDecoration(
                          color: isGoalMet 
                              ? AppTheme.secondaryColor 
                              : _getActivityColor(),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      if (isGoalMet)
                        Positioned(
                          top: 4.h,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getActivityColor() {
    switch (activityType) {
      case ActivityType.water:
        return Colors.blue;
      case ActivityType.exercise:
        return Colors.orange;
      case ActivityType.sleep:
        return Colors.purple;
      case ActivityType.meal:
        return Colors.green;
    }
  }

  String _getUnit() {
    switch (activityType) {
      case ActivityType.water:
        return 'glasses';
      case ActivityType.exercise:
        return 'min';
      case ActivityType.sleep:
        return 'hrs';
      case ActivityType.meal:
        return 'cal';
    }
  }

  double _getGoal() {
    switch (activityType) {
      case ActivityType.water:
        return user.waterGoal.toDouble();
      case ActivityType.exercise:
        return user.exerciseGoal.toDouble();
      case ActivityType.sleep:
        return user.sleepGoal.toDouble();
      case ActivityType.meal:
        return user.calorieGoal.toDouble();
    }
  }
}
