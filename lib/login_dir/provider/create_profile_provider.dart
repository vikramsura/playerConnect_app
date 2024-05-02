// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'dart:io';

import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:player_connect/login_dir/services/create_profile_api_service.dart';
import 'package:player_connect/login_dir/services/profile_image_api_service.dart';
import 'package:player_connect/shared/auth/local_db_saver.dart';
import 'package:player_connect/shared/constant/colors.dart';
import 'package:player_connect/shared/constant/font_size.dart';
import 'package:player_connect/shared/constant/fonts.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:player_connect/shared/constant/user_info.dart';

class CreateProfileProvider extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController textAreaController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController feetHeightController = TextEditingController();
  TextEditingController inchFeetController = TextEditingController();
  TextEditingController desiredPartnerController = TextEditingController();
  TextEditingController playingStyleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? socialType;
  String? socialId;
  bool isShowPassword = true;

  // int completeTaskValue = 1;
  int currentWidget = 1;
  int? selectedGender;

  // double completeProgressBar = 0.2;
  bool isUtrRating = true;
  bool isDiamondHand = true;
  double userUtrRating = 5;
  double userNtrpRating = 3;
  double userMaxDrivDis = 10;
  String? userDob;
  bool expanded = false;
  int ratingListIndex = -1;
  DateTime selectedDate = DateTime.now();
  bool isLocationLoading = false;
  String? _currentAddress;
  Position? _currentPosition;
  File? image;
  String? selectImage;
  String selectedCountry = "United States of America";
  String countryCode = "+1";
  String countryFlag = "flags/usa.png";
  bool isLoading = false;
  int? age;
  String? userCmHeight;

  getRatingIndex(int index) {
    if (ratingListIndex == index) {
      ratingListIndex = -1;
      notifyListeners();
    } else {
      ratingListIndex = index;
      notifyListeners();
    }
    notifyListeners();
  }

  getBoolUtrRating(value) {
    isUtrRating = value;
    notifyListeners();
  }

  getBoolDiamondHand(value) {
    isDiamondHand = value;
    notifyListeners();
  }

  setUserUtrRating(double value) {
    userUtrRating = value;
    notifyListeners();
  }

  setProgressBar(double value) {
    // completeProgressBar = value;
    notifyListeners();
  }

  setProgressTask(int value) {
    // completeTaskValue = value;
    notifyListeners();
  }

  List ntrpList = [
    0.5,
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
    4.5,
    5.0,
    5.5,
    6.0,
    6.5,
    7.0,
    7.5,
    8.0,
    8.5,
    9.0,
    9.5,
    10.0,
  ];

  List descriptionList = [
    "This player is learning to judge where the oncoming ball is going and how much swing is needed to return it consistently. Movement to the ball and recovery are ofter not efficient. Can sustain a backcourt rally of slow pace with other players of similar ability and is beginning to develop stokes. This play is becoming more familiar with the basic positions for singles and doubles, and is ready to play social matches, leagues and low-level touraments.\n\n Potential limitations: grip weaknesses; limited swing and inconsistent toss on serve; limited transitions to the net."
  ];

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

  Widget buildText(title) {
    return Text(title,
        style: AppFonts.mazzardFont(TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryColorBlack,
            fontSize: AppFontSize.font14)));
  }

  Widget textFieldContainer(
      CreateProfileProvider provider, hintText, controller, maxLines,
      {prefix, keyboardType}) {
    return Container(
      // height: AppFontSize.font45,
      decoration: BoxDecoration(
          color: AppColors.secondaryColorWhite,
          border: Border.all(color: AppColors.secondaryColorBlack, width: 1),
          borderRadius: BorderRadius.circular(AppFontSize.font12)),
      child: Center(
        child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              contentPadding: EdgeInsets.fromLTRB(14, 10, 10, 11),
              hintStyle: AppFonts.poppinsFont(TextStyle(
                  fontSize: AppFontSize.font14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.infoPageCount)),
            )),
      ),
    );
  }

  Widget genderContainer(img, text, indx) {
    return InkWell(
      onTap: () {
        selectedGender = indx;
        notifyListeners();
      },
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: AppFontSize.font90,
        width: AppFontSize.font90,
        decoration: BoxDecoration(
            color: selectedGender == indx
                ? AppColors.primaryColorSkyBlue
                : AppColors.secondaryColorLightGrey,
            borderRadius: BorderRadius.circular(AppFontSize.font32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage(img),
                height: AppFontSize.font45,
                width: AppFontSize.font45,
              ),
            ),
            SizedBox(height: AppFontSize.font8),
            Text(text,
                style: AppFonts.poppinsFont(TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryColorBlack,
                    fontSize: AppFontSize.font14)))
          ],
        ),
      ),
    );
  }

  Future selectDobDate(context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: "Select DOB",
    );
    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
      var dateTime = DateTime.parse(selectedDate.toString());
      var formatDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      dobController = TextEditingController(text: formatDate);

      var ageDiff = DateTime.now().year - selectedDate.year;
      age = ageDiff;

      notifyListeners();
    }
  }

  Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackBarToast.buildShowSnackBar(context,
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppSnackBarToast.buildShowSnackBar(
            context, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AppSnackBarToast.buildShowSnackBar(context,
          'Location permissions are permanently denied, we cannot request permissions.');

      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition(context) async {
    final hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      notifyListeners();
      getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      LocalDataSaver.saveUserLatitude(position.latitude.toString());
      LocalDataSaver.saveUserLongitude(position.longitude.toString());
      fetchDataSPreferences();
      print(UserDetails.userLatitude);
      print(UserDetails.userLongitude);
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      locationController.text = _currentAddress!.toString();
      notifyListeners();
      fetchDataSPreferences();
    }).catchError((e) {});
  }

  Future<void> cameraImage(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            getImageFile(ImageSource.camera, context);
                          },
                          child: Icon(Icons.photo_camera))),
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            getImageFile(ImageSource.gallery, context);
                          },
                          child: Icon(Icons.photo_library_outlined))),
                ],
              ),
            ),
          );
        });
  }

  getImageFile(source, context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final file = await picker.pickImage(source: source);
      if (file == null) return;
      // selectImage = file.path;
      // image = File(file.path);

      CroppedFile? croppedImage = await ImageCropper.platform.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ],
        maxWidth:
            int.parse(MediaQuery.of(context).size.width.toStringAsFixed(0)),
        maxHeight: int.parse(
            (MediaQuery.of(context).size.height / 2.2).toStringAsFixed(0)),
      );
      if (croppedImage != null) {
        image = File(croppedImage.path);
        selectImage = croppedImage.path;
        image = File(croppedImage.path);
      }
      Navigator.pop(context);

      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      debugPrint("Image picking failed: $e");
    }
  }

  void initCountry(context) async {
    final country = await getDefaultCountry(context);
    countryFlag = country.flag;
    selectedCountry = country.name.toString();
    notifyListeners();
  }

  void showCountryPicker(context) async {
    final country = await showCountryPickerSheet(
      context,
    );
    if (country != null) {
      countryFlag = country.flag;
      countryCode = country.callingCode;
      selectedCountry = country.name.toString();

      // phoneNumController.text=country.callingCode;
      notifyListeners();
    }
  }

  Future? createProfileData(context) async {
    var aa = DateTime.now().year - selectedDate.year;
    isLoading = true;
    notifyListeners();
    await CreateProfileApiService.getInstance()
        .createProfile(
      context,
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      emailController.text.trim(),
      phoneNumController.text.trim(),
      image!,
      textAreaController.text.trim(),
      "${dobController.text.trim()} $age",
      "${feetHeightController.text}'${inchFeetController.text}'' ($userCmHeight cm)",
      passwordController.text.trim(),
      selectedGender!,
      locationController.text,
      selectedCountry,
      countryCode,
      countryFlag,
      isUtrRating ? 0 : 1,
      isUtrRating ? userUtrRating.toString() : userNtrpRating.toString(),
      userMaxDrivDis.toInt(),
      desiredPartnerController.text,
      playingStyleController.text,
      isDiamondHand ? "Left" : "Right",
      socialType.toString(),
      socialId.toString(),
    )
        ?.then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      isLoading = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
    return [];
  }

  getImageUrl(context) {
    isLoading = true;
    notifyListeners();
    ProfileImageApiService.getInstance().profileImageData(context, image);
    isLoading = false;
    notifyListeners();
  }

  clearData() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNumController.clear();
    textAreaController.clear();
    dobController.clear();
    locationController.clear();
    feetHeightController.clear();
    inchFeetController.clear();
    desiredPartnerController.clear();
    playingStyleController.clear();
    isShowPassword = true;
    currentWidget = 1;
    selectedGender = null;

    // double completeProgressBar = 0.2;
    isUtrRating = true;
    isDiamondHand = true;
    userUtrRating = 5;
    userNtrpRating = 3;
    userMaxDrivDis = 10;
    userDob;
    expanded = false;
    ratingListIndex = -1;
    selectedDate = DateTime.now();
    isLocationLoading = false;
    _currentAddress = null;
    _currentPosition = null;
    image = null;
    selectImage = null;
    selectedCountry = "United States of America";
    countryCode = "+1";
    countryFlag = "flags/usa.png";
    isLoading = false;
    age = null;
    userCmHeight = null;
    notifyListeners();
  }
}
