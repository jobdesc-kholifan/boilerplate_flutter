import 'dart:async';

import 'package:get/get.dart';

import '../contracts/auth/guard_contract.dart';
import '../contracts/auth/login_view_contract.dart';
import '../contracts/auth/logout_view_contract.dart';
import '../models/masters/user_model.dart';
import '../services/auth_service.dart';
import '../utils/custom_get_controller.dart';
import '../utils/session_manager.dart';
import '../views/signin/_source.dart';

class AuthPresenter extends CustomGetXController {
  final _authService = Get.find<AuthService>();

  final source = LoginSource().obs;

  late LoginViewContract _loginViewContract;
  set loginViewContract(LoginViewContract loginViewContract) =>
      _loginViewContract = loginViewContract;

  late LogoutViewContract _logoutViewContract;
  set logoutViewContract(LogoutViewContract logoutViewContract) =>
      _logoutViewContract = logoutViewContract;

  late GuardContract _guardContract;
  set guardContract(GuardContract guardContract) =>
      _guardContract = guardContract;

  void togglePassword() {
    source.update((val) {
      source.value.showPassword = !source.value.showPassword;
    });
  }

  void signIn() {
    _authService
        .signIn(
          source.value.inputUsername.text,
          source.value.inputPassword.text,
        )
        .then((value) => value.body != null
            ? _loginViewContract.onLoginSuccess(UserModel.fromJson(value.body))
            : _loginViewContract.onErrorResponse())
        .catchError(
          (message) => _loginViewContract.onLoginFailed(message),
        );
  }

  void signOut() {
    _authService.signOut().then((res) {
      _logoutViewContract.onLogoutSuccess();
      isAuthenticated.value = false;
    });
  }

  final isAuthenticated = true.obs;
  final statusCode = 0.obs;

  void checkApiSession() async {
    try {
      if (await SessionManager.isLogged()) {
        _authService
            .verifyToken()
            .timeout(Duration(seconds: 30))
            .then((res) => _guardContract.onCheckSuccess(isOk: res.isOk));
      } else {
        _guardContract.onCheckSuccess(isOk: false);
      }
    } on TimeoutException catch (_) {
      _guardContract.onCheckTimeout();
    } catch (e) {
      _guardContract.onCheckInternalError();
    }
  }

  void checkLocalSession() async {
    try {
      SessionManager.isLogged()
          .then((value) => _guardContract.onCheckSuccess(isOk: value));
    } catch (e) {
      _guardContract.onCheckFailed();
    }
  }
}
