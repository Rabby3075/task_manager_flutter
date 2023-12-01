import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController{
  static String? token;
  static UserModel? user;
  static Future<void> SaveUserInformation(String t, UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', t);
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    token = t;
    user = model;
  }
  static Future<void> UpdateUserInformation(UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    user = model;
  }
  static Future<void>InitializedUserCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
     user = UserModel.fromJson(jsonDecode(sharedPreferences.getString('user')??'{}'));
  }
  static Future<bool> checkAuthState() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String?token = sharedPreferences.getString('token');
    if(token != null){
      await InitializedUserCache();
      return true;
    }
    return false;
  }
  static Future<void> ClearAuthData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
    user = null;
  }

}
