import 'package:flutter/foundation.dart';

import '../models/reminder_model.dart';
import '../repositories/reminder_repository.dart';
import '../../core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  final ReminderRepository _reminderRepository = ReminderRepository();
  
  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<ReminderModel> get activeReminders => 
      _reminders.where((reminder) => reminder.isActive).toList();
  
  List<ReminderModel> getRemindersByType(ReminderType type) =>
      _reminders.where((reminder) => reminder.type == type).toList();
  
  Future<void> loadReminders(String userId) async {
    _setLoading(true);
    
    try {
      _reminders = await _reminderRepository.getRemindersByUser(userId);
      _clearError();
    } catch (e) {
      _setError('Failed to load reminders: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> addReminder(ReminderModel reminder) async {
    _setLoading(true);
    
    try {
      await _reminderRepository.createReminder(reminder);
      _reminders.add(reminder);
      
      // Schedule notification if active
      if (reminder.isActive) {
        await _scheduleNotification(reminder);
      }
      
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to add reminder: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateReminder(ReminderModel reminder) async {
    _setLoading(true);
    
    try {
      await _reminderRepository.updateReminder(reminder);
      final index = _reminders.indexWhere((r) => r.id == reminder.id);
      if (index != -1) {
        // Cancel old notification
        await NotificationService.cancelNotification(int.parse(_reminders[index].id));
        
        _reminders[index] = reminder;
        
        // Schedule new notification if active
        if (reminder.isActive) {
          await _scheduleNotification(reminder);
        }
      }
      
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to update reminder: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> deleteReminder(String reminderId) async {
    _setLoading(true);
    
    try {
      await _reminderRepository.deleteReminder(reminderId);
      
      // Cancel notification
      await NotificationService.cancelNotification(int.parse(reminderId));
      
      _reminders.removeWhere((reminder) => reminder.id == reminderId);
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to delete reminder: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> toggleReminder(String reminderId) async {
    final reminder = _reminders.firstWhere((r) => r.id == reminderId);
    final updatedReminder = reminder.copyWith(
      isActive: !reminder.isActive,
      updatedAt: DateTime.now(),
    );
    
    return await updateReminder(updatedReminder);
  }
  
  Future<void> _scheduleNotification(ReminderModel reminder) async {
    try {
      final notificationId = int.parse(reminder.id);
      
      switch (reminder.type) {
        case ReminderType.water:
          await NotificationService.scheduleWaterReminder(
            id: notificationId,
            time: reminder.time,
          );
          break;
        case ReminderType.exercise:
          await NotificationService.scheduleExerciseReminder(
            id: notificationId,
            time: reminder.time,
          );
          break;
        case ReminderType.sleep:
          await NotificationService.scheduleSleepReminder(
            id: notificationId,
            time: reminder.time,
          );
          break;
        case ReminderType.meal:
          await NotificationService.scheduleMealReminder(
            id: notificationId,
            time: reminder.time,
            mealType: reminder.title,
          );
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule notification: $e');
      }
    }
  }
  
  // Quick create methods for common reminders
  Future<bool> createWaterReminder(
    String userId,
    DateTime time,
    List<int> days,
  ) async {
    final reminder = ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ReminderType.water,
      title: 'Hydration Reminder',
      message: 'Time to drink some water! Stay hydrated throughout the day.',
      time: time,
      days: days,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addReminder(reminder);
  }
  
  Future<bool> createExerciseReminder(
    String userId,
    DateTime time,
    List<int> days,
  ) async {
    final reminder = ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ReminderType.exercise,
      title: 'Exercise Time',
      message: 'Ready for your workout? Let\'s get moving!',
      time: time,
      days: days,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addReminder(reminder);
  }
  
  Future<bool> createSleepReminder(
    String userId,
    DateTime time,
    List<int> days,
  ) async {
    final reminder = ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ReminderType.sleep,
      title: 'Bedtime Reminder',
      message: 'Time to wind down and get ready for bed.',
      time: time,
      days: days,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addReminder(reminder);
  }
  
  Future<bool> createMealReminder(
    String userId,
    String mealType,
    DateTime time,
    List<int> days,
  ) async {
    final reminder = ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: ReminderType.meal,
      title: '$mealType Time',
      message: 'Don\'t forget to log your $mealType!',
      time: time,
      days: days,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return await addReminder(reminder);
  }
  
  Future<void> rescheduleAllReminders() async {
    for (final reminder in activeReminders) {
      await _scheduleNotification(reminder);
    }
  }
  
  Future<void> cancelAllNotifications() async {
    await NotificationService.cancelAllNotifications();
  }
  
  void clearReminders() {
    _reminders.clear();
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
