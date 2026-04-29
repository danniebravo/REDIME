import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<UserProfileEntity> call() => repository.getProfile();
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<void> call(UserProfileEntity profile) =>
      repository.updateProfile(profile);
}

class DeleteAccountUseCase {
  final ProfileRepository repository;
  DeleteAccountUseCase(this.repository);

  Future<void> call(String email, String password) =>
      repository.deleteAccount(email, password);
}