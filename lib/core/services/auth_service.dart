import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<(bool, String?)> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return (true, null);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return (false, 'La contraseña es muy débil.');
        case 'email-already-in-use':
          return (false, 'Este correo ya está registrado.');
        case 'invalid-email':
          return (false, 'El correo electrónico no es válido.');
        default:
          return (false, 'Error al registrar: ${e.message}');
      }
    } catch (_) {
      return (false, 'Ocurrió un error inesperado. Intenta de nuevo.');
    }
  }

  Future<(bool, String?)> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return (true, null);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          return (false, 'Correo o contraseña incorrectos.');
        case 'invalid-email':
          return (false, 'Correo electrónico inválido.');
        default:
          return (false, 'Error al iniciar sesión: ${e.message}');
      }
    } catch (_) {
      return (false, 'Error inesperado. Intenta de nuevo.');
    }
  }
}
