import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/user_provider.dart';
import '../../data/providers/activity_provider.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/providers/settings_provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider(create: (_) => ThemeProvider()..loadThemeMode()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ActivityProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => SettingsProvider()),
  ];
}
