import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _waterRemindersEnabled = true;
  bool _exerciseRemindersEnabled = true;
  bool _sleepRemindersEnabled = true;
  bool _mealRemindersEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _dataBackupEnabled = true;
  String _language = 'en';
  String _dateFormat = 'dd/MM/yyyy';
  String _timeFormat = '24h';
  
  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get waterRemindersEnabled => _waterRemindersEnabled;
  bool get exerciseRemindersEnabled => _exerciseRemindersEnabled;
  bool get sleepRemindersEnabled => _sleepRemindersEnabled;
  bool get mealRemindersEnabled => _mealRemindersEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get dataBackupEnabled => _dataBackupEnabled;
  String get language => _language;
  String get dateFormat => _dateFormat;
  String get timeFormat => _timeFormat;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _waterRemindersEnabled = prefs.getBool('water_reminders_enabled') ?? true;
      _exerciseRemindersEnabled = prefs.getBool('exercise_reminders_enabled') ?? true;
      _sleepRemindersEnabled = prefs.getBool('sleep_reminders_enabled') ?? true;
      _mealRemindersEnabled = prefs.getBool('meal_reminders_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _dataBackupEnabled = prefs.getBool('data_backup_enabled') ?? true;
      _language = prefs.getString('language') ?? 'en';
      _dateFormat = prefs.getString('date_format') ?? 'dd/MM/yyyy';
      _timeFormat = prefs.getString('time_format') ?? '24h';
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load settings: $e');
      }
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('notifications_enabled', _notificationsEnabled);
      await prefs.setBool('water_reminders_enabled', _waterRemindersEnabled);
      await prefs.setBool('exercise_reminders_enabled', _exerciseRemindersEnabled);
      await prefs.setBool('sleep_reminders_enabled', _sleepRemindersEnabled);
      await prefs.setBool('meal_reminders_enabled', _mealRemindersEnabled);
      await prefs.setBool('sound_enabled', _soundEnabled);
      await prefs.setBool('vibration_enabled', _vibrationEnabled);
      await prefs.setBool('data_backup_enabled', _dataBackupEnabled);
      await prefs.setString('language', _language);
      await prefs.setString('date_format', _dateFormat);
      await prefs.setString('time_format', _timeFormat);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save settings: $e');
      }
    }
  }
  
  // Notification Settings
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setWaterRemindersEnabled(bool enabled) async {
    _waterRemindersEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setExerciseRemindersEnabled(bool enabled) async {
    _exerciseRemindersEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setSleepRemindersEnabled(bool enabled) async {
    _sleepRemindersEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setMealRemindersEnabled(bool enabled) async {
    _mealRemindersEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  // Data Settings
  Future<void> setDataBackupEnabled(bool enabled) async {
    _dataBackupEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }
  
  // Localization Settings
  Future<void> setLanguage(String language) async {
    _language = language;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setDateFormat(String format) async {
    _dateFormat = format;
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> setTimeFormat(String format) async {
    _timeFormat = format;
    notifyListeners();
    await _saveSettings();
  }
  
  // Utility methods
  Future<void> resetToDefaults() async {
    _notificationsEnabled = true;
    _waterRemindersEnabled = true;
    _exerciseRemindersEnabled = true;
    _sleepRemindersEnabled = true;
    _mealRemindersEnabled = true;
    _soundEnabled = true;
    _vibrationEnabled = true;
    _dataBackupEnabled = true;
    _language = 'en';
    _dateFormat = 'dd/MM/yyyy';
    _timeFormat = '24h';
    
    notifyListeners();
    await _saveSettings();
  }
  
  Future<void> clearAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _loadSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear settings: $e');
      }
    }
  }
  
  // Export/Import settings
  Map<String, dynamic> exportSettings() {
    return {
      'notifications_enabled': _notificationsEnabled,
      'water_reminders_enabled': _waterRemindersEnabled,
      'exercise_reminders_enabled': _exerciseRemindersEnabled,
      'sleep_reminders_enabled': _sleepRemindersEnabled,
      'meal_reminders_enabled': _mealRemindersEnabled,
      'sound_enabled': _soundEnabled,
      'vibration_enabled': _vibrationEnabled,
      'data_backup_enabled': _dataBackupEnabled,
      'language': _language,
      'date_format': _dateFormat,
      'time_format': _timeFormat,
    };
  }
  
  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      _notificationsEnabled = settings['notifications_enabled'] ?? true;
      _waterRemindersEnabled = settings['water_reminders_enabled'] ?? true;
      _exerciseRemindersEnabled = settings['exercise_reminders_enabled'] ?? true;
      _sleepRemindersEnabled = settings['sleep_reminders_enabled'] ?? true;
      _mealRemindersEnabled = settings['meal_reminders_enabled'] ?? true;
      _soundEnabled = settings['sound_enabled'] ?? true;
      _vibrationEnabled = settings['vibration_enabled'] ?? true;
      _dataBackupEnabled = settings['data_backup_enabled'] ?? true;
      _language = settings['language'] ?? 'en';
      _dateFormat = settings['date_format'] ?? 'dd/MM/yyyy';
      _timeFormat = settings['time_format'] ?? '24h';
      
      notifyListeners();
      await _saveSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to import settings: $e');
      }
    }
  }
}
