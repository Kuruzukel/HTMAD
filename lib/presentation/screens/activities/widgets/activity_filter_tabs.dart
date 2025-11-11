import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/activity_model.dart';

class ActivityFilterTabs extends StatelessWidget {
  final ActivityType? selectedType;
  final Function(ActivityType?) onTypeSelected;

  const ActivityFilterTabs({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildFilterChip(
            label: 'All',
            icon: Icons.all_inclusive,
            isSelected: selectedType == null,
            onTap: () => onTypeSelected(null),
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            label: 'Water',
            icon: Icons.water_drop,
            isSelected: selectedType == ActivityType.water,
            onTap: () => onTypeSelected(ActivityType.water),
            color: Colors.blue,
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            label: 'Exercise',
            icon: Icons.fitness_center,
            isSelected: selectedType == ActivityType.exercise,
            onTap: () => onTypeSelected(ActivityType.exercise),
            color: Colors.orange,
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            label: 'Sleep',
            icon: Icons.bedtime,
            isSelected: selectedType == ActivityType.sleep,
            onTap: () => onTypeSelected(ActivityType.sleep),
            color: Colors.purple,
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            label: 'Meals',
            icon: Icons.restaurant,
            isSelected: selectedType == ActivityType.meal,
            onTap: () => onTypeSelected(ActivityType.meal),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppTheme.primaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? Colors.white : chipColor,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : chipColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
