import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/features/sign_in/domain/models/signin_model.dart';
import 'package:dashboard/src/features/sign_in/domain/repository/signin_repository.dart';

class MockSignInRepositoryImpl implements SignInRepository {
  static const _validEmail = 'admin@test.com';
  static const _validPassword = 'Admin1234';

  @override
  Future<UserModel> signIn(LoginModel loginModel) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (loginModel.email != _validEmail ||
        loginModel.password != _validPassword) {
      throw Exception(
        'Credenciales inválidas. Usa $_validEmail / $_validPassword',
      );
    }

    return UserModel(
      email: _validEmail,
      name: 'Admin',
      lastName: 'Prototipo',
      role: RoleModel(
        id: 'mock-role-1',
        name: 'Administrador',
        slug: 'admin',
        description: 'Rol de administrador del sistema',
      ),
    );
  }
}
