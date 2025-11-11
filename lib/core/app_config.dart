class AppConfig {
  static const String appName = 'Health Tracker';
  static const String appVersion = '1.0.0';

  // Firebase Emulator Configuration
  static const String firebaseProjectId = 'health-tracker-local';
  static const String authEmulatorHost = 'localhost';
  static const int authEmulatorPort = 9099;
  static const String firestoreEmulatorHost = 'localhost';
  static const int firestoreEmulatorPort = 8080;

  // Database Configuration
  static const String databaseName = 'health_tracker.db';
  static const int databaseVersion = 1;

  // Notification Configuration
  static const String notificationChannelId = 'health_tracker_notifications';
  static const String notificationChannelName = 'Health Tracker Notifications';
  static const String notificationChannelDescription =
      'Notifications for health tracking reminders';

  // Default Goals
  static const int defaultWaterGoal = 8; // glasses per day
  static const int defaultExerciseGoal = 30; // minutes per day
  static const int defaultSleepGoal = 8; // hours per day
  static const int defaultCalorieGoal = 2000; // calories per day

  // Theme Configuration
  static const String themePreferenceKey = 'theme_mode';
  static const String userPreferencesKey = 'user_preferences';

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}
