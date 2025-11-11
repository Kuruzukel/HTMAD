import '../models/activity_model.dart';
import '../../core/services/database_service.dart';

class ActivityRepository {
  static const String _tableName = 'activities';

  Future<ActivityModel?> getActivityById(String id) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return ActivityModel.fromMap(results.first);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get activity: $e');
    }
  }

  Future<List<ActivityModel>> getActivitiesByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    ActivityType? type,
    int? limit,
  }) async {
    try {
      String whereClause = 'user_id = ?';
      List<dynamic> whereArgs = [userId];

      if (startDate != null) {
        whereClause += ' AND date >= ?';
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      }

      if (endDate != null) {
        whereClause += ' AND date <= ?';
        whereArgs.add(endDate.toIso8601String().split('T')[0]);
      }

      if (type != null) {
        whereClause += ' AND type = ?';
        whereArgs.add(type.name);
      }

      final results = await DatabaseService.query(
        _tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'date DESC, time DESC',
        limit: limit,
      );

      return results.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get activities by user: $e');
    }
  }

  Future<List<ActivityModel>> getActivitiesByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];
      final results = await DatabaseService.query(
        _tableName,
        where: 'user_id = ? AND date = ?',
        whereArgs: [userId, dateString],
        orderBy: 'time DESC',
      );

      return results.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get activities by date: $e');
    }
  }

  Future<List<ActivityModel>> getActivitiesByType(
    String userId,
    ActivityType type, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      String whereClause = 'user_id = ? AND type = ?';
      List<dynamic> whereArgs = [userId, type.name];

      if (startDate != null) {
        whereClause += ' AND date >= ?';
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      }

      if (endDate != null) {
        whereClause += ' AND date <= ?';
        whereArgs.add(endDate.toIso8601String().split('T')[0]);
      }

      final results = await DatabaseService.query(
        _tableName,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'date DESC, time DESC',
        limit: limit,
      );

      return results.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get activities by type: $e');
    }
  }

  Future<void> createActivity(ActivityModel activity) async {
    try {
      await DatabaseService.insert(_tableName, activity.toMap());

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        activity.id,
        'CREATE',
        activity.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  Future<void> updateActivity(ActivityModel activity) async {
    try {
      final updatedActivity = activity.copyWith(
        updatedAt: DateTime.now(),
        synced: false,
      );

      await DatabaseService.update(
        _tableName,
        updatedActivity.toMap(),
        where: 'id = ?',
        whereArgs: [activity.id],
      );

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        activity.id,
        'UPDATE',
        updatedActivity.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  Future<void> deleteActivity(String id) async {
    try {
      await DatabaseService.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        id,
        'DELETE',
        {'id': id},
      );
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  Future<void> deleteActivitiesByUser(String userId) async {
    try {
      await DatabaseService.delete(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw Exception('Failed to delete activities by user: $e');
    }
  }

  Future<double> getTotalValueByTypeAndDate(
    String userId,
    ActivityType type,
    DateTime date,
  ) async {
    try {
      final activities = await getActivitiesByDate(userId, date);
      final typeActivities = activities.where((a) => a.type == type);
      return typeActivities.fold<double>(
          0.0, (sum, activity) => sum + activity.value);
    } catch (e) {
      throw Exception('Failed to get total value by type and date: $e');
    }
  }

  Future<Map<String, double>> getWeeklyTotals(
    String userId,
    ActivityType type,
    DateTime weekStart,
  ) async {
    try {
      final weekEnd = weekStart.add(const Duration(days: 6));
      final activities = await getActivitiesByType(
        userId,
        type,
        startDate: weekStart,
        endDate: weekEnd,
      );

      final weeklyTotals = <String, double>{};
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final dayActivities = activities.where((a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day);

        final total =
            dayActivities.fold(0.0, (sum, activity) => sum + activity.value);
        weeklyTotals[dayNames[i]] = total;
      }

      return weeklyTotals;
    } catch (e) {
      throw Exception('Failed to get weekly totals: $e');
    }
  }

  Future<Map<String, double>> getMonthlyTotals(
    String userId,
    ActivityType type,
    DateTime month,
  ) async {
    try {
      final monthStart = DateTime(month.year, month.month, 1);
      final monthEnd = DateTime(month.year, month.month + 1, 0);

      final activities = await getActivitiesByType(
        userId,
        type,
        startDate: monthStart,
        endDate: monthEnd,
      );

      final monthlyTotals = <String, double>{};

      for (int day = 1; day <= monthEnd.day; day++) {
        final date = DateTime(month.year, month.month, day);
        final dayActivities = activities.where((a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day);

        final total =
            dayActivities.fold(0.0, (sum, activity) => sum + activity.value);
        monthlyTotals[day.toString()] = total;
      }

      return monthlyTotals;
    } catch (e) {
      throw Exception('Failed to get monthly totals: $e');
    }
  }

  Future<List<ActivityModel>> getUnsyncedActivities() async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'synced = ?',
        whereArgs: [0],
      );
      return results.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get unsynced activities: $e');
    }
  }

  Future<void> markActivityAsSynced(String id) async {
    try {
      await DatabaseService.update(
        _tableName,
        {'synced': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to mark activity as synced: $e');
    }
  }

  Future<int> getActivityCount(String userId, {ActivityType? type}) async {
    try {
      String whereClause = 'user_id = ?';
      List<dynamic> whereArgs = [userId];

      if (type != null) {
        whereClause += ' AND type = ?';
        whereArgs.add(type.name);
      }

      final results = await DatabaseService.query(
        _tableName,
        where: whereClause,
        whereArgs: whereArgs,
      );

      return results.length;
    } catch (e) {
      throw Exception('Failed to get activity count: $e');
    }
  }
}
