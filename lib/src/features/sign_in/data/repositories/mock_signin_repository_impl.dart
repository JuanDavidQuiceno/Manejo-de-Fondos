import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/features/sign_in/domain/models/signin_model.dart';
import 'package:dashboard/src/features/sign_in/domain/repository/signin_repository.dart';

class MockSignInRepositoryImpl implements SignInRepository {
  @override
  Future<UserModel> signIn(LoginModel loginModel) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    return UserModel(
      email: loginModel.email,
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
