import 'dart:async';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../live_data.dart';
import '../screens/no_internet_screen.dart';
import '../services/internet_connection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> hasToken() async {
    //wait for 2 seconds anyway
    await Future.delayed(Duration(seconds: 2), () {});
    //do token stuff here
    SharedPreferences pref = await SharedPreferences.getInstance();
    //remove token for debug purpose only
    //pref.remove('token');
    //set peferences token
    String token = pref.getString('token');
    //set LiveData token to this token
    LiveData.token = token;

    if (pref.getString('favLang') == null) {
      pref.setString('favLang', 'ar');
    }

    String favLan = pref.getString('favLang');
    LiveData.favoriteLanguage = favLan;

    String phone = pref.getString('phone');
    //set LiveData token to this token
    LiveData.phone = phone;

    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  void navigateToAppScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void navigateToNoConnectionScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NoInternetConnection()));
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future checkInternetConnection() async {
    bool connected = await InternetConnection.checkConnectivity();

    var data = EasyLocalizationProvider.of(context).data;

    if (connected) {
      hasToken().then((status) {
        if (LiveData.favoriteLanguage == 'ar') {
          data.changeLocale(Locale('ar', 'EG'));
        } else {
          data.changeLocale(Locale('en', 'US'));
        }
        if (status) {
          navigateToAppScreen();
        } else {
          navigateToLoginScreen();
        }
      });
    } else {
      if (LiveData.favoriteLanguage == 'ar') {
        data.changeLocale(Locale('ar', 'EG'));
      } else {
        data.changeLocale(Locale('en', 'US'));
      }
      await Future.delayed(Duration(seconds: 2));
      navigateToNoConnectionScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset("assets/images/splash.png"),
              ),
            ),
            Text(
              "iView",
              style: TextStyle(
                fontFamily: "URW Bold",
                fontWeight: FontWeight.w700,
                fontSize: 36,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
