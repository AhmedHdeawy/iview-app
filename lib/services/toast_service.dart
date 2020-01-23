import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastService {
  static void showToast(BuildContext context, String message) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Color(0xFFfc5185),

    );
  }
}
