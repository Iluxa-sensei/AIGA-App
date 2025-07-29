/// User profile model for AIGA Connect
/// Represents user data from the user_profiles table in Supabase
class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final UserStatus status;
  final String? phone;
  final DateTime? dateOfBirth;
  final BeltLevel beltLevel;
  final int xpPoints;
  final String? profileImageUrl;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? medicalConditions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.status,
    this.phone,
    this.dateOfBirth,
    required this.beltLevel,
    required this.xpPoints,
    this.profileImageUrl,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.medicalConditions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserProfile from Supabase JSON response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: UserRole.fromString(json['role'] as String),
      status: UserStatus.fromString(json['status'] as String),
      phone: json['phone'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      beltLevel: BeltLevel.fromString(json['belt_level'] as String),
      xpPoints: json['xp_points'] as int? ?? 0,
      profileImageUrl: json['profile_image_url'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      medicalConditions: json['medical_conditions'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Convert UserProfile to JSON for Supabase operations
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role.value,
      'status': status.value,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'belt_level': beltLevel.value,
      'xp_points': xpPoints,
      'profile_image_url': profileImageUrl,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'medical_conditions': medicalConditions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  UserProfile copyWith({
    String? email,
    String? fullName,
    UserRole? role,
    UserStatus? status,
    String? phone,
    DateTime? dateOfBirth,
    BeltLevel? beltLevel,
    int? xpPoints,
    String? profileImageUrl,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? medicalConditions,
  }) {
    return UserProfile(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      beltLevel: beltLevel ?? this.beltLevel,
      xpPoints: xpPoints ?? this.xpPoints,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// User role enumeration matching Supabase enum
enum UserRole {
  athlete('athlete'),
  trainer('trainer'),
  parent('parent'),
  admin('admin');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.athlete,
    );
  }

  String get displayName {
    switch (this) {
      case UserRole.athlete:
        return 'Спортсмен';
      case UserRole.trainer:
        return 'Тренер';
      case UserRole.parent:
        return 'Родитель';
      case UserRole.admin:
        return 'Администратор';
    }
  }
}

/// User status enumeration matching Supabase enum
enum UserStatus {
  active('active'),
  inactive('inactive'),
  suspended('suspended');

  const UserStatus(this.value);
  final String value;

  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.active,
    );
  }

  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Активный';
      case UserStatus.inactive:
        return 'Неактивный';
      case UserStatus.suspended:
        return 'Заблокирован';
    }
  }
}

/// Belt level enumeration matching Supabase enum
enum BeltLevel {
  white('white'),
  blue('blue'),
  purple('purple'),
  brown('brown'),
  black('black');

  const BeltLevel(this.value);
  final String value;

  static BeltLevel fromString(String value) {
    return BeltLevel.values.firstWhere(
      (belt) => belt.value == value,
      orElse: () => BeltLevel.white,
    );
  }

  String get displayName {
    switch (this) {
      case BeltLevel.white:
        return 'Белый';
      case BeltLevel.blue:
        return 'Синий';
      case BeltLevel.purple:
        return 'Фиолетовый';
      case BeltLevel.brown:
        return 'Коричневый';
      case BeltLevel.black:
        return 'Черный';
    }
  }

  /// Get belt level order for progression tracking
  int get order {
    switch (this) {
      case BeltLevel.white:
        return 0;
      case BeltLevel.blue:
        return 1;
      case BeltLevel.purple:
        return 2;
      case BeltLevel.brown:
        return 3;
      case BeltLevel.black:
        return 4;
    }
  }
}
