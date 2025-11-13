import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/models/activity_model.dart';
import 'widgets/progress_chart_card.dart';
import 'widgets/weekly_summary_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ActivityType _selectedType = ActivityType.water;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    if (authProvider.user != null) {
      activityProvider.loadActivities(authProvider.user!.id);
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedType = ActivityType.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          onTap: _onTabChanged,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Water'),
            Tab(text: 'Exercise'),
            Tab(text: 'Sleep'),
            Tab(text: 'Meals'),
          ],
        ),
      ),
      body: Consumer2<AuthProvider, ActivityProvider>(
        builder: (context, authProvider, activityProvider, child) {
          if (authProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeeklySummaryCard(
                    user: authProvider.user!,
                    activityProvider: activityProvider,
                    activityType: _selectedType,
                  ),
                  SizedBox(height: 16.h),
                  ProgressChartCard(
                    activityProvider: activityProvider,
                    activityType: _selectedType,
                    user: authProvider.user!,
                  ),
                  SizedBox(height: 100.h), // Bottom padding for navigation bar
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
