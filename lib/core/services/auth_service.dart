import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../features/login/models/user.dart';

class AuthService {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = User(
        id: credential.user!.uid,
        email: credential.user!.email!,
        name: credential.user!.displayName,
        photoUrl: credential.user!.photoURL,
      );

      await FirebaseAnalytics.instance.setUserId(id: credential.user!.uid);
      await FirebaseAnalytics.instance.logEvent(
        name: 'login',
        parameters: {
          'method': 'email_password',
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = User(
        id: credential.user!.uid,
        email: credential.user!.email!,
        name: credential.user!.displayName,
        photoUrl: credential.user!.photoURL,
      );

      await FirebaseAnalytics.instance.setUserId(id: credential.user!.uid);
      await FirebaseAnalytics.instance.logEvent(
        name: 'sign_up',
        parameters: {
          'method': 'email_password',
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }
}
