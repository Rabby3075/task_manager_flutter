import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

import 'network_response.dart';

class NetworkCaller {
  Future<NetworkResponse> postRequest(String url,
      {Map<String, dynamic>? body, bool isLogin = false}) async {
    try {
      log(url);
      log('token: ${AuthController.token.toString()}');
      log('body: ${body.toString()}');
      final Response response = await post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            'Content-type': 'Application/json',
            'token': AuthController.token.toString()
          });
      log(response.body.toString());
      log('Status code: ${response.statusCode.toString()}');
      if (response.statusCode == 200) {
        return NetworkResponse(
            isSuccess: true,
            jsonResponse: jsonDecode(
              response.body,
            ),
            statusCode: response.statusCode);
      } else if (response.statusCode == 401) {
        if (!isLogin) {
          backToLogin();
        }
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(
              response.body,
            ),
            statusCode: response.statusCode);
      } else {
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(
              response.body,
            ),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<NetworkResponse> getRequest(String url) async {
    try {
      log(url);
      log('token: ${AuthController.token.toString()}');
      final Response response = await get(Uri.parse(url), headers: {
        'Content-type': 'Application/json',
        'token': AuthController.token.toString()
      });
      log(response.body.toString());
      log('Status code: ${response.statusCode.toString()}');
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody['status'] == 'success') {
          return NetworkResponse(
              isSuccess: true,
              jsonResponse: jsonDecode(
                response.body,
              ),
              statusCode: response.statusCode);
        } else {
          return NetworkResponse(
              isSuccess: false,
              jsonResponse: jsonDecode(
                response.body,
              ),
              statusCode: response.statusCode);
        }
      } else if (response.statusCode == 401) {
        backToLogin();
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(
              response.body,
            ),
            statusCode: response.statusCode);
      } else {
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(
              response.body,
            ),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<void> backToLogin() async {
    await AuthController.ClearAuthData();
    Navigator.pushAndRemoveUntil(
        TaskManager.navigationKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
