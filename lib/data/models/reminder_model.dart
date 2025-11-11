import 'dart:convert';

enum ReminderType { water, exercise, sleep, meal }

extension ReminderTypeExtension on ReminderType {
  String get name {
    switch (this) {
      case ReminderType.water:
        return 'water';
      case ReminderType.exercise:
        return 'exercise';
      case ReminderType.sleep:
        return 'sleep';
      case ReminderType.meal:
        return 'meal';
    }
  }

  String get displayName {
    switch (this) {
      case ReminderType.water:
        return 'Water Reminder';
      case ReminderType.exercise:
        return 'Exercise Reminder';
      case ReminderType.sleep:
        return 'Sleep Reminder';
      case ReminderType.meal:
        return 'Meal Reminder';
    }
  }

  String get icon {
    switch (this) {
      case ReminderType.water:
        return '💧';
      case ReminderType.exercise:
        return '🏃‍♂️';
      case ReminderType.sleep:
        return '😴';
      case ReminderType.meal:
        return '🍽️';
    }
  }

  static ReminderType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'water':
        return ReminderType.water;
      case 'exercise':
        return ReminderType.exercise;
      case 'sleep':
        return ReminderType.sleep;
      case 'meal':
        return ReminderType.meal;
      default:
        throw ArgumentError('Invalid reminder type: $value');
    }
  }
}

class ReminderModel {
  final String id;
  final String userId;
  final ReminderType type;
  final String title;
  final String message;
  final DateTime time;
  final List<int> days; // 0 = Sunday, 1 = Monday, etc.
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.days,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  ReminderModel copyWith({
    String? id,
    String? userId,
    ReminderType? type,
    String? title,
    String? message,
    DateTime? time,
    List<int>? days,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      days: days ?? this.days,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'message': message,
      'time': time.toIso8601String(),
      'days': json.encode(days),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: ReminderTypeExtension.fromString(map['type'] ?? ''),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      time: DateTime.parse(map['time']),
      days: List<int>.from(json.decode(map['days'] ?? '[]')),
      isActive: (map['is_active'] ?? 1) == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: (map['synced'] ?? 0) == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReminderModel.fromJson(String source) =>
      ReminderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReminderModel(id: $id, userId: $userId, type: $type, title: $title, message: $message, time: $time, days: $days, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReminderModel &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.title == title &&
        other.message == message &&
        other.time == time &&
        other.days.toString() == days.toString() &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        title.hashCode ^
        message.hashCode ^
        time.hashCode ^
        days.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode;
  }

  // Helper methods
  String get timeFormatted {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String get daysFormatted {
    if (days.length == 7) return 'Every day';
    if (days.isEmpty) return 'Never';

    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days.map((day) => dayNames[day]).join(', ');
  }

  bool get isDaily => days.length == 7;
  bool get isWeekdays =>
      days.length == 5 && !days.contains(0) && !days.contains(6);
  bool get isWeekends =>
      days.length == 2 && days.contains(0) && days.contains(6);

  bool shouldTriggerToday() {
    final today = DateTime.now().weekday % 7; // Convert to 0-6 format
    return isActive && days.contains(today);
  }

  DateTime? get nextTriggerTime {
    if (!isActive || days.isEmpty) return null;

    final now = DateTime.now();
    final today = now.weekday % 7;

    // Check if reminder should trigger today and time hasn't passed
    if (days.contains(today)) {
      final todayTrigger = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      if (todayTrigger.isAfter(now)) {
        return todayTrigger;
      }
    }

    // Find next day in the week
    for (int i = 1; i <= 7; i++) {
      final nextDay = (today + i) % 7;
      if (days.contains(nextDay)) {
        final nextTrigger = now.add(Duration(days: i));
        return DateTime(
          nextTrigger.year,
          nextTrigger.month,
          nextTrigger.day,
          time.hour,
          time.minute,
        );
      }
    }

    return null;
  }
}
