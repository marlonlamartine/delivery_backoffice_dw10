import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../core/exceptions/unauthorized_exception.dart';
import '../../services/auth/login_service.dart';
part 'login_controller.g.dart';

enum LoginstateStatus {
  initial,
  loading,
  success,
  error,
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final LoginService _loginService;

  @readonly
  var _loginStatus = LoginstateStatus.initial;

  @readonly
  String? _errorMessage;

  LoginControllerBase(this._loginService);

  @action
  Future<void> login(String email, String password) async {
    try {
      _loginStatus = LoginstateStatus.loading;
      await _loginService.execute(email, password);
      _loginStatus = LoginstateStatus.success;
    } on UnauthorizedException {
      _errorMessage = 'Login ou senha inválidos';
      _loginStatus = LoginstateStatus.error;
    } catch (e, s) {
      log('Erro ao realizar login', error: e, stackTrace: s);
      _errorMessage = 'Tenta novamente mais tarde';
      _loginStatus = LoginstateStatus.error;
    }
  }
}
