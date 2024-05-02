// ignore_for_file: unused_local_variable, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_connect/login_dir/provider/create_profile_provider.dart';
import 'package:player_connect/login_dir/services/login_api_service.dart';
import 'package:player_connect/shared/auth/routes.dart';
import 'package:player_connect/shared/constant/api_utils.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:player_connect/shared/constant/user_info.dart';
import 'package:player_connect/shared/auth/local_db_saver.dart';
import 'package:provider/provider.dart';

class SignUpApiService {
  static SignUpApiService? _instance;

  SignUpApiService._internal();

  static SignUpApiService getInstance() {
    _instance ??= SignUpApiService._internal();
    return _instance!;
  }

  Future? signUpData(context, email, password) async {
    try {
      var response = await http.post(Uri.parse(AppApiUtils.signUpUrl), body: {
        "email": email,
        "password": password,
        "fcm_token": UserDetails.userFcmToken,
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        LocalDataSaver.saveUserEmail(email);
        LocalDataSaver.saveUserPassword(password);
        await fetchDataSPreferences();
      } else {
        AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      }
    } catch (e) {
      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      return e;
    }
  }

  Future? loginSocialData(context, socialType, socialId, email) async {
    try {
      var response = await http.post(
        Uri.parse(AppApiUtils.socialLoginReq),
        body: {
          "social_type": socialType.toString(),
          "social_id": socialId.toString(),
          "role": "1",
          "email": email.toString(),
          "deviceToken": UserDetails.userFcmToken.toString(),
        },
      );
      final jsonResponse = jsonDecode(response.body);
      print("loginSocialData SignUp::${response.body}");

      if (response.statusCode == 200) {
        print("loginSocialData:body:${response.body}");

        AppSnackBarToast.buildShowSnackBar(context, "User login successfully");
        Navigator.pushNamed(context, AppRoutes.dashBoardPage);
        return;
      } else {
        print("loginSocialData:::::::${response.body}");
        Provider.of<CreateProfileProvider>(context, listen: false)
            .emailController
            .text = email;
        Provider.of<CreateProfileProvider>(context, listen: false).socialId =
            socialId.toString();
        Provider.of<CreateProfileProvider>(context, listen: false).socialType =
            socialType.toString();
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.verifiedPage, (route) => false);
        // AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
        return;
      }
    } catch (e) {
      print("loginSocialData:error:$e");

      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      return e;
    }
  }
}
