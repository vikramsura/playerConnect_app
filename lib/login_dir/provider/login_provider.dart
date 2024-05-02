// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:player_connect/login_dir/services/login_api_service.dart';
import 'package:player_connect/shared/auth/local_db_saver.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginProvider extends ChangeNotifier {
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

  Future? login(context) async {
    await fetchDataSPreferences();
    isLoading = true;
    bool isLogin = false;
    notifyListeners();
    await LoginApiService.getInstance()
        .loginData(context, emailController.text.trim(),
            passwordController.text.trim())
        .then((value) {
      value == true ? isLogin = true : isLogin = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      isLoading = false;
      isLogin = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
    return isLogin;
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

  Future<void> signup(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    getFcmToken();
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

        if (result != null) {
          print(result.user);
          // emailController.text=result.user!.email.toString();

          LoginApiService.getInstance()
              .loginSocialData(
                  context, "0", result.user!.uid, result.user!.email)
              ?.whenComplete(() {
            isLoading = false;
            notifyListeners();
          });
          // Nvigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => HomePage()));
        } // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen
        // AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
        isLoading = false;
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");

      isLoading = false;
      notifyListeners();
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
          LoginApiService.getInstance().loginSocialData(
              context, "Facebook", profile!.userId.toString(), null);
          emailController.text = email.toString();
        }
        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
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
        LoginApiService.getInstance().loginSocialData(
            context, "Twitter", authResult.user!.id.toString(), null);
        emailController.text = authResult.user!.email.toString();

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
}
