// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:player_connect/login_dir/provider/create_profile_provider.dart';
import 'package:player_connect/login_dir/services/signUp_api_service.dart';
import 'package:player_connect/shared/auth/local_db_saver.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/twitter_login.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isShowPassword = true;
  bool isLoading = false;
  final String apiKey = 'oQRFt2Uk6QtBqQege9QFvDEdV';
  final String apiSecretKey =
      'NyigIwTXT2SLPIE9AV8QoPPakpuTplE0mASVoG6dam8SD5IsvP';
  final FirebaseAuth auth = FirebaseAuth.instance;

  setShowPassword() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  bool emailValid(email) {
    bool emailValid = RegExp(
            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])')
        .hasMatch(email);
    return emailValid;
  }

  Future? login(context) async {
    isLoading = true;
    notifyListeners();
    await SignUpApiService.getInstance()
        .signUpData(context, emailController, passwordController);
    isLoading = false;
    notifyListeners();
  }

  getFcmToken() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken().then((value) async => {
          LocalDataSaver.saveUserFcmToken(value),
          await fetchDataSPreferences(),
          print("==========$value"),
          notifyListeners(),
        });
  }

  Map<String, String> _buildAuthorizationHeader() {
    final credentials = '$apiKey:$apiSecretKey';
    final encodedCredentials = base64Encode(utf8.encode(credentials));
    final header = {'Authorization': 'Basic $encodedCredentials'};
    return header;
  }

  Future<void> signup(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;

        if (user != null) {
          print(result.user);
          // emailController.text=result.user!.email.toString();

          SignUpApiService.getInstance().loginSocialData(
              context, "0", result.user!.uid, result.user!.email)?.whenComplete((){
            isLoading = false;
            notifyListeners();
          });
          // Nvigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => HomePage()));
        } // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen

          isLoading = false;
          notifyListeners();

      }
      isLoading = false;
      notifyListeners();
    }catch(e){
      isLoading = false;
      notifyListeners();
      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");

    }
  }

  Future<void> facebookLogin(BuildContext context) async {
    final fb = FacebookLogin();

// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        print('Access token: ${accessToken?.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) {
          print('And your email is $email');

          Provider.of<CreateProfileProvider>(context, listen: false).socialId =
              profile!.userId.toString();
          Provider.of<CreateProfileProvider>(context, listen: false)
              .socialType = "1";
          Provider.of<CreateProfileProvider>(context, listen: false)
              .emailController
              .text = email;
          SignUpApiService.getInstance()
              .loginSocialData(context, "1", profile.userId.toString(), email);
          emailController.text = email.toString();
        } else {
          Provider.of<CreateProfileProvider>(context, listen: false).socialId =
              profile!.userId.toString();
          Provider.of<CreateProfileProvider>(context, listen: false)
              .socialType = "1";
          dialogBoxApp(context, profile.userId.toString(), "1");
        }

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        print('Error while log in: ${res.error}');

        break;
      case FacebookLoginStatus.error:
        // Log in failed

        print('Error while log in: ${res.error}');
        break;
    }
  }

  Future loginV2(context) async {
    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: apiKey,

      /// Consumer API Secret keys
      apiSecretKey: apiSecretKey,

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: 'https://example.com/',
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        print('====== Login success ======');
        print(authResult.authToken);
        print(authResult.authTokenSecret);
        if (authResult.user!.email.toString().isNotEmpty) {
          SignUpApiService.getInstance().loginSocialData(
              context, "2", authResult.user!.id.toString(), null);
          emailController.text = authResult.user!.email.toString();

          Provider.of<CreateProfileProvider>(context, listen: false).socialId =
              authResult.user!.id.toString();
          Provider.of<CreateProfileProvider>(context, listen: false)
              .socialType = "1";
          Provider.of<CreateProfileProvider>(context, listen: false)
              .emailController
              .text = authResult.user!.email;
          SignUpApiService.getInstance().loginSocialData(context, "1",
              authResult.user!.id.toString(), authResult.user!.email);
          emailController.text = authResult.user!.email.toString();
        } else {
          Provider.of<CreateProfileProvider>(context, listen: false).socialId =
              authResult.user!.id.toString();
          Provider.of<CreateProfileProvider>(context, listen: false)
              .socialType = "1";
          dialogBoxApp(context, authResult.user!.id.toString(), "1");
        }

        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
      case null:
        // error
        print('====== Login error ======');
        break;
    }
  }

  dialogBoxApp(context, id, type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please enter email"),
            content: TextFormField(
              onChanged: (value) {},
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Please enter email",
                labelText: "Email Address",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    if (emailController.text.trim().isEmpty) {
                      AppSnackBarToast.buildShowSnackBar(
                          context, "Please enter email address");
                      Navigator.pop(context);
                    } else {
                      // Navigator.pop(context);
                      Provider.of<CreateProfileProvider>(context, listen: false)
                          .emailController
                          .text = emailController.text;
                      SignUpApiService.getInstance().loginSocialData(
                          context, type, id, emailController.text);
                      emailController.clear();
                      notifyListeners();
                    }
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }
}
