import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/features/sign_in/domain/models/signin_model.dart';

abstract class SignInRepository {
  Future<UserModel> signIn(LoginModel loginModel);
}
