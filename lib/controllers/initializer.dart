import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../views/register_screen.dart';
import '../views/login_screen.dart';
import '../views/bottom_navbar.dart';

class Initializer extends StatefulWidget {
  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  AuthController _authController = AuthController();
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final isAdminExist = await _authController.isAdminExist();
    final isAdminLoggedIn = await _authController.isLoggedIn();

    if (!isAdminExist) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    } else if (!isAdminLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavbar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
