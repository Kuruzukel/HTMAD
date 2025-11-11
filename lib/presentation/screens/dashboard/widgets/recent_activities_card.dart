import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/activity_model.dart';

class RecentActivitiesCard extends StatelessWidget {
  final List<ActivityModel> activities;
  final bool isLoading;

  const RecentActivitiesCard({
    super.key,
    required this.activities,
    this.isLoading = false,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: AppTheme.primaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Recent Activities',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                      ),
                    ),
                  ],
                ),
                if (activities.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // Navigate to full activities list
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
              )
            else if (activities.isEmpty)
              _buildEmptyState()
            else
              _buildActivitiesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No activities yet today',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start logging your health activities to see them here',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList() {
    final recentActivities = activities.take(5).toList();
    
    return Column(
      children: recentActivities.map((activity) => _buildActivityItem(activity)).toList(),
    );
  }

  Widget _buildActivityItem(ActivityModel activity) {
    final color = _getActivityColor(activity.type);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                activity.type.icon,
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.type.displayName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  activity.formattedValue,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.timeFormatted,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
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
}
