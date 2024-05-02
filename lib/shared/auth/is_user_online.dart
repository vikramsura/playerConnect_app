// ignore_for_file: unused_local_variable, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_connect/shared/auth/routes.dart';
import 'package:player_connect/shared/constant/api_utils.dart';
import 'package:player_connect/shared/constant/app_strings.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:player_connect/shared/constant/user_info.dart';
import 'package:player_connect/shared/auth/local_db_saver.dart';

class UserOnlineApiService {
  static UserOnlineApiService? _instance;

  UserOnlineApiService._internal();

  static UserOnlineApiService getInstance() {
    _instance ??= UserOnlineApiService._internal();
    return _instance!;
  }

  Future? isUserOnline(id) async {
    try {
      var response = await http.post(
        Uri.parse(AppApiUtils.isUserOnlineStatusApi),
        headers: {
          'Authorization': 'Bearer ${UserDetails.userAuthToken.toString()}',
        },
        body: {
          "is_online": id.toString(),
        },
      );
      if (response.statusCode == 200) {
        print("isUserOnline.body::${response.body}");
        return;
      } else {
        print("isUserOnline.body::${response.body}");
        return;
      }
    } catch (e) {
      print("isUserOnline.error::$e");

      return e;
    }
  }
}
