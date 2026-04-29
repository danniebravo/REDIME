import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getProfile();
  Future<void> updateProfile(UserProfileEntity profile);
  Future<void> deleteAccount(String email, String password);
}