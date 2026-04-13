// (Usando el ejemplo anterior)
class LoginModel {
  LoginModel({this.email = '', this.password = '', this.rememberMe = false});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  final String email;
  final String password;
  final bool rememberMe;

  // copyWith para crear una nueva instancia con algunos campos modificados
  LoginModel copyWith({String? email, String? password, bool? rememberMe}) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
