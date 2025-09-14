import 'package:objectbox/objectbox.dart';

@Entity()
class Authentication {
  @Id()
  int id = 0;

  String name = 'Adn';
  String email = 'adn@gmail.com';
  String passwordHash = ''; // Never store plain text passwords

  int userTypeIndex = UserType.doctor.index;

  @Property(type: PropertyType.date)
  DateTime? lastLoginAt;

  @Property(type: PropertyType.date)
  DateTime createdAt = DateTime.now();

  bool isActive = true;
  String? refreshToken;

  @Transient()
  UserType get userType => UserType.values[userTypeIndex];

  @Transient()
  set userType(UserType value) {
    userTypeIndex = value.index;
  }

  @Transient()
  bool get authenticated => id != 0 && isActive;

  void updateLastLogin() {
    lastLoginAt = DateTime.now();
  }
}

enum UserType { doctor, patient }
