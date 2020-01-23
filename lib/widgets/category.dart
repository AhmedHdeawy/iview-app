import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class Category extends StatelessWidget {
  const Category({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context);
    return ListTile(
      title: Text(category.title),
      trailing: Icon(
        Icons.playlist_play,
        size: 30,
      ),
      onTap: () {},
    );
  }
}
