import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/models/activity_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'add_activity_screen.dart';
import 'widgets/activity_list_item.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  ActivityType? _selectedFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadActivities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadActivities() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    if (authProvider.user != null) {
      activityProvider.loadActivities(authProvider.user!.id);
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      if (index == 0) {
        _selectedFilter = null;
      } else {
        _selectedFilter = ActivityType.values[index - 1];
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<ActivityModel> _getFilteredActivities(List<ActivityModel> activities) {
    var filtered = activities;

    // Apply type filter
    if (_selectedFilter != null) {
      filtered = filtered
          .where((activity) => activity.type == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((activity) {
        return activity.type.displayName.toLowerCase().contains(_searchQuery) ||
            activity.notes?.toLowerCase().contains(_searchQuery) == true;
      }).toList();
    }

    return filtered;
  }

  void _navigateToAddActivity() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(
          activityType: _selectedFilter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddActivity,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: _onTabChanged,
          isScrollable: true,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'All'),
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

          return Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomSearchField(
                  controller: _searchController,
                  hint: 'Search activities...',
                  onChanged: _onSearchChanged,
                ),
              ),

              // Activities list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadActivities();
                  },
                  child: _buildActivitiesList(activityProvider),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddActivity,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActivitiesList(ActivityProvider activityProvider) {
    if (activityProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredActivities =
        _getFilteredActivities(activityProvider.activities);

    if (filteredActivities.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        return ActivityListItem(
          activity: activity,
          onEdit: () => _editActivity(activity),
          onDelete: () => _deleteActivity(activity),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              _selectedFilter != null
                  ? 'No ${_selectedFilter!.displayName.toLowerCase()} activities yet'
                  : 'No activities yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Start tracking your health activities to see them here',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Add Activity',
              onPressed: _navigateToAddActivity,
              icon: Icons.add,
              width: 200.w,
            ),
          ],
        ),
      ),
    );
  }

  void _editActivity(ActivityModel activity) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(
          activityType: activity.type,
          activity: activity,
        ),
      ),
    );
  }

  void _deleteActivity(ActivityModel activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: Text(
            'Are you sure you want to delete this ${activity.type.displayName.toLowerCase()} activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              final activityProvider =
                  Provider.of<ActivityProvider>(context, listen: false);
              final success =
                  await activityProvider.deleteActivity(activity.id);

              if (success && mounted) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Activity deleted successfully'),
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                );
              }
            },
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.accentColor)),
          ),
        ],
      ),
    );
  }
}
