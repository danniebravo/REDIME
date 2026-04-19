import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource dataSource;
  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<UserProfileEntity> getProfile() async {
    return await dataSource.getProfile();
  }

  @override
  Future<void> updateProfile(UserProfileEntity profile) async {
    final model = UserProfileModel(
      id: profile.id,
      nombres: profile.nombres,
      apellidos: profile.apellidos,
      celular: profile.celular,
      correo: profile.correo,
    );
    await dataSource.updateProfile(model);
  }

  @override
  Future<void> deleteAccount(String email, String password) async {
    await dataSource.deleteAccount(email, password);
  }
}