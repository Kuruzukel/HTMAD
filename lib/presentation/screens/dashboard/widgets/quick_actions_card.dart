import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../widgets/glassmorphism_container.dart';

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
                      AppTheme.warningColor.withValues(alpha: 0.3),
                      AppTheme.primaryColor.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.flash_on,
                  color: AppTheme.warningColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Quick Actions',
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
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: '💧',
                  title: 'Water',
                  subtitle: 'Log intake',
                  color: const Color(0xFF4FC3F7),
                  onTap: onWaterTap,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _buildActionButton(
                  icon: '🏃‍♂️',
                  title: 'Exercise',
                  subtitle: 'Log workout',
                  color: const Color(0xFFFF9800),
                  onTap: onExerciseTap,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: '😴',
                  title: 'Sleep',
                  subtitle: 'Log rest',
                  color: const Color(0xFF9C27B0),
                  onTap: onSleepTap,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _buildActionButton(
                  icon: '🍽️',
                  title: 'Meal',
                  subtitle: 'Log food',
                  color: AppTheme.secondaryColor,
                  onTap: onMealTap,
                ),
              ),
            ],
          ),
        ],
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
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: color.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 36.sp),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
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
