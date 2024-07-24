import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para registrar usuarios
  Future<User?> registerWithEmailAndPassword(
      String email, String password, Map<String, dynamic> userInfo) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Guardar información adicional del usuario en Firestore, sin la contraseña
      await _firestore.collection('Users').doc(user?.uid).set(userInfo);

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Método para iniciar sesión
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
