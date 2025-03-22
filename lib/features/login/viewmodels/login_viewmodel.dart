import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  bool isLoading = false;
  String? errorMessage;

  LoginViewModel(this._authService);

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    bool success = await _authService.login(email, password);

    isLoading = false;
    if (!success) {
      errorMessage = "Credenciales incorrectas";
    }
    notifyListeners();
    return success;
  }
}
