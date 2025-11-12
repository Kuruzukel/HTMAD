<div align="center">

# 💚 Health Tracker App

**A comprehensive Flutter-based health tracking application that runs entirely on localhost using Firebase Emulator Suite**

_Track your daily wellness activities including hydration, exercise, sleep, and nutrition with beautiful visualizations and smart reminders._

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Emulator-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-blue.svg)](https://www.android.com/)

[Features](#-features) • [Installation](#-getting-started) • [Documentation](#-documentation) • [Contributing](#-contributing)

---

</div>

## 📋 Table of Contents

- [✨ Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [📱 App Structure](#-app-structure)
- [⚙️ Configuration](#️-configuration)
- [📊 Database Schema](#-database-schema)
- [🔔 Notifications](#-notifications)
- [🎨 Design](#-design)
- [🔄 Offline Mode](#-offline-mode)
- [🏆 Achievements](#-achievements-system)
- [🛡️ Security](#️-security)
- [🧪 Testing](#-testing)
- [📦 Building](#-building)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## ✨ Features

### 🎯 Core Functionality

| Feature                   | Description                                                   |
| ------------------------- | ------------------------------------------------------------- |
| 📊 **Dashboard**          | Daily overview with progress tracking and motivational quotes |
| 💧 **Activity Tracking**  | Log water intake, exercise, sleep, and meals with ease        |
| 📈 **Progress Analytics** | Visual charts showing weekly and monthly trends               |
| 🔔 **Smart Reminders**    | Customizable notifications for healthy habits                 |
| 🏅 **Achievements**       | Unlock badges for reaching health milestones                  |
| 📱 **Offline Mode**       | Full functionality without internet connection                |

### ⚡ Technical Features

- 🎨 **Responsive Design** - Optimized for all mobile screen sizes
- 🌓 **Dark/Light Theme** - System-aware theme switching
- 💾 **Local Storage** - SQLite database for offline data persistence
- 🔥 **Firebase Emulator** - Local development environment
- 🔄 **Auto-sync** - Seamless data synchronization when online
- 🎭 **Modern UI** - Material Design 3 with custom theming

---

## 🛠️ Tech Stack

<div align="center">

| Category             | Technology                                                                                       |
| -------------------- | ------------------------------------------------------------------------------------------------ |
| **Frontend**         | ![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter)                        |
| **Backend**          | ![Firebase](https://img.shields.io/badge/Firebase-Emulator-FFCA28?logo=firebase&logoColor=black) |
| **Database**         | ![SQLite](https://img.shields.io/badge/SQLite-Firestore-003B57?logo=sqlite)                      |
| **State Management** | ![Provider](https://img.shields.io/badge/Provider-State-FF6B6B)                                  |
| **Charts**           | ![FL Chart](https://img.shields.io/badge/FL_Chart-Visualization-4ECDC4)                          |
| **Notifications**    | ![Local Notifications](https://img.shields.io/badge/Local-Notifications-FF6B9D)                  |

</div>

### 📦 Key Dependencies

```yaml
# Core
flutter: ^3.0.0
provider: ^6.0.0

# Firebase
firebase_core: ^latest
cloud_firestore: ^latest
firebase_auth: ^latest

# Database
sqflite: ^latest
path: ^latest

# UI & Charts
fl_chart: ^latest
flutter_screenutil: ^latest

# Notifications
flutter_local_notifications: ^latest
```

---

## 🚀 Quick Start

### 📋 Prerequisites

Before you begin, ensure you have the following installed:

- ✅ **Flutter SDK** (3.0.0 or higher)
- ✅ **Dart SDK**
- ✅ **Android Studio** / **VS Code**
- ✅ **Node.js** (for Firebase CLI)
- ✅ **Firebase CLI**

### 🔧 Installation

<details>
<summary><b>📥 Step 1: Clone the Repository</b></summary>

```bash
git clone <repository-url>
cd HTMAD
```

</details>

<details>
<summary><b>📦 Step 2: Install Flutter Dependencies</b></summary>

```bash
flutter pub get
```

</details>

<details>
<summary><b>🔥 Step 3: Install Firebase CLI</b></summary>

```bash
npm install -g firebase-tools
```

</details>

<details>
<summary><b>🚀 Step 4: Start Firebase Emulators</b></summary>

```bash
firebase emulators:start
```

This will start:

- 🔐 **Authentication Emulator**: `http://localhost:9099`
- 💾 **Firestore Emulator**: `http://localhost:8080`
- 🎛️ **Emulator UI**: `http://localhost:4000`

</details>

<details>
<summary><b>▶️ Step 5: Run the App</b></summary>

```bash
flutter run
```

</details>

### 🔥 Firebase Emulator Configuration

The app is pre-configured to use Firebase emulators for local development:

| Service                | Endpoint               | Port   |
| ---------------------- | ---------------------- | ------ |
| **Auth Emulator**      | `localhost`            | `9099` |
| **Firestore Emulator** | `localhost`            | `8080` |
| **Project ID**         | `health-tracker-local` | -      |

> 💡 **No internet connection or Firebase project setup is required!**

---

## 📱 App Structure

```
lib/
├── 📁 core/                      # Core app configuration
│   ├── 📄 app_config.dart        # App constants and configuration
│   ├── 📁 theme/                 # Theme and styling
│   └── 📁 services/              # Core services
│       ├── 🔥 Firebase Service
│       ├── 💾 Database Service
│       └── 🔔 Notification Service
│
├── 📁 data/                      # Data layer
│   ├── 📁 models/                # Data models
│   ├── 📁 providers/             # State management providers
│   └── 📁 repositories/          # Data access layer
│
└── 📁 presentation/              # UI layer
    ├── 📁 screens/               # App screens
    │   ├── 🏠 Dashboard
    │   ├── 📊 Analytics
    │   ├── ⚙️ Settings
    │   └── 🎯 Activities
    └── 📁 widgets/               # Reusable widgets
```

---

## ⚙️ Configuration

### 🎯 Default Goals

| Activity        | Daily Goal |
| --------------- | ---------- |
| 💧 **Water**    | 8 glasses  |
| 🏃 **Exercise** | 30 minutes |
| 😴 **Sleep**    | 8 hours    |
| 🍎 **Calories** | 2000 kcal  |

> 💡 Users can customize their daily goals through the **Profile Settings** screen.

---

## 📊 Database Schema

### 💾 SQLite Tables

| Table          | Description             |
| -------------- | ----------------------- |
| `users`        | User profiles and goals |
| `activities`   | Health activity logs    |
| `reminders`    | Notification reminders  |
| `achievements` | Unlocked achievements   |
| `sync_queue`   | Offline sync operations |

### 🔥 Firestore Collections

| Collection   | Description                         |
| ------------ | ----------------------------------- |
| `users`      | User data (synced from SQLite)      |
| `activities` | Activity logs (synced from SQLite)  |
| `reminders`  | User reminders (synced from SQLite) |

---

## 🔔 Notifications

The app supports **local notifications** for:

- 💧 Water intake reminders
- 🏃 Exercise reminders
- 😴 Sleep/bedtime reminders
- 🍎 Meal logging reminders

> ⚙️ All notifications are customizable and can be enabled/disabled per category.

---

## 🎨 Design

### 📱 Responsive Design

The app is fully responsive and adapts to different screen sizes:

- 📱 **Mobile**: Optimized for phones (375dp baseline)
- 📱 **Tablet**: Responsive layout for larger screens
- 🔄 **Orientation**: Supports portrait mode

### 🎭 Theme Support

- 🌞 **Light Theme** - Clean and bright interface
- 🌙 **Dark Theme** - Easy on the eyes
- 🔄 **Auto Theme** - Follows system preferences

---

## 🔄 Offline Mode

| Feature                   | Status                   |
| ------------------------- | ------------------------ |
| ✅ Full app functionality | Without internet         |
| 💾 Local SQLite database  | Data persistence         |
| 🔄 Automatic sync         | When connection restored |
| 🔀 Conflict resolution    | Data synchronization     |

---

## 🏆 Achievements System

Unlock achievements by:

- 🎯 Logging your first activity
- ✅ Meeting daily goals
- 🔥 Maintaining streaks
- 🏅 Reaching milestones

---

## 🛡️ Security

- 🔐 Firebase Authentication with emulator
- 🛡️ Firestore security rules
- 🔒 Local data encryption (SQLite)
- 🔐 User data privacy protection

---

## 🧪 Testing

Run the test suite:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📦 Building

### 🤖 Android APK

```bash
flutter build apk --release
```

### 📦 Android App Bundle

```bash
flutter build appbundle --release
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. 🍴 **Fork** the repository
2. 🌿 **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 **Push** to the branch (`git push origin feature/AmazingFeature`)
5. 🔀 **Open** a Pull Request

### 📝 Contribution Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) - Amazing framework
- [Firebase Team](https://firebase.google.com/) - Emulator suite
- [Material Design](https://material.io/) - Design guidelines
- Open source community - Packages and support

---

## 📞 Support

Need help? We're here for you!

- 🐛 **Report Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- 📧 **Email**: support@healthtracker.com
- 📚 **Documentation**: [Link to docs]

---

<div align="center">


**KEL EMMAN AERON**

---


</div>
