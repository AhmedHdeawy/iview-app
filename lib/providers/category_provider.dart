import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  int id;
  String title;

  CategoryProvider({this.id, this.title});

  factory CategoryProvider.fromJson(Map<String, dynamic> json) {
    return CategoryProvider(id: json['id'], title: json['categories_title']);
  }
}
