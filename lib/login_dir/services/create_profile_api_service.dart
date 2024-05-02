// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:player_connect/login_dir/provider/create_profile_provider.dart';
import 'package:player_connect/login_dir/services/login_api_service.dart';
import 'package:player_connect/shared/auth/routes.dart';
import 'package:player_connect/shared/constant/api_utils.dart';
import 'package:player_connect/shared/constant/app_details.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:player_connect/shared/constant/user_info.dart';
import 'package:provider/provider.dart';

class CreateProfileApiService {
  static CreateProfileApiService? _instance;

  CreateProfileApiService._internal();

  static CreateProfileApiService getInstance() {
    _instance ??= CreateProfileApiService._internal();
    return _instance!;
  }

  Future? createProfile(
    context,
    String fName,
    String lName,
    String email,
    String phone,
    File image,
    String about,
    String dob,
    String height,
    String password,
    int gender,
    String city,
    String country,
    String countryCode,
    String countryFlag,
    int ratingType,
    String rating,
    int locationRange,
    String desPartner,
    String playingStyle,
    String domHand,
    String socialType,
    String socialId,

  ) async {
    try {
      final url = Uri.parse(AppApiUtils.signUpUrl);
      final formData = http.MultipartRequest('POST', url);
      formData.files
          .add(await http.MultipartFile.fromPath('images', image.path));
      formData.fields.addAll({
        "first_name": fName,
        "last_name": lName,
        "email": email,
        "phone": phone,
        // "images": image,
        "dob": dob,
        "height": height,
        "country": country,
        "country_code": countryCode,
        "country_flag": countryFlag,
        "password": password.isEmpty?"12345678":password,
        "role": "1",
        "gender": gender.toString(),
        "rating": rating,
        "city": city,
        "about": about,
        "desired_partner": desPartner,
        "playingstyle": playingStyle,
        "dominnant_hand": domHand,
        "location_range": locationRange.toString(),
        "ratingtype": ratingType.toString(),
        "latitude": UserDetails.userLatitude.toString(),
        "longitude": UserDetails.userLongitude.toString(),
        "deviceToken": UserDetails.userFcmToken.toString(),
        "social_type": socialType,
        "social_id": socialId,
        // "longitude": "76.7914",
      });
      final response = await http.Response.fromStream(await formData.send());

// var response = await http.post(Uri.parse(AppApiUtils.signUpUrl), body: requestBody);
//       print(response.body);
//       print(response.statusCode);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        pageSelected = 0;
       await LoginApiService.getInstance().loginData(context, email, password);
        Provider.of<CreateProfileProvider>(context, listen: false).clearData();

        // Navigator.pushNamedAndRemoveUntil(context,
        //     AppRoutes.dashBoardPage, (route) => false);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, AppRoutes.loginPage, (route) => false);
        // AppSnackBarToast.buildShowSnackBar(context, "SignUp Successfully");
      } else if (jsonResponse["message"].toString() ==
          "Please used another number this number is already exits") {
        AppSnackBarToast.buildShowSnackBar(
            context, "Please used another number this number is already exits");
      } else if (jsonResponse["message"].toString() == "Email Already exits") {
        AppSnackBarToast.buildShowSnackBar(
            context, "Please used another Email this email is already exits");
      } else {
        // print("eeerreee:${response.body}");
        AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      }
    } catch (e) {
      print("eeeeee:$e");
      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      return e;
    }
  }
}

// async {
// try {
// final url = Uri.parse(AppApiUtils.signUpUrl);
// final formData = http.MultipartRequest('POST', url);
//
// formData.fields.addAll({
// "first_name": fName,
// "last_name": lName,
// "email": "saaddd@gmail.com",
// "phone": phone.toString(),
// "images": image.toString(),
// "dob": dob,
// "height": height,
// "country": country,
// "country_code": countryCode,
// "country_flag": countryFlag,
// "password": password,
// "role": "1",
// "gender": gender.toString(),
// "rating": rating,
// "city": city,
// "about": about,
// "desired_partner": desPartner,
// "playingstyle": playingStyle,
// "dominnant_hand": domHand,
// "location_range": locationRange.toString(),
// "ratingtype": ratingType.toString(),
// });
// final response = await http.Response.fromStream(await formData.send());
//
// // var response = await http.post(Uri.parse(AppApiUtils.signUpUrl), body: requestBody);
//
// print(response.body);
// print(response.statusCode);
// if (response.statusCode == 200) {
// final jsonResponse = jsonDecode(response.body);
// } else {
// // AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
// }
// } catch (e) {
// print("eeeeee:$e");
//
// // AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
// return e;
// }
// }
