import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../live_data.dart';

class PostProvider with ChangeNotifier {
  int id;
  int categoryId;
  String title;
  String description;
  String createdAt;
  String name;
  int likesCount;
  int dislikesCount;
  bool isLiked;
  bool isDisliked;

  PostProvider(
      {this.id,
      this.categoryId,
      this.title,
      this.description,
      this.createdAt,
      this.name,
      this.likesCount,
      this.dislikesCount,
      this.isLiked,
      this.isDisliked});

  factory PostProvider.fromJson(Map<String, dynamic> json) {
    return PostProvider(
        id: json['id'],
        categoryId: json['category_id'],
        title: json['videos_title'],
        description: json['videos_desc'],
        createdAt: json['created_at'],
        name: json['videos_name'],
        likesCount: json['likes_count'],
        dislikesCount: json['dislikes_count'],
        isLiked: json['is_like'],
        isDisliked: json['is_dislike']);
  }

  void toggleLikeStatus() async {
    await toggleLike();
    notifyListeners();
  }

  Future toggleLike() async {
    String url = LiveData.serverUrl + 'likeVideo?video_id=${this.id}';
    var response = await http
        .get(url, headers: {'Authorization': 'Bearer ' + LiveData.token});

    final jsonData = json.decode(response.body);
    //print(jsonData);
    int code = jsonData['status'];
    if (code == 200) {
      if (isLiked) {
        isLiked = !isLiked;
        likesCount--;
      } else {
        isLiked = !isLiked;
        likesCount++;
        if (isDisliked) {
          isDisliked = !isDisliked;
          dislikesCount--;
        }
      }
    }
  }

  void toggleDislikeStatus() async {
    await toggleDislike();
    notifyListeners();
  }

  Future toggleDislike() async {
    String url = LiveData.serverUrl + 'dislikeVideo?video_id=${this.id}';
    var response = await http
        .get(url, headers: {'Authorization': 'Bearer ' + LiveData.token});

    final jsonData = json.decode(response.body);
    //print(jsonData);
    int code = jsonData['status'];
    if (code == 200) {
      if (isDisliked) {
        isDisliked = !isDisliked;
        dislikesCount--;
      } else {
        isDisliked = !isDisliked;
        dislikesCount++;
        if (isLiked) {
          likesCount--;
          isLiked = !isLiked;
        }
      }
    }
  }
}
