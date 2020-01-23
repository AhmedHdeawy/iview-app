import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../live_data.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/internet_connection.dart';
import '../services/toast_service.dart';

class NoInternetConnection extends StatefulWidget {
  NoInternetConnection({Key key}) : super(key: key);

  @override
  _NoInternetConnectionState createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size.width / 2,
              child: Image.asset('assets/images/no_internet.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontFamily: "URW Medium",
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Connect to a network and try again!',
              style: TextStyle(
                fontFamily: "URW Regular",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                bool connected = await InternetConnection.checkConnectivity();
                if (connected) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  String token = pref.getString('token');

                  if (pref.getString('favLang') == null) {
                    pref.setString('favLang', 'ar');
                  }
                  String favLan = pref.getString('favLang');
                  LiveData.favoriteLanguage = favLan;

                  if (token != null) {
                    LiveData.token = token;
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                } else {
                  showNoConnectionMessage();
                }
              },
              child: _buildTryAgainButton(size),
            ),
          ],
        ),
      ),
    );
  }

  void showNoConnectionMessage() {
    ToastService.showToast(context, 'No Internet Connection!');
  }

  Container _buildTryAgainButton(Size size) {
    return Container(
      height: size.height * 0.05,
      width: size.width * 0.3,
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
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Try Again!',
                style: TextStyle(
                  fontFamily: "URW Medium",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
