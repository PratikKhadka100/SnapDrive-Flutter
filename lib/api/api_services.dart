import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../utils/snackbar_utils.dart';
import '../utils/custom_colors.dart';

class APIServices {
  // Login API
  static Future<http.Response> validateUser(
      BuildContext context, Map<String, dynamic> map, String userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const loginUrl = 'http://192.168.101.8:8000/api/login/';
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      await prefs.setString('user', userEmail);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          'Login successfull',
          Icons.check_circle_rounded,
          CustomColors.success,
        ),
      );
      Navigator.of(context).pushReplacementNamed(
        HomeScreen.routeName,
      );
    } else {
      Navigator.of(context).pop();
      if (jsonDecode(response.body)['detail'] ==
          'No active account found with the given credentials') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarUtils(
            context,
            'Incorrect email or password',
            Icons.dangerous_rounded,
            CustomColors.danger,
          ),
        );
      }
    }

    return response;
  }

  // Register API
  static Future<http.Response> createNewUser(
      BuildContext context, Map<String, dynamic> map) async {
    const registerUrl = 'http://192.168.101.8:8000/api/user/';
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          'Register successfull',
          Icons.check_circle_rounded,
          CustomColors.success,
        ),
      );

      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } else {
      if (jsonDecode(response.body)['email'][0] ==
          'This field must be unique.') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarUtils(
            context,
            'Email is already taken',
            Icons.dangerous_rounded,
            CustomColors.danger,
          ),
        );
      }
    }

    return response;
  }

  // Add Vehicle Data
  static Future<http.Response> addVehicle(
      BuildContext context, Map<String, dynamic> map) async {
    const addVehicleUrl = 'http://192.168.101.8:8000/api/vehicle/';
    final response = await http.post(
      Uri.parse(addVehicleUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          'Vehicle Added successfully',
          Icons.check_circle_rounded,
          CustomColors.success,
        ),
      );

      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else if (jsonDecode(response.body)['vin'][0] ==
        'vehicle with this vin already exists.') {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          'Vehicle with this VIN already exists',
          Icons.dangerous_rounded,
          CustomColors.danger,
        ),
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          'Failed to add vehicle',
          Icons.dangerous_rounded,
          CustomColors.danger,
        ),
      );
    }

    return response;
  }
}
