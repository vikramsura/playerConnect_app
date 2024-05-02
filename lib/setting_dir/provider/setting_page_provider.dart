import 'package:flutter/material.dart';
import 'package:player_connect/setting_dir/services/deleteAcc_api_service.dart';
import 'package:player_connect/setting_dir/services/logOut_api_service.dart';
import 'package:player_connect/shared/constant/app_strings.dart';

class SettingPageProvider extends ChangeNotifier {
  bool isLoading = false;
  String selectedValue = AppStrings.strSomethingBroken;
  TextEditingController reasonQueryController = TextEditingController();

  Future? logOutReqPlayer(context) async {
    isLoading = true;
    notifyListeners();
    LogOutApiService.getInstance().logOutData(context)?.whenComplete(() {
      isLoading = false;
      notifyListeners();
      notifyListeners();
    }).onError((error, stackTrace) {
      isLoading = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  Future? deleteAccountReq(context) async {
    isLoading = true;
    notifyListeners();
    await DeleteAccountApiService.getInstance()
        .deleteAccountReq(
            context,
            selectedValue == AppStrings.strOther
                ? reasonQueryController.text
                : selectedValue)
        ?.whenComplete(() {
      isLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      isLoading = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }
}
