# HTMAD

**Health Tracker Mobile Application Development**  
**A Comprehensive Flutter-Based Health Tracking Application**

<div align="center">

A professional mobile wellness platform providing real-time health tracking, intelligent analytics, and personalized insights for hydration, fitness, sleep, and nutrition.

</div>

---

## 📋 Quick Navigation

| 🎬 Getting Started | [View](#getting-started) |
| 💻 Development | [View](#development) |
| 📚 Documentation | [View](#documentation) |

---

## 🎯 Overview

HTMAD (Health Tracker Mobile Application Development) is a mobile wellness companion that runs entirely on localhost using Firebase Emulator Suite. Built with Flutter and modern mobile technologies, it provides a seamless experience for tracking daily health activities with offline-first capabilities and cloud synchronization.

---

## ✨ Key Capabilities

### � Health Monitoring & Tracking

- **Activity Logging** — Track water intake, exercise, sleep, and meals
- **Progress Analytics** — Visual charts showing weekly and monthly trends
- **Goal Management** — Customizable daily health goals
- **Offline Mode** — Full functionality without internet connection

### 🔔 Smart Features

- **Smart Reminders** — Customizable notifications for healthy habits
- **Achievements System** — Unlock badges for reaching health milestones
- **Real-time Sync** — Seamless data synchronization with Firebase
- **Responsive Design** — Optimized for all mobile screen sizes

---

## ✨ Features

### � Core Screens

Comprehensive mobile interface with intuitive navigation

✓ Splash screen with app initialization  
✓ Authentication (Login, Register, Password Recovery)  
✓ Dashboard with daily overview and progress tracking  
✓ Activities tracking and logging  
✓ Progress analytics with charts  
✓ Settings and profile management  
✓ Notifications settings  
✓ About screen

### 📊 Dashboard

Daily overview with motivational insights

✓ Daily goals card with progress indicators  
✓ Motivational quotes and tips  
✓ Quick actions for logging activities  
✓ Recent activities summary  
✓ Visual progress tracking

### 🏃 Activity Tracking

Log and monitor daily wellness activities

✓ Water intake tracking (glasses per day)  
✓ Exercise logging (minutes per day)  
✓ Sleep monitoring (hours per day)  
✓ Meal and calorie tracking  
✓ Activity history with filters  
✓ Quick add functionality

### 📈 Progress Analytics

Visual insights into health trends

✓ Interactive charts (FL Chart)  
✓ Weekly summary statistics  
✓ Monthly trend analysis  
✓ Achievements and milestones  
✓ Goal completion tracking

### ⚙️ Settings & Profile

Personalize your health tracking experience

✓ User profile management  
✓ Notification preferences  
✓ Daily goal customization  
✓ Theme switching (Light/Dark/System)  
✓ About and app information

---

## 🛠️ Tech Stack

### Frontend Technologies

| Technology         | Purpose                         | Version |
| ------------------ | ------------------------------- | ------- |
| Flutter            | Cross-platform mobile framework | 3.0+    |
| Dart               | Programming language            | 3.0+    |
| Material Design    | UI components and design system | Latest  |
| Flutter ScreenUtil | Responsive design               | 5.9.0   |

### Backend & Database

| Technology         | Purpose                        | Version |
| ------------------ | ------------------------------ | ------- |
| Firebase Auth      | User authentication (Emulator) | 4.15.3  |
| Cloud Firestore    | Cloud database (Emulator)      | 4.13.6  |
| SQLite             | Local offline database         | 2.3.0   |
| Shared Preferences | Local key-value storage        | 2.2.2   |

### State Management & Architecture

| Technology         | Purpose                   | Version |
| ------------------ | ------------------------- | ------- |
| Provider           | State management          | 6.1.1   |
| Repository Pattern | Data layer architecture   | -       |
| Service Layer      | Business logic separation | -       |

### UI & Visualization

| Technology     | Purpose                       | Version |
| -------------- | ----------------------------- | ------- |
| FL Chart       | Charts and data visualization | 0.65.0  |
| Flutter SVG    | SVG image rendering           | 2.0.9   |
| Custom Widgets | Reusable UI components        | -       |

### Utilities & Services

| Technology                  | Purpose                   | Version |
| --------------------------- | ------------------------- | ------- |
| Flutter Local Notifications | Push notifications        | 17.2.2  |
| Connectivity Plus           | Network status monitoring | 5.0.2   |
| Path Provider               | File system access        | 2.1.2   |
| Device Info Plus            | Device information        | 9.1.1   |
| URL Launcher                | External link handling    | 6.2.2   |
| Intl                        | Internationalization      | 0.19.0  |

### Development Tools

| Tool             | Purpose                 |
| ---------------- | ----------------------- |
| Android Studio   | Primary IDE             |
| VS Code          | Alternative IDE         |
| Flutter DevTools | Debugging and profiling |
| Firebase CLI     | Emulator management     |
| Git              | Version control         |

### Platform Support

| Platform | Status            |
| -------- | ----------------- |
| Android  | ✅ Primary Target |
| iOS      | ✅ Supported      |
| Web      | ✅ Supported      |
| Windows  | ✅ Supported      |
| macOS    | ✅ Supported      |
| Linux    | ✅ Supported      |

---

## Project Structure

```
health_tracker_app/
│
├── 📂 .dart_tool/                     # Dart build tools
├── 📂 .git/                           # Git repository
├── 📂 .idea/                          # IntelliJ/Android Studio settings
├── 📂 .vscode/                        # VS Code settings
│   ├── launch.json                    # Debug configurations
│   └── settings.json                  # Editor settings
│
├── 📂 android/                        # Android platform code
│   ├── 📂 app/
│   │   ├── 📂 src/
│   │   │   ├── 📂 debug/
│   │   │   │   └── AndroidManifest.xml
│   │   │   ├── 📂 main/
│   │   │   │   ├── AndroidManifest.xml
│   │   │   │   ├── 📂 kotlin/
│   │   │   │   │   └── com/example/htmad/MainActivity.kt
│   │   │   │   └── 📂 res/          # Android resources
│   │   │   └── 📂 profile/
│   │   │       └── AndroidManifest.xml
│   │   ├── build.gradle               # App-level Gradle config
│   │   └── google-services.json       # Firebase config
│   ├── build.gradle                   # Project-level Gradle
│   ├── gradle.properties              # Gradle properties
│   └── settings.gradle                # Gradle settings
│
├── 📂 assets/                         # Application assets
│   ├── 📂 animations/                 # Animation files
│   ├── 📂 icons/                      # App icons
│   └── 📂 images/                     # Image assets
│
├── 📂 ios/                            # iOS platform code
│   ├── 📂 Flutter/
│   │   ├── AppFrameworkInfo.plist
│   │   ├── Debug.xcconfig
│   │   ├── Release.xcconfig
│   │   └── Generated.xcconfig
│   └── 📂 Runner/
│       ├── AppDelegate.swift
│       ├── Info.plist
│       └── 📂 Assets.xcassets/
│
├── 📂 lib/                            # Main application code
│   ├── 📂 core/                       # Core app configuration
│   │   ├── 📂 providers/
│   │   │   └── app_providers.dart     # Provider configuration
│   │   ├── 📂 services/               # Core services
│   │   │   ├── database_service.dart  # SQLite service
│   │   │   ├── firebase_service.dart  # Firebase service
│   │   │   ├── notification_service.dart # Notification service
│   │   │   └── sync_service.dart      # Data sync service
│   │   ├── 📂 theme/
│   │   │   └── app_theme.dart         # App theming
│   │   └── app_config.dart            # App configuration
│   │
│   ├── 📂 data/                       # Data layer
│   │   ├── 📂 models/                 # Data models
│   │   │   ├── activity_model.dart
│   │   │   ├── reminder_model.dart
│   │   │   └── user_model.dart
│   │   ├── 📂 providers/              # State management
│   │   │   ├── activity_provider.dart
│   │   │   ├── auth_provider.dart
│   │   │   ├── notification_provider.dart
│   │   │   ├── settings_provider.dart
│   │   │   └── user_provider.dart
│   │   └── 📂 repositories/           # Data access layer
│   │       ├── activity_repository.dart
│   │       ├── reminder_repository.dart
│   │       └── user_repository.dart
│   │
│   ├── 📂 presentation/               # UI layer
│   │   ├── 📂 screens/
│   │   │   ├── 📂 activities/         # Activity screens
│   │   │   │   ├── 📂 widgets/
│   │   │   │   │   ├── activity_filter_tabs.dart
│   │   │   │   │   └── activity_list_item.dart
│   │   │   │   ├── activities_screen.dart
│   │   │   │   └── add_activity_screen.dart
│   │   │   ├── 📂 auth/               # Authentication screens
│   │   │   │   ├── forgot_password_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── 📂 dashboard/          # Dashboard screens
│   │   │   │   ├── 📂 widgets/
│   │   │   │   │   ├── daily_goals_card.dart
│   │   │   │   │   ├── dashboard_header.dart
│   │   │   │   │   ├── motivational_card.dart
│   │   │   │   │   ├── quick_actions_card.dart
│   │   │   │   │   └── recent_activities_card.dart
│   │   │   │   └── dashboard_screen.dart
│   │   │   ├── 📂 main/
│   │   │   │   └── main_screen.dart   # Main navigation
│   │   │   ├── 📂 progress/           # Progress screens
│   │   │   │   ├── 📂 widgets/
│   │   │   │   │   ├── achievements_card.dart
│   │   │   │   │   ├── progress_chart_card.dart
│   │   │   │   │   └── weekly_summary_card.dart
│   │   │   │   └── progress_screen.dart
│   │   │   ├── 📂 settings/           # Settings screens
│   │   │   │   ├── 📂 widgets/
│   │   │   │   │   ├── settings_item.dart
│   │   │   │   │   └── settings_section.dart
│   │   │   │   ├── about_screen.dart
│   │   │   │   ├── notifications_settings_screen.dart
│   │   │   │   ├── profile_screen.dart
│   │   │   │   └── settings_screen.dart
│   │   │   └── 📂 splash/
│   │   │       └── splash_screen.dart
│   │   └── 📂 widgets/                # Reusable widgets
│   │       ├── custom_button.dart
│   │       ├── custom_text_field.dart
│   │       ├── glassmorphism_container.dart
│   │       └── loading_overlay.dart
│   │
│   └── main.dart                      # App entry point
│
├── 📂 linux/                          # Linux platform code
├── 📂 macos/                          # macOS platform code
├── 📂 web/                            # Web platform code
│   ├── 📂 icons/
│   ├── favicon.png
│   ├── index.html
│   └── manifest.json
├── 📂 windows/                        # Windows platform code
│
├── 📂 test/                           # Unit and widget tests
│   └── widget_test.dart
│
├── .gitignore                         # Git ignore rules
├── .metadata                          # Flutter metadata
├── analysis_options.yaml              # Dart analyzer config
├── firebase.json                      # Firebase emulator config
├── firestore.indexes.json             # Firestore indexes
├── firestore.rules                    # Firestore security rules
├── pubspec.yaml                       # Flutter dependencies
├── pubspec.lock                       # Dependency lock file
├── README.md                          # Project documentation
└── SECURITY.md                        # Security policy
```

---

## Application Architecture

### Layer Structure

The application follows a clean architecture pattern with clear separation of concerns:

**Presentation Layer** — UI screens and widgets  
**Data Layer** — Models, repositories, and providers  
**Core Layer** — Services, configuration, and theme

### Key Components

#### 1. Core Services

**Firebase Service** — Manages Firebase initialization and emulator connection  
**Database Service** — Handles SQLite local database operations  
**Notification Service** — Manages local push notifications  
**Sync Service** — Synchronizes data between local and cloud storage

#### 2. Data Models

**User Model** — User profile and authentication data  
**Activity Model** — Health activity logs (water, exercise, sleep, meals)  
**Reminder Model** — Notification reminders and schedules

#### 3. State Management

**Provider Pattern** — Used for state management across the app  
**Activity Provider** — Manages activity data and operations  
**Auth Provider** — Handles authentication state  
**Settings Provider** — Manages app settings and preferences  
**User Provider** — Manages user profile data

#### 4. Repositories

**Activity Repository** — Data access for activities  
**Reminder Repository** — Data access for reminders  
**User Repository** — Data access for user data

---

## Features in Detail

### 🔐 Authentication System

- Secure user registration with email validation
- Login with email and password
- Password recovery workflow
- Firebase Authentication (Emulator mode)
- Session management

### � Dashboard

- Daily progress overview
- Visual goal indicators
- Motivational quotes
- Quick action buttons
- Recent activity summary
- Responsive card layout

### 🏃 Activity Tracking

- **Water Intake** — Track glasses consumed (default goal: 8 glasses/day)
- **Exercise** — Log workout duration (default goal: 30 minutes/day)
- **Sleep** — Monitor sleep hours (default goal: 8 hours/day)
- **Nutrition** — Track meals and calories (default goal: 2000 kcal/day)
- Activity history with date filters
- Quick add functionality

### 📈 Progress Analytics

- Interactive line and bar charts
- Weekly summary statistics
- Monthly trend analysis
- Goal completion percentage
- Achievement badges
- Exportable reports

### 🔔 Notifications

- Customizable reminder schedules
- Category-based notifications (water, exercise, sleep, meals)
- Local push notifications
- Notification preferences management
- Do Not Disturb mode

### ⚙️ Settings

- User profile editing
- Daily goal customization
- Theme selection (Light/Dark/System)
- Notification preferences
- About and version information
- Data export options

---

## Getting Started

### Prerequisites

```bash
# Required Software
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Node.js (for Firebase CLI)
- Firebase CLI
- Git

# Platform-Specific Requirements
- Android: Android SDK, Java JDK 17
- iOS: Xcode 14+, CocoaPods
- Web: Chrome browser
```

### Installation

#### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd health_tracker_app
```

#### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

#### Step 3: Install Firebase CLI

```bash
npm install -g firebase-tools
```

#### Step 4: Start Firebase Emulators

```bash
firebase emulators:start
```

This will start:

- **Authentication Emulator**: `http://localhost:9099`
- **Firestore Emulator**: `http://localhost:8080`
- **Emulator UI**: `http://localhost:4000`

#### Step 5: Run the App

```bash
# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

### Firebase Emulator Configuration

The app is pre-configured to use Firebase emulators for local development:

| Service                | Host                 | Port |
| ---------------------- | -------------------- | ---- |
| **Auth Emulator**      | localhost            | 9099 |
| **Firestore Emulator** | localhost            | 8080 |
| **Emulator UI**        | localhost            | 4000 |
| **Project ID**         | health-tracker-local | -    |

> 💡 **No internet connection or Firebase project setup is required!**

---

## Development

### Development Commands

```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Run in profile mode
flutter run --profile

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)

# Clean build
flutter clean
flutter pub get
flutter run

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate code (if using code generation)
flutter pub run build_runner build
```

### Build Commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

### Development Guidelines

#### Code Organization

- Follow Flutter/Dart style guide
- Use meaningful variable and function names
- Keep widgets small and focused
- Separate business logic from UI

#### State Management

- Use Provider for state management
- Keep providers focused on specific domains
- Use ChangeNotifier for reactive updates
- Dispose resources properly

#### Database Operations

- Use repositories for data access
- Implement proper error handling
- Use transactions for multiple operations
- Keep database queries optimized

#### UI Development

- Use responsive design principles
- Follow Material Design guidelines
- Implement proper loading states
- Handle errors gracefully

---

## Configuration

### App Configuration

Edit `lib/core/app_config.dart` to customize:

```dart
// App Information
static const String appName = 'Health Tracker';
static const String appVersion = '1.0.0';

// Firebase Emulator
static const String firebaseProjectId = 'health-tracker-local';
static const int authEmulatorPort = 9099;
static const int firestoreEmulatorPort = 8080;

// Default Goals
static const int defaultWaterGoal = 8;      // glasses
static const int defaultExerciseGoal = 30;  // minutes
static const int defaultSleepGoal = 8;      // hours
static const int defaultCalorieGoal = 2000; // calories
```

### Theme Configuration

Customize themes in `lib/core/theme/app_theme.dart`:

- Light theme colors
- Dark theme colors
- Typography
- Component themes

### Notification Configuration

Configure notifications in `lib/core/services/notification_service.dart`:

- Notification channels
- Default schedules
- Sound and vibration settings

---

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

```
test/
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests
```

---

## Deployment

### Android Deployment

1. **Configure signing**:
   - Create keystore
   - Update `android/key.properties`
   - Configure `android/app/build.gradle`

2. **Build release**:

   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Play Store**:
   - Use Google Play Console
   - Upload AAB file
   - Complete store listing

### iOS Deployment

1. **Configure signing**:
   - Set up Apple Developer account
   - Configure signing in Xcode

2. **Build release**:

   ```bash
   flutter build ios --release
   ```

3. **Upload to App Store**:
   - Use Xcode or Transporter
   - Submit for review

---

## Documentation

### Project Documentation

- **README.md** — Project overview (this file)
- **SECURITY.md** — Security policy and guidelines

### Code Documentation

- Inline code comments
- Dart documentation comments (///)
- Widget documentation

### Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Documentation](https://pub.dev/packages/provider)
- [FL Chart Documentation](https://pub.dev/packages/fl_chart)

---

## Project Statistics

| Metric              | Count              |
| ------------------- | ------------------ |
| Total Screens       | 15+ screens        |
| Core Services       | 4 services         |
| Data Models         | 3 models           |
| Providers           | 5 providers        |
| Repositories        | 3 repositories     |
| Reusable Widgets    | 15+ widgets        |
| Supported Platforms | 6 platforms        |
| Dependencies        | 20+ packages       |
| Database            | SQLite + Firestore |

---

## Project Information

### Proponent

**Name:** Michael D. Cruz  
**Program/Year:** 4th Year PROVA  
**Submission Date:** October 4, 2025

### Project Objectives

**General Objective:**  
To design and develop a cross-platform HTMAD (Health Tracker Mobile Application Development) that empowers users to monitor and enhance daily wellness routines through data-driven insights and timely reminders.

**Specific Objectives:**

- Identify user needs through surveys and usability studies
- Design system architecture and user interface for HTMAD
- Implement mobile application using Flutter and Firebase
- Test and evaluate usability and performance across multiple platforms
- Recommend iterative improvements and future enhancements

### Development Methodology

**Approach:** Agile methodology with bi-weekly sprints

**Phases:**

1. Requirements Gathering
2. System Design
3. Development
4. Testing
5. Deployment
6. Maintenance/Updates

---

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards

- Follow Flutter/Dart style guide
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

### Pull Request Process

1. Update README.md with details of changes
2. Update version numbers following SemVer
3. Ensure CI/CD pipeline passes
4. Request review from maintainers

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact & Support

**Developer:** KEL EMMAN AERON  
**Project:** HTMAD - Health Tracker Mobile Application Development  
**Institution:** Creative Aesthetic Academy & Technical Education Inc.

For issues, questions, or suggestions:

- Check the Documentation section
- Review code comments and documentation
- Open an issue on GitHub
- Contact the development team

---

<div align="center">

**HTMAD**  
Health Tracker Mobile Application Development

© 2025 HTMAD. All Rights Reserved.

</div>
