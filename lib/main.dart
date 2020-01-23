import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './providers/category_provider.dart';
import './providers/home_provider.dart';
import './providers/post_provider.dart';
import './screens/splash_screen.dart';

import './providers/login_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(EasyLocalization(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => HomeProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => PostProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CategoryProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'iView',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xFF3fc1c9),
              accentColor: Color(0xFFfc5185),
              backgroundColor: Color(0xFFf5f5f5),
              primaryIconTheme: IconThemeData(color: Color(0xFFABABAB))),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasylocaLizationDelegate(
              locale: data.locale,
              path: 'lang',
            )
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'EG'),
          ],
          locale: data.savedLocale,
          //locale: Locale('en', 'US'),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
