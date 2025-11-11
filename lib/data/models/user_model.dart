import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final int? age;
  final String? gender;
  final double? weight;
  final double? height;
  final int waterGoal;
  final int exerciseGoal;
  final int sleepGoal;
  final int calorieGoal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.gender,
    this.weight,
    this.height,
    required this.waterGoal,
    required this.exerciseGoal,
    required this.sleepGoal,
    required this.calorieGoal,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    int? age,
    String? gender,
    double? weight,
    double? height,
    int? waterGoal,
    int? exerciseGoal,
    int? sleepGoal,
    int? calorieGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      waterGoal: waterGoal ?? this.waterGoal,
      exerciseGoal: exerciseGoal ?? this.exerciseGoal,
      sleepGoal: sleepGoal ?? this.sleepGoal,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'water_goal': waterGoal,
      'exercise_goal': exerciseGoal,
      'sleep_goal': sleepGoal,
      'calorie_goal': calorieGoal,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      age: map['age']?.toInt(),
      gender: map['gender'],
      weight: map['weight']?.toDouble(),
      height: map['height']?.toDouble(),
      waterGoal: map['water_goal']?.toInt() ?? 8,
      exerciseGoal: map['exercise_goal']?.toInt() ?? 30,
      sleepGoal: map['sleep_goal']?.toInt() ?? 8,
      calorieGoal: map['calorie_goal']?.toInt() ?? 2000,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: (map['synced'] ?? 0) == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, age: $age, gender: $gender, weight: $weight, height: $height, waterGoal: $waterGoal, exerciseGoal: $exerciseGoal, sleepGoal: $sleepGoal, calorieGoal: $calorieGoal, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.age == age &&
        other.gender == gender &&
        other.weight == weight &&
        other.height == height &&
        other.waterGoal == waterGoal &&
        other.exerciseGoal == exerciseGoal &&
        other.sleepGoal == sleepGoal &&
        other.calorieGoal == calorieGoal &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        waterGoal.hashCode ^
        exerciseGoal.hashCode ^
        sleepGoal.hashCode ^
        calorieGoal.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode;
  }

  // Helper methods
  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return 'Unknown';

    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }
}
