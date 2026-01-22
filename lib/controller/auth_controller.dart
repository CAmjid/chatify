import 'package:chatify/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      final credential = await authService.signinData(email, password);
      return credential.user != null;
    } catch (e) {
      print('SignIn Error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _setLoading(true);
      final credential = await authService.signupData(name, email, password);
      return credential.user != null;
    } on FirebaseAuthException catch (e) {
      debugPrint('SIGNUP ERROR: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('SIGNUP ERROR: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await authService.signOut();
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _setLoading(false);
    }
  }
}
