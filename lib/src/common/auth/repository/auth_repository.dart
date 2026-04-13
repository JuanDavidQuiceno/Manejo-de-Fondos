import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/models/user/user_model.dart';
import 'package:dashboard/src/core/models/api_response_model.dart';

abstract class AuthRepository {
  Future<void> logout();
  Future<String?> getAccessToken();
  Future<bool> handleTokenRefresh();
  Future<UserModel> validateToken();
  Future<void> validateAccount(String code);
  Future<ApiResponseModel<String>> resendValidationCode(String emailOrPhone);
  Future<UserModel> authenticateWithFirebase({
    required String firebaseToken,
    String? fcmToken,
    String? deviceType,
  });

  Stream<AuthStatus> get status;
}
