import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool isLoading = false;
  String? errorMessage;

  LoginViewModel(this._authService);

  Future<void> login(BuildContext context, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final (success, error) = await _authService.login(email, password);

    isLoading = false;
    if (success) {
      Navigator.restorablePushReplacementNamed(context, '/homeView');
    } else {
      errorMessage = error;
    }
    notifyListeners();
  }

  Future<void> register(BuildContext context, String email, String password, String displayName) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final (success, error) = await _authService.register(email, password);

    isLoading = false;
    if (success) {
      Navigator.restorablePushReplacementNamed(context, '/');
    } else {
      errorMessage = error ?? "Error al registrar el usuario";
    }
    notifyListeners();
  }
}
