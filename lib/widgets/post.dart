import 'package:chewie/chewie.dart';
import 'package:iview/live_data.dart';
import 'package:video_player/video_player.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';

class Post extends StatefulWidget {
  Post({Key key}) : super(key: key);

  VideoPlayerController _videoPlayerController;

  ChewieController chewieController() {
    return ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,

      //startAt: Duration(seconds: 1),
      // Try playing around with some of these other options:
      allowedScreenSleep: false,

      allowFullScreen: false,

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Color(0xFF3fc1c9),
        handleColor: Color(0xFFfc5185),
        backgroundColor: Colors.grey,
        bufferedColor: Colors.black45,
      ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      autoInitialize: true,
    );
  }

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  void dispose() {
    widget._videoPlayerController.dispose();
    widget.chewieController().dispose();
    super.dispose();
  }

  var post;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    post = Provider.of<PostProvider>(context, listen: false);
    widget._videoPlayerController =
        VideoPlayerController.network(LiveData.STORAGE_PATH + post.name);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Chewie(
            controller: widget.chewieController(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            post.title,
            style: TextStyle(fontSize: 14, fontFamily: 'URW Regular'),
          ),
          SizedBox(
            height: 5,
          ),
          post.description != null
              ? Text(
                  post.description,
                  style: TextStyle(fontSize: 12, fontFamily: 'URW Regular'),
                )
              : Container(),
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              Consumer<PostProvider>(
                builder: (ctx, post, child) => IconButton(
                  icon: Icon(
                    post.isLiked
                        ? CommunityMaterialIcons.thumb_up
                        : CommunityMaterialIcons.thumb_up_outline,
                    color: Theme.of(context).primaryColor,
                    size: 35,
                  ),
                  onPressed: () {
                    post.toggleLikeStatus();
                  },
                ),
              ),
              SizedBox(width: 15),
              Consumer<PostProvider>(
                builder: (ctx, post, child) => Text(
                  post.likesCount.toString(),
                  style: TextStyle(fontSize: 16, fontFamily: 'URW Regular'),
                ),
              ),
              SizedBox(width: 50),
              Consumer<PostProvider>(
                builder: (ctx, post, child) => IconButton(
                  icon: Icon(
                    post.isDisliked
                        ? CommunityMaterialIcons.thumb_down
                        : CommunityMaterialIcons.thumb_down_outline,
                    color: Theme.of(context).accentColor,
                    size: 35,
                  ),
                  onPressed: () {
                    post.toggleDislikeStatus();
                  },
                ),
              ),
              SizedBox(width: 15),
              Consumer<PostProvider>(
                builder: (ctx, post, child) => Text(
                  post.dislikesCount.toString(),
                  style: TextStyle(fontSize: 16, fontFamily: 'URW Regular'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
