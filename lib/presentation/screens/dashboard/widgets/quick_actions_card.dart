import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class QuickActionsCard extends StatelessWidget {
  final VoidCallback onWaterTap;
  final VoidCallback onExerciseTap;
  final VoidCallback onSleepTap;
  final VoidCallback onMealTap;

  const QuickActionsCard({
    super.key,
    required this.onWaterTap,
    required this.onExerciseTap,
    required this.onSleepTap,
    required this.onMealTap,
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
                  Icons.flash_on,
                  color: AppTheme.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: '💧',
                    title: 'Add Water',
                    subtitle: 'Log intake',
                    color: Colors.blue,
                    onTap: onWaterTap,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildActionButton(
                    icon: '🏃‍♂️',
                    title: 'Add Exercise',
                    subtitle: 'Log workout',
                    color: Colors.orange,
                    onTap: onExerciseTap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: '😴',
                    title: 'Add Sleep',
                    subtitle: 'Log rest',
                    color: Colors.purple,
                    onTap: onSleepTap,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildActionButton(
                    icon: '🍽️',
                    title: 'Add Meal',
                    subtitle: 'Log food',
                    color: Colors.green,
                    onTap: onMealTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 32.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
