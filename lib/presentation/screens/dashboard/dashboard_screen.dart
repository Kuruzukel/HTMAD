import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/models/activity_model.dart';
import '../activities/add_activity_screen.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/daily_goals_card.dart';
import 'widgets/quick_actions_card.dart';
import 'widgets/recent_activities_card.dart';
import 'widgets/motivational_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(
      context,
      listen: false,
    );

    if (authProvider.user != null) {
      activityProvider.loadActivities(authProvider.user!.id);
    }
  }

  void _navigateToAddActivity(ActivityType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(activityType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, ActivityProvider>(
        builder: (context, authProvider, activityProvider, child) {
          if (authProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DashboardHeader(user: authProvider.user!),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DailyGoalsCard(
                          user: authProvider.user!,
                          activityProvider: activityProvider,
                        ),
                        SizedBox(height: 16.h),
                        QuickActionsCard(
                          onWaterTap: () =>
                              _navigateToAddActivity(ActivityType.water),
                          onExerciseTap: () =>
                              _navigateToAddActivity(ActivityType.exercise),
                          onSleepTap: () =>
                              _navigateToAddActivity(ActivityType.sleep),
                          onMealTap: () =>
                              _navigateToAddActivity(ActivityType.meal),
                        ),
                        SizedBox(height: 16.h),
                        const MotivationalCard(),
                        SizedBox(height: 16.h),
                        RecentActivitiesCard(
                          activities: activityProvider.todayActivities,
                          isLoading: activityProvider.isLoading,
                        ),
                        SizedBox(
                          height: 100.h,
                        ), // Bottom padding for navigation bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
