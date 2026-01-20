import 'package:chatify/service/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
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
    } catch (e) {
      debugPrint('SIGNUP ERROR: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await authService.signOut();
    _setLoading(false);
  }
}
