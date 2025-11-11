# Health Tracker App

A comprehensive Flutter-based health tracking application that runs entirely on localhost using Firebase Emulator Suite. Track your daily wellness activities including hydration, exercise, sleep, and nutrition with beautiful visualizations and smart reminders.

## 🎯 Features

### Core Functionality
- **Dashboard**: Daily overview with progress tracking and motivational quotes
- **Activity Tracking**: Log water intake, exercise, sleep, and meals
- **Progress Analytics**: Visual charts showing weekly and monthly trends
- **Smart Reminders**: Customizable notifications for healthy habits
- **Achievements**: Unlock badges for reaching health milestones
- **Offline Mode**: Full functionality without internet connection

### Technical Features
- **Responsive Design**: Optimized for all mobile screen sizes
- **Dark/Light Theme**: System-aware theme switching
- **Local Storage**: SQLite database for offline data persistence
- **Firebase Emulator**: Local development environment
- **Auto-sync**: Seamless data synchronization when online
- **Modern UI**: Material Design 3 with custom theming

## 🛠️ Technologies Used

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Emulator Suite
- **Database**: SQLite (offline) + Firestore (online)
- **State Management**: Provider
- **Charts**: FL Chart
- **Notifications**: Flutter Local Notifications
- **Responsive Design**: Flutter ScreenUtil

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Node.js (for Firebase CLI)
- Firebase CLI

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd health_tracker_app
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Firebase CLI** (if not already installed)
   ```bash
   npm install -g firebase-tools
   ```

4. **Start Firebase Emulators**
   ```bash
   firebase emulators:start
   ```
   This will start:
   - Authentication Emulator: http://localhost:9099
   - Firestore Emulator: http://localhost:8080
   - Emulator UI: http://localhost:4000

5. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Emulator Setup

The app is configured to use Firebase emulators for local development:

- **Auth Emulator**: localhost:9099
- **Firestore Emulator**: localhost:8080
- **Project ID**: health-tracker-local

No internet connection or Firebase project setup is required!

## 📱 App Structure

```
lib/
├── core/                   # Core app configuration
│   ├── app_config.dart    # App constants and configuration
│   ├── theme/             # Theme and styling
│   └── services/          # Core services (Firebase, Database, Notifications)
├── data/                  # Data layer
│   ├── models/           # Data models
│   ├── providers/        # State management providers
│   └── repositories/     # Data access layer
└── presentation/         # UI layer
    ├── screens/          # App screens
    └── widgets/          # Reusable widgets
```

## 🎨 Screenshots

### Dashboard
- Daily goals overview with progress bars
- Quick action buttons for logging activities
- Recent activities list
- Motivational quotes

### Activity Tracking
- Water intake logging (glasses)
- Exercise tracking (minutes)
- Sleep monitoring (hours)
- Meal logging (calories)

### Progress Analytics
- Weekly and monthly charts
- Goal achievement tracking
- Activity trends and insights

### Settings
- Profile management
- Theme customization
- Notification preferences
- Data backup options

## 🔧 Configuration

### Default Goals
- Water: 8 glasses per day
- Exercise: 30 minutes per day
- Sleep: 8 hours per day
- Calories: 2000 per day

### Customization
Users can customize their daily goals through the profile settings screen.

## 📊 Database Schema

### SQLite Tables
- `users`: User profiles and goals
- `activities`: Health activity logs
- `reminders`: Notification reminders
- `achievements`: Unlocked achievements
- `sync_queue`: Offline sync operations

### Firestore Collections
- `users`: User data (synced from SQLite)
- `activities`: Activity logs (synced from SQLite)
- `reminders`: User reminders (synced from SQLite)

## 🔔 Notifications

The app supports local notifications for:
- Water intake reminders
- Exercise reminders
- Sleep/bedtime reminders
- Meal logging reminders

All notifications are customizable and can be enabled/disabled per category.

## 🎯 Responsive Design

The app is fully responsive and adapts to different screen sizes:
- **Mobile**: Optimized for phones (375dp baseline)
- **Tablet**: Responsive layout for larger screens
- **Orientation**: Supports portrait mode

## 🔄 Offline Mode

- Full app functionality without internet
- Local SQLite database for data persistence
- Automatic sync when connection is restored
- Conflict resolution for data synchronization

## 🏆 Achievements System

Users can unlock achievements by:
- Logging their first activity
- Meeting daily goals
- Maintaining streaks
- Reaching milestones

## 🛡️ Security

- Firebase Authentication with emulator
- Firestore security rules
- Local data encryption (SQLite)
- User data privacy protection

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📦 Building

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the emulator suite
- Material Design team for design guidelines
- Open source community for packages used

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Email: support@healthtracker.com
- Documentation: [Link to docs]

---

**Built with ❤️ using Flutter**
