import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/activity_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/providers/activity_provider.dart';

class ProgressChartCard extends StatefulWidget {
  final ActivityProvider activityProvider;
  final ActivityType activityType;
  final UserModel user;

  const ProgressChartCard({
    super.key,
    required this.activityProvider,
    required this.activityType,
    required this.user,
  });

  @override
  State<ProgressChartCard> createState() => _ProgressChartCardState();
}

class _ProgressChartCardState extends State<ProgressChartCard> {
  bool _showWeekly = true;

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
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: _getActivityColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          widget.activityType.icon,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: Text(
                          '${widget.activityType.displayName} Progress',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.darkTextColor
                                : AppTheme.lightTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                ToggleButtons(
                  isSelected: [_showWeekly, !_showWeekly],
                  onPressed: (index) {
                    setState(() {
                      _showWeekly = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  borderWidth: 1.5,
                  borderColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                  selectedBorderColor: AppTheme.primaryColor,
                  selectedColor: Colors.white,
                  fillColor: AppTheme.primaryColor,
                  color: AppTheme.primaryColor,
                  constraints: BoxConstraints(
                    minWidth: 55.w,
                    minHeight: 32.h,
                  ),
                  children: [
                    Text('Week', style: TextStyle(fontSize: 11.sp)),
                    Text('Month', style: TextStyle(fontSize: 11.sp)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 200.h,
              child: _buildChart(),
            ),
            SizedBox(height: 16.h),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final data = _showWeekly
        ? widget.activityProvider.getWeeklyData(widget.activityType)
        : widget.activityProvider.getMonthlyData(widget.activityType);

    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: _getActivityColor(),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final value = rod.toY;
              final unit = _getUnit();
              return BarTooltipItem(
                '${value.toInt()} $unit',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final keys = data.keys.toList();
                if (value.toInt() >= 0 && value.toInt() < keys.length) {
                  final key = keys[value.toInt()];
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      _showWeekly
                          ? key
                          : key.length > 2
                              ? key.substring(0, 2)
                              : key,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40.w,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.entries.map((entry) {
          final index = data.keys.toList().indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                color: _getActivityColor(),
                width: _showWeekly ? 24.w : 12.w,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend() {
    final goal = _getGoal();
    final currentAverage = _getCurrentAverage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(
          'Goal',
          '$goal ${_getUnit()}',
          AppTheme.secondaryColor,
        ),
        _buildLegendItem(
          'Average',
          '${currentAverage.toInt()} ${_getUnit()}',
          _getActivityColor(),
        ),
        _buildLegendItem(
          'Best',
          '${_getBestValue().toInt()} ${_getUnit()}',
          AppTheme.warningColor,
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getActivityColor() {
    switch (widget.activityType) {
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
    switch (widget.activityType) {
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
    switch (widget.activityType) {
      case ActivityType.water:
        return widget.user.waterGoal.toDouble();
      case ActivityType.exercise:
        return widget.user.exerciseGoal.toDouble();
      case ActivityType.sleep:
        return widget.user.sleepGoal.toDouble();
      case ActivityType.meal:
        return widget.user.calorieGoal.toDouble();
    }
  }

  double _getMaxY() {
    final data = _showWeekly
        ? widget.activityProvider.getWeeklyData(widget.activityType)
        : widget.activityProvider.getMonthlyData(widget.activityType);

    if (data.isEmpty) return 10;

    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    final goal = _getGoal();

    return (maxValue > goal ? maxValue : goal) * 1.2;
  }

  double _getCurrentAverage() {
    final data = _showWeekly
        ? widget.activityProvider.getWeeklyData(widget.activityType)
        : widget.activityProvider.getMonthlyData(widget.activityType);

    if (data.isEmpty) return 0;

    final total = data.values.reduce((a, b) => a + b);
    return total / data.length;
  }

  double _getBestValue() {
    final data = _showWeekly
        ? widget.activityProvider.getWeeklyData(widget.activityType)
        : widget.activityProvider.getMonthlyData(widget.activityType);

    if (data.isEmpty) return 0;

    return data.values.reduce((a, b) => a > b ? a : b);
  }
}
