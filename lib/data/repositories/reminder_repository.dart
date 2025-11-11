import '../models/reminder_model.dart';
import '../../core/services/database_service.dart';

class ReminderRepository {
  static const String _tableName = 'reminders';

  Future<ReminderModel?> getReminderById(String id) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return ReminderModel.fromMap(results.first);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get reminder: $e');
    }
  }

  Future<List<ReminderModel>> getRemindersByUser(String userId) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'type ASC, time ASC',
      );

      return results.map((map) => ReminderModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get reminders by user: $e');
    }
  }

  Future<List<ReminderModel>> getRemindersByType(
    String userId,
    ReminderType type,
  ) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'user_id = ? AND type = ?',
        whereArgs: [userId, type.name],
        orderBy: 'time ASC',
      );

      return results.map((map) => ReminderModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get reminders by type: $e');
    }
  }

  Future<List<ReminderModel>> getActiveReminders(String userId) async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'user_id = ? AND is_active = ?',
        whereArgs: [userId, 1],
        orderBy: 'type ASC, time ASC',
      );

      return results.map((map) => ReminderModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get active reminders: $e');
    }
  }

  Future<List<ReminderModel>> getTodayReminders(String userId) async {
    try {
      final today = DateTime.now().weekday % 7; // Convert to 0-6 format
      final allReminders = await getActiveReminders(userId);

      return allReminders
          .where((reminder) => reminder.days.contains(today))
          .toList();
    } catch (e) {
      throw Exception('Failed to get today reminders: $e');
    }
  }

  Future<void> createReminder(ReminderModel reminder) async {
    try {
      await DatabaseService.insert(_tableName, reminder.toMap());

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        reminder.id,
        'CREATE',
        reminder.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to create reminder: $e');
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      final updatedReminder = reminder.copyWith(
        updatedAt: DateTime.now(),
        synced: false,
      );

      await DatabaseService.update(
        _tableName,
        updatedReminder.toMap(),
        where: 'id = ?',
        whereArgs: [reminder.id],
      );

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(
        _tableName,
        reminder.id,
        'UPDATE',
        updatedReminder.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await DatabaseService.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      // Add to sync queue for Firebase sync
      await DatabaseService.addToSyncQueue(_tableName, id, 'DELETE', {
        'id': id,
      });
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  Future<void> deleteRemindersByUser(String userId) async {
    try {
      await DatabaseService.delete(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw Exception('Failed to delete reminders by user: $e');
    }
  }

  Future<void> toggleReminderStatus(String id) async {
    try {
      final reminder = await getReminderById(id);
      if (reminder != null) {
        final updatedReminder = reminder.copyWith(
          isActive: !reminder.isActive,
          updatedAt: DateTime.now(),
          synced: false,
        );

        await DatabaseService.update(
          _tableName,
          updatedReminder.toMap(),
          where: 'id = ?',
          whereArgs: [id],
        );

        // Add to sync queue for Firebase sync
        await DatabaseService.addToSyncQueue(
          _tableName,
          id,
          'UPDATE',
          updatedReminder.toMap(),
        );
      }
    } catch (e) {
      throw Exception('Failed to toggle reminder status: $e');
    }
  }

  Future<void> deactivateAllReminders(String userId) async {
    try {
      await DatabaseService.update(
        _tableName,
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
          'synced': 0,
        },
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw Exception('Failed to deactivate all reminders: $e');
    }
  }

  Future<void> activateAllReminders(String userId) async {
    try {
      await DatabaseService.update(
        _tableName,
        {
          'is_active': 1,
          'updated_at': DateTime.now().toIso8601String(),
          'synced': 0,
        },
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw Exception('Failed to activate all reminders: $e');
    }
  }

  Future<List<ReminderModel>> getUnsyncedReminders() async {
    try {
      final results = await DatabaseService.query(
        _tableName,
        where: 'synced = ?',
        whereArgs: [0],
      );
      return results.map((map) => ReminderModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get unsynced reminders: $e');
    }
  }

  Future<void> markReminderAsSynced(String id) async {
    try {
      await DatabaseService.update(
        _tableName,
        {'synced': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to mark reminder as synced: $e');
    }
  }

  Future<int> getReminderCount(
    String userId, {
    ReminderType? type,
    bool? isActive,
  }) async {
    try {
      String whereClause = 'user_id = ?';
      List<dynamic> whereArgs = [userId];

      if (type != null) {
        whereClause += ' AND type = ?';
        whereArgs.add(type.name);
      }

      if (isActive != null) {
        whereClause += ' AND is_active = ?';
        whereArgs.add(isActive ? 1 : 0);
      }

      final results = await DatabaseService.query(
        _tableName,
        where: whereClause,
        whereArgs: whereArgs,
      );

      return results.length;
    } catch (e) {
      throw Exception('Failed to get reminder count: $e');
    }
  }

  Future<List<ReminderModel>> getUpcomingReminders(
    String userId, {
    int hours = 24,
  }) async {
    try {
      final now = DateTime.now();
      final cutoff = now.add(Duration(hours: hours));
      final activeReminders = await getActiveReminders(userId);

      return activeReminders.where((reminder) {
        final nextTrigger = reminder.nextTriggerTime;
        return nextTrigger != null &&
            nextTrigger.isAfter(now) &&
            nextTrigger.isBefore(cutoff);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get upcoming reminders: $e');
    }
  }
}
