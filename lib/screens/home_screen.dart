import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../live_data.dart';
import '../providers/home_provider.dart';
import '../screens/login_screen.dart';

import '../widgets/posts_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  TextEditingController searchController = TextEditingController();

  String _headerText;

  String searchValue;

  int _selectedCategoryId;

  int status = 0;

  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final homeProvider = Provider.of<HomeProvider>(context);
    Future homeFuture;
    if (!_isLoggingOut) {
      homeFuture = Future.delayed(Duration(milliseconds: 10));
      if (status == 2) {
        homeFuture = homeProvider.getSearchPosts(searchValue);
      } else if (status == 1) {
        homeFuture = homeProvider.getHomeData();
        homeFuture = homeProvider.getCategoryPosts(_selectedCategoryId + 1);
      } else {
        _headerText = AppLocalizations.of(context).tr('allVideos');
        homeFuture = homeProvider.getHomeData();
      }
    }
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          drawer: _buildDrawer(size, homeProvider, homeFuture, data),
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            leading: InkWell(
              child: Icon(
                Icons.menu,
                size: 30,
                color: Colors.white,
              ),
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.home,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    searchController.clear();
                    status = 0;
                  });
                },
              ),
            ],
            title: Text(
              'iView',
              style: TextStyle(
                  fontSize: 24, color: Colors.white, fontFamily: 'URW Medium'),
            ),
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.00, 7.00),
                      color: Color(0xff000000).withOpacity(0.16),
                      blurRadius: 11,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    //SizedBox(height: 10),
                    _buildSearchInput(size),
                    SizedBox(height: 10),
                    Text(
                      _headerText,
                      style: TextStyle(
                        fontFamily: "URW Medium",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: homeFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                      child: getProperList(homeProvider),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Container();
                },
              ),

              /* Expanded(
                child: FutureBuilder(
                  future: homeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<PostProvider> list = _isCategory
                          ? homeProvider.categoryPostsList
                          : homeProvider.postsList;
                      if (list.length > 0) {
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (ctx, i) =>
                              ChangeNotifierProvider<PostProvider>.value(
                            value: list[i],
                            child: Post(),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No data!',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  },
                ),
              ), */
            ],
          )),
    );
  }

  Widget getProperList(HomeProvider homeProvider) {
    if (status == 1) {
      return PostsList(homeProvider.categoryPostsList);
    } else if (status == 2) {
      if (homeProvider.searchPostsList.length != 0) {
        return PostsList(homeProvider.searchPostsList);
      } else {
        return Center(
            child: Text(
          AppLocalizations.of(context).tr('noResults'),
          style: TextStyle(
              color: Colors.black54, fontFamily: 'URW Medium', fontSize: 16),
        ));
      }
    } else {
      return PostsList(homeProvider.postsList);
    }
  }

  Widget _buildDrawer(Size size, HomeProvider homeProvider, homeFuture, data) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
              ])),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.portrait, color: Colors.white, size: 50),
                        Text(LiveData.phone,
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              margin: EdgeInsets.only(right: 30, left: 30),
                              width: 100,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr('changeLang'),
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
                          ),
                          RaisedButton(
                            color: Color(0xff364f6b),
                            child: _isLoggingOut
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator())
                                : Text(
                                    AppLocalizations.of(context).tr('logout'),
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                            onPressed: () async {
                              setState(() {
                                _isLoggingOut = true;
                              });
                              homeProvider.logout().then((success) async {
                                if (success) {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.remove('token');
                                  LiveData.token = null;
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    /* Text(
                      'Our Courses',
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ) */
                  ],
                ),
              ),
              /* child: Container(
                height: size.height * 0.2,
                width: double.infinity,
                child: Image.asset('assets/images/drawer_image.png'),
              ), */
            ),
            Expanded(
              child: FutureBuilder(
                future: homeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (homeProvider.categoriesList.length > 0) {
                      return ListView.builder(
                        itemCount: homeProvider.categoriesList.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(homeProvider.categoriesList[i].title),
                          trailing: Icon(
                            Icons.playlist_play,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _headerText =
                                  homeProvider.categoriesList[i].title;
                              status = 1;
                              _selectedCategoryId = i;
                              searchController.clear();
                            });
                          },
                        ),
                        /* ChangeNotifierProvider<CategoryProvider>.value(
                          value: homeProvider.categoriesList[i],
                          child: Category(),
                        ), */
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No data!',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      );
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput(Size size) {
    return Container(
      width: size.width * 0.8,
      height: 40,
      child: TextFormField(
        controller: searchController,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context).tr('search'),
            hintStyle: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'URW Medium'),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.white),
            ),
            prefixIcon: Icon(Icons.search, color: Colors.white, size: 20)),
        //textDirection: TextDirection.ltr,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontFamily: 'URW Medium'),
        autofocus: false,
        onFieldSubmitted: (value) {
          if (searchController.text != '') {
            setState(() {
              searchValue = searchController.text;
              _headerText = AppLocalizations.of(context).tr('searchResults');
              status = 2;
              print(searchValue);
            });
          }
        },
      ),
    );
  }
}
