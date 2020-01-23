import '../widgets/post.dart';

import '../providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsList extends StatefulWidget {
  final List<PostProvider> posts;
  PostsList(this.posts);
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider<PostProvider>.value(
        value: widget.posts[i],
        child: Post(),
      ),
    );
  }
}
