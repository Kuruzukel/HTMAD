import 'dart:convert';

enum ActivityType { water, exercise, sleep, meal }

extension ActivityTypeExtension on ActivityType {
  String get name {
    switch (this) {
      case ActivityType.water:
        return 'water';
      case ActivityType.exercise:
        return 'exercise';
      case ActivityType.sleep:
        return 'sleep';
      case ActivityType.meal:
        return 'meal';
    }
  }

  String get displayName {
    switch (this) {
      case ActivityType.water:
        return 'Water';
      case ActivityType.exercise:
        return 'Exercise';
      case ActivityType.sleep:
        return 'Sleep';
      case ActivityType.meal:
        return 'Meal';
    }
  }

  String get icon {
    switch (this) {
      case ActivityType.water:
        return '💧';
      case ActivityType.exercise:
        return '🏃‍♂️';
      case ActivityType.sleep:
        return '😴';
      case ActivityType.meal:
        return '🍽️';
    }
  }

  static ActivityType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'water':
        return ActivityType.water;
      case 'exercise':
        return ActivityType.exercise;
      case 'sleep':
        return ActivityType.sleep;
      case 'meal':
        return ActivityType.meal;
      default:
        throw ArgumentError('Invalid activity type: $value');
    }
  }
}

class ActivityModel {
  final String id;
  final String userId;
  final ActivityType type;
  final double value;
  final String unit;
  final DateTime date;
  final DateTime time;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
    required this.time,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  ActivityModel copyWith({
    String? id,
    String? userId,
    ActivityType? type,
    double? value,
    String? unit,
    DateTime? date,
    DateTime? time,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
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
      'value': value,
      'unit': unit,
      'date': date.toIso8601String().split('T')[0],
      'time': time.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: ActivityTypeExtension.fromString(map['type'] ?? ''),
      value: map['value']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      date: DateTime.parse(map['date']),
      time: DateTime.parse(map['time']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: (map['synced'] ?? 0) == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ActivityModel(id: $id, userId: $userId, type: $type, value: $value, unit: $unit, date: $date, time: $time, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityModel &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.value == value &&
        other.unit == unit &&
        other.date == date &&
        other.time == time &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        value.hashCode ^
        unit.hashCode ^
        date.hashCode ^
        time.hashCode ^
        notes.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode;
  }

  // Helper methods
  String get formattedValue {
    switch (type) {
      case ActivityType.water:
        return '${value.toInt()} $unit';
      case ActivityType.exercise:
        return '${value.toInt()} $unit';
      case ActivityType.sleep:
        final hours = value.floor();
        final minutes = ((value - hours) * 60).round();
        return '${hours}h ${minutes}m';
      case ActivityType.meal:
        return '${value.toInt()} $unit';
    }
  }

  String get timeFormatted {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String get dateFormatted {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
