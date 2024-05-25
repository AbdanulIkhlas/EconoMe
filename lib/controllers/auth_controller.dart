import 'package:flutter/material.dart';
import '../database/admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login_screen.dart';
import '../views/bottom_navbar.dart';

class AuthController {
  final AdminService _adminService = AdminService();

  Future<void> login(
      BuildContext context, String username, String password) async {
    try {
      final response = await _adminService.verifyLogin(username, password);
      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('admin_id', response.id);
        prefs.setString('admin_username', response.username);
        // prefs.setString('admin', response);
        String? username = prefs.getString('admin_username');
        print(username);
        print('Login successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return BottomNavbar();
          }),
        );
      } else {
        print('Invalid credentials');
        throw ('Invalid username or password');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Error : $e'),
        ),
      );
      print('Login error : $e');
    }
  }

  Future<bool> verifyAdmin(
      BuildContext context, String username, String password) async {
    try {
      final response = await _adminService.verifyLogin(username, password);
      if (response != null) {
        return true;
      } else {
        print('Invalid credentials');
        throw ('Invalid username or password');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verify Error : $e'),
        ),
      );
      return false;
    }
  }

  Future<void> register(BuildContext context, username, String password) async {
    try {
      final response = await _adminService.register(username, password);
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Register Success'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }),
        );

        print('Register successful');
      } else {
        throw ('Register failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register Error : $e'),
        ),
      );
      print('Register error : $e');
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout Success'),
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('admin_id');
    } catch (e) {
      print('isLogin Error : $e');
      return false;
    }
  }

  Future<bool> isAdminExist() async {
    try {
      return _adminService.checkAdminExist();
    } catch (e) {
      print('is admin exist Error : $e');
      return false;
    }
  }
}
