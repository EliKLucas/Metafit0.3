class UserProfile {
  final String userId;
  final String? name;
  final double? height;
  final double? weight;
  final String? fitnessGoal;
  final String? experienceLevel;
  final List<String> injuryHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.userId,
    this.name,
    this.height,
    this.weight,
    this.fitnessGoal,
    this.experienceLevel,
    this.injuryHistory = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'height': height,
      'weight': weight,
      'fitnessGoal': fitnessGoal,
      'experienceLevel': experienceLevel,
      'injuryHistory': injuryHistory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'] ?? '',
      name: map['name'],
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      fitnessGoal: map['fitnessGoal'],
      experienceLevel: map['experienceLevel'],
      injuryHistory: List<String>.from(map['injuryHistory'] ?? []),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

enum FitnessGoal {
  weightLoss,
  muscleGain,
  strengthGain,
  endurance,
  maintenance,
}

enum ExperienceLevel { beginner, intermediate, advanced }
