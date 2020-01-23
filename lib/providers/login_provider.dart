import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../live_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  bool _loggedInSuccessfully = false;

  Future<bool> login(String code, String password) async {
    int c;
    String url = LiveData.serverUrl + 'auth/login';
    await http.post(url, headers: {
      'Accept': 'application/json',
    }, body: {
      "code": code,
      "password": password,
      "remember_me": '1'
    }).then((response) async {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      c = jsonData['status'];
      if (c == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String token = jsonData['data']['token']['access_token'];
        String phone = jsonData['data']['user']['phone'];
        pref.setString('token', token);
        pref.setString('phone', phone);
        LiveData.token = token;
        LiveData.phone = phone;
        print("$jsonData");

        _loggedInSuccessfully = true;
        return _loggedInSuccessfully;
      }
      _loggedInSuccessfully = false;
      return _loggedInSuccessfully;
    });
    print(c);
    return _loggedInSuccessfully;
  }
}
