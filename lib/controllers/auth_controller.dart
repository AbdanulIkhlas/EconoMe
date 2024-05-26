import 'package:flutter/material.dart';
import '../database/admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login_screen.dart';
import '../views/bottom_navbar.dart';

class AuthController {
  final AdminService _adminService = AdminService();
  static const int _cipherKey = 5;

  String _encryptPassword(String password) {
    String encryptedPassword = '';
    for (int i = 0; i < password.length; i++) {
      int charCode = password.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        encryptedPassword +=
            String.fromCharCode((charCode - 65 + _cipherKey) % 26 + 65);
      } else if (charCode >= 97 && charCode <= 122) {
        encryptedPassword +=
            String.fromCharCode((charCode - 97 + _cipherKey) % 26 + 97);
      } else {
        encryptedPassword += password[i];
      }
    }
    return encryptedPassword;
  }

  String _decryptPassword(String encryptedPassword) {
    String decryptedPassword = '';
    for (int i = 0; i < encryptedPassword.length; i++) {
      int charCode = encryptedPassword.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        decryptedPassword +=
            String.fromCharCode((charCode - 65 - _cipherKey) % 26 + 65);
      } else if (charCode >= 97 && charCode <= 122) {
        decryptedPassword +=
            String.fromCharCode((charCode - 97 - _cipherKey) % 26 + 97);
      } else {
        decryptedPassword += encryptedPassword[i];
      }
    }
    return decryptedPassword;
  }

  Future<void> login(
      BuildContext context, String username, String password) async {
    try {
      final response =
          await _adminService.verifyLogin(username, _encryptPassword(password));
      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('admin_id', response.id);
        prefs.setString('admin_username', response.username);
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

  Future<void> register(
      BuildContext context, String username, String password) async {
    try {
      final encryptedPassword = _encryptPassword(password);
      final response =
          await _adminService.register(username, encryptedPassword);
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

  String getEncryptedPassword(String password) {
    return _encryptPassword(password);
  }

  String getDecryptedPassword(String encryptedPassword) {
    return _decryptPassword(encryptedPassword);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_username');
  }

  Future<String?> getEncryptedPasswordFromDB(String username) async {
    final encryptedPassword =
        await _adminService.getPasswordByUsername(username);
    return encryptedPassword;
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
