import 'dart:convert';

import '../providers/category_provider.dart';

import '../live_data.dart';

import '../providers/post_provider.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomeProvider with ChangeNotifier {
  List<PostProvider> _postsList = [];
  List<PostProvider> get postsList {
    return [..._postsList];
  }

  List<PostProvider> _categoryPostsList = [];
  List<PostProvider> get categoryPostsList {
    return [..._categoryPostsList];
  }

  List<PostProvider> _searchPostsList = [];
  List<PostProvider> get searchPostsList {
    return [..._searchPostsList];
  }

  List<CategoryProvider> _categoriesList = [];
  List<CategoryProvider> get categoriesList {
    return [..._categoriesList];
  }

  Future getHomeData() async {
    String url = LiveData.serverUrl + 'home';
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer ' + LiveData.token});

    final jsonData = json.decode(response.body);
    //print(jsonData);
    int code = jsonData['status'];
    if (code == 200) {
      _postsList = [];
      _categoriesList = [];
      await _getPosts(jsonData);
      await _getCategories(jsonData);
    }
  }

  Future getCategoryPosts(int categoryId) async {
    String url = LiveData.serverUrl + 'category?id=${categoryId.toString()}';
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer ' + LiveData.token});

    final jsonData = json.decode(response.body);
    //print(jsonData);
    int code = jsonData['status'];
    if (code == 200) {
      _categoryPostsList = [];
      List jsonPosts = jsonData['data']['videos'];
      jsonPosts.forEach((post) {
        PostProvider p = PostProvider.fromJson(post);
        _categoryPostsList.add(p);
      });
    }
  }

  Future getSearchPosts(String value) async {
    String url = LiveData.serverUrl + 'search?text=$value';
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer ' + LiveData.token});

    final jsonData = json.decode(response.body);
    //print(jsonData);
    int code = jsonData['status'];
    if (code == 200) {
      _searchPostsList = [];
      List jsonPosts = jsonData['data']['videos'];
      jsonPosts.forEach((post) {
        PostProvider p = PostProvider.fromJson(post);
        _searchPostsList.add(p);
      });
    }
  }

  Future _getCategories(jsonData) async {
    List categoryPosts = jsonData['data']['categories'];
    categoryPosts.forEach((category) {
      CategoryProvider c = CategoryProvider.fromJson(category);
      _categoriesList.add(c);
    });
  }

  Future _getPosts(jsonData) async {
    List jsonPosts = jsonData['data']['videos'];
    jsonPosts.forEach((post) {
      PostProvider p = PostProvider.fromJson(post);
      _postsList.add(p);
    });
  }

  Future<bool> logout() async {
    String url = LiveData.serverUrl + 'logout';
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer ' + LiveData.token});

    final jsonData = json.decode(response.body);
    //print(jsonData);
    int code = jsonData['status'];
    if (code == 200) {
      return true;
    }
    return false;
  }
}
