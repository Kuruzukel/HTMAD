import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: children.map((child) {
              final index = children.indexOf(child);
              final isLast = index == children.length - 1;
              
              return Column(
                children: [
                  child,
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark 
                          ? Colors.grey.shade700 
                          : Colors.grey.shade200,
                      indent: 16.w,
                      endIndent: 16.w,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
