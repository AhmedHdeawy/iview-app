import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iview/live_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';
import '../services/internet_connection.dart';
import '../services/toast_service.dart';
import '../providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedLang;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController codeController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var loginProvider = Provider.of<LoginProvider>(context);
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildBackground(size),
            _buildHeader(size),
            SingleChildScrollView(
              child: Container(
                height: size.height,
                child: _loginForm(size, loginProvider),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        if (LiveData.favoriteLanguage == 'en') {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString('favLang', 'ar');
                          LiveData.favoriteLanguage = 'ar';
                          data.changeLocale(Locale('ar', 'EG'));
                        } else {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString('favLang', 'en');
                          LiveData.favoriteLanguage = 'en';
                          data.changeLocale(Locale('en', 'US'));
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: EdgeInsets.only(right: 30, left: 30),
                        width: 130,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0.00, 7.00),
                              color: Color(0xff000000).withOpacity(0.24),
                              blurRadius: 11,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.00),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).tr('changeLang'),
                              style: TextStyle(
                                fontFamily: "URW Regular",
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.language,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: 100, left: 30, right: 30),
      child: Text(
        AppLocalizations.of(context).tr('welcome'),
        style: TextStyle(
            color: Theme.of(context).backgroundColor,
            fontSize: size.width * 0.08,
            fontFamily: 'URW Medium'),
      ),
    );
  }

  Widget _loginForm(Size size, var loginProvider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.45,
        margin: EdgeInsets.only(bottom: 80),
        decoration: BoxDecoration(
            color: Color(0xFFffffff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 4.00),
                color: Color(0xff000000).withOpacity(0.24),
                blurRadius: 11,
              )
            ]),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: codeController,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).tr('enterCode'),
                      hintStyle: TextStyle(
                          color: Color(0xffababab),
                          fontSize: 14,
                          fontFamily: 'URW Medium'),
                      prefixIcon: Icon(Icons.card_membership,
                          color: Theme.of(context).primaryIconTheme.color,
                          size: 30),
                    ),
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: Color(0xffababab),
                        fontSize: 16,
                        fontFamily: 'URW Medium'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context).tr('enterCode');
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: passwordController,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.visiblePassword,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).tr('enterPassword'),
                      hintStyle: TextStyle(
                          color: Color(0xffababab),
                          fontSize: 14,
                          fontFamily: 'URW Medium'),
                      prefixIcon: Icon(Icons.lock,
                          color: Theme.of(context).primaryIconTheme.color,
                          size: 30),
                    ),
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: Color(0xffababab),
                        fontSize: 16,
                        fontFamily: 'URW Medium'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context).tr('enterPassword');
                      } else if (value.length < 6) {
                        return AppLocalizations.of(context)
                            .tr('enterValidPassword');
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      bool connected =
                          await InternetConnection.checkConnectivity();

                      if (connected) {
                        setState(() {
                          _isLoading = true;
                        });
                        // login logic here
                        await loginProvider
                            .login(codeController.text, passwordController.text)
                            .then((success) {
                          if (success) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            showWrongCredentialsMessage();
                          }
                        });
                      } else {
                        showNoConnectionMessage();
                      }
                    }

                    /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomeScreen())
                    );*/
                  },
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.00, 7.00),
                          color: Color(0xff000000).withOpacity(0.16),
                          blurRadius: 11,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.00),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.3,
                          child: Align(
                            alignment: Alignment.center,
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator())
                                : Text(
                                    AppLocalizations.of(context).tr('login'),
                                    style: TextStyle(
                                      fontFamily: "URW Bold",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showWrongCredentialsMessage() {
    ToastService.showToast(
        context, AppLocalizations.of(context).tr('wrongCredentials'));
  }

  void showNoConnectionMessage() {
    ToastService.showToast(
        context, AppLocalizations.of(context).tr('noConnection'));
  }

  Widget _buildBackground(Size size) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            //color: Color(0xFF364f6b),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 7.00),
                color: Color(0xff000000).withOpacity(0.24),
                blurRadius: 11,
              ),
            ],
          ),
        ),
        ClipPath(
          child: Container(
            height: size.height * 0.4,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          clipper: BottomWaveClipper(),
        ),
      ],
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
