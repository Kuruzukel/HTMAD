import 'package:flutter/foundation.dart';

import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

class ActivityProvider extends ChangeNotifier {
  List<ActivityModel> _activities = [];
  final Map<String, List<ActivityModel>> _activitiesByDate = {};
  bool _isLoading = false;
  String? _errorMessage;
  
  final ActivityRepository _activityRepository = ActivityRepository();
  
  List<ActivityModel> get activities => _activities;
  Map<String, List<ActivityModel>> get activitiesByDate => _activitiesByDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Get activities for today
  List<ActivityModel> get todayActivities {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _activitiesByDate[todayKey] ?? [];
  }
  
  // Get activities by type for today
  List<ActivityModel> getTodayActivitiesByType(ActivityType type) {
    return todayActivities.where((activity) => activity.type == type).toList();
  }
  
  // Get total value for a specific type today
  double getTodayTotalByType(ActivityType type) {
    final typeActivities = getTodayActivitiesByType(type);
    return typeActivities.fold(0.0, (sum, activity) => sum + activity.value);
  }
  
  // Get activities for a specific date
  List<ActivityModel> getActivitiesForDate(DateTime date) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _activitiesByDate[dateKey] ?? [];
  }
  
  // Get activities for a date range
  List<ActivityModel> getActivitiesForDateRange(DateTime startDate, DateTime endDate) {
    return _activities.where((activity) {
      return activity.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
             activity.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
  
  // Get weekly data for charts
  Map<String, double> getWeeklyData(ActivityType type) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekData = <String, double>{};
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayActivities = _activitiesByDate[dateKey] ?? [];
      final total = dayActivities
          .where((activity) => activity.type == type)
          .fold(0.0, (sum, activity) => sum + activity.value);
      
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      weekData[dayNames[i]] = total;
    }
    
    return weekData;
  }
  
  // Get monthly data for charts
  Map<String, double> getMonthlyData(ActivityType type) {
    final now = DateTime.now();
    final monthData = <String, double>{};
    
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayActivities = _activitiesByDate[dateKey] ?? [];
      final total = dayActivities
          .where((activity) => activity.type == type)
          .fold(0.0, (sum, activity) => sum + activity.value);
      
      monthData['${date.day}'] = total;
    }
    
    return monthData;
  }
  
  Future<void> loadActivities(String userId, {DateTime? startDate, DateTime? endDate}) async {
    _setLoading(true);
    
    try {
      _activities = await _activityRepository.getActivitiesByUser(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      _groupActivitiesByDate();
      _clearError();
    } catch (e) {
      _setError('Failed to load activities: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> addActivity(ActivityModel activity) async {
    _setLoading(true);
    
    try {
      await _activityRepository.createActivity(activity);
      _activities.add(activity);
      _groupActivitiesByDate();
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to add activity: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateActivity(ActivityModel activity) async {
    _setLoading(true);
    
    try {
      await _activityRepository.updateActivity(activity);
      final index = _activities.indexWhere((a) => a.id == activity.id);
      if (index != -1) {
        _activities[index] = activity;
        _groupActivitiesByDate();
      }
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to update activity: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> deleteActivity(String activityId) async {
    _setLoading(true);
    
    try {
      await _activityRepository.deleteActivity(activityId);
      _activities.removeWhere((activity) => activity.id == activityId);
      _groupActivitiesByDate();
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to delete activity: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Quick add methods for common activities
  Future<bool> addWaterIntake(String userId, double glasses) async {
    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ActivityType.water,
      value: glasses,
      unit: 'glasses',
      date: DateTime.now(),
      time: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addActivity(activity);
  }
  
  Future<bool> addExercise(String userId, double minutes, String? notes) async {
    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ActivityType.exercise,
      value: minutes,
      unit: 'minutes',
      date: DateTime.now(),
      time: DateTime.now(),
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addActivity(activity);
  }
  
  Future<bool> addSleep(String userId, double hours) async {
    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ActivityType.sleep,
      value: hours,
      unit: 'hours',
      date: DateTime.now(),
      time: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addActivity(activity);
  }
  
  Future<bool> addMeal(String userId, double calories, String? notes) async {
    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ActivityType.meal,
      value: calories,
      unit: 'calories',
      date: DateTime.now(),
      time: DateTime.now(),
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addActivity(activity);
  }
  
  void _groupActivitiesByDate() {
    _activitiesByDate.clear();
    
    for (final activity in _activities) {
      final dateKey = '${activity.date.year}-${activity.date.month.toString().padLeft(2, '0')}-${activity.date.day.toString().padLeft(2, '0')}';
      
      if (_activitiesByDate.containsKey(dateKey)) {
        _activitiesByDate[dateKey]!.add(activity);
      } else {
        _activitiesByDate[dateKey] = [activity];
      }
    }
    
    // Sort activities within each date
    _activitiesByDate.forEach((key, activities) {
      activities.sort((a, b) => b.time.compareTo(a.time));
    });
  }
  
  void clearActivities() {
    _activities.clear();
    _activitiesByDate.clear();
    _clearError();
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _clearError();
  }
}
