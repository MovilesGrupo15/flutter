import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      await FirebaseAnalytics.instance.logEvent(
        name: 'login',
        parameters: {'method': 'email_password'},
      );

      await FirebaseAnalytics.instance.logEvent(
        name: 'test_event',
        parameters: {
          'value': 'debug_view_test',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );


      return true;
    } catch (e) {
      print("Error en login: $e");
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

      // Guarda los datos del usuario en Firestore
      await uploadUserData(_currentUser!);

      await FirebaseAnalytics.instance.setUserId(id: credential.user!.uid);
      await FirebaseAnalytics.instance.logEvent(
        name: 'sign_up',
        parameters: {'method': 'email_password'},
      );

      return true;
    } catch (e) {
      print("Error en register: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  Future<bool> uploadUserData(User user) async {
    try {
      // Obtén la instancia de Firestore
      print(FirebaseFirestore.instance.app.options.projectId);

      final firestore = FirebaseFirestore.instance;

      // Guarda los datos del usuario en la colección "usuarios"
      await firestore.collection('usuarios').doc(user.id).set({
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'photoUrl': user.photoUrl,
      });
      print(user.id);
      print(user.name);
      print(user.email);
      print(user.photoUrl);

      print("Usuario guardado correctamente en Firestore");
      return true;
    } catch (e) {
      print("Error al subir los datos del usuario a Firestore: $e");
      return false;
    }
  }
}
