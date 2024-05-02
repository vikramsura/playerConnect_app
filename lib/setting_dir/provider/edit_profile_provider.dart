// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:player_connect/setting_dir/services/editProfileService.dart';
import 'package:player_connect/shared/auth/local_db_saver.dart';
import 'package:player_connect/shared/constant/app_strings.dart';
import 'package:player_connect/shared/constant/colors.dart';
import 'package:player_connect/shared/constant/font_size.dart';
import 'package:player_connect/shared/constant/fonts.dart';
import 'package:player_connect/shared/constant/snack_bar_toast.dart';
import 'package:player_connect/shared/constant/user_info.dart';

class EditProfileProvider extends ChangeNotifier {
  TextEditingController emailController =
      TextEditingController(text: UserDetails.userEmail);
  TextEditingController firstNameController =
      TextEditingController(text: UserDetails.firstName);
  TextEditingController lastNameController =
      TextEditingController(text: UserDetails.lastName);
  TextEditingController phoneNumController =
      TextEditingController(text: UserDetails.userPhone);
  TextEditingController textAreaController =
      TextEditingController(text: UserDetails.userInfo);
  TextEditingController dobController =
      TextEditingController(text: UserDetails.userDob!.split(" ").first);
  TextEditingController locationController =
      TextEditingController(text: UserDetails.userLocation);
  TextEditingController feetHeightController =
      TextEditingController(text: UserDetails.userHeight!.split("'").first);
  TextEditingController inchFeetController = TextEditingController(
      text: UserDetails.userHeight!.split("''").first.split("'").last);
  TextEditingController desiredPartnerController =
      TextEditingController(text: UserDetails.userDesiredPartner);
  TextEditingController playingStyleController =
      TextEditingController(text: UserDetails.userPlayingStyle);

  String selectedGender = int.parse(UserDetails.userGender.toString()) == 0
      ? "Male"
      : int.parse(UserDetails.userGender.toString()) == 1
          ? "Female"
          : "Others";

  bool isUtrRating = UserDetails.isUtr!;
  bool isDiamondHand =
      UserDetails.userDominantHand.toString() == "Left" ? true : false;
  DateTime selectedDate = DateTime.now();
  String? userDob;

  String? userImg = UserDetails.userPhoto!;
  File? image;

  double userUtrRating = 4;
  double userNtrpRating = 3;
  double userMaxDrivDis = 10;
  bool expanded = false;
  int ratingListIndex = -1;
  bool isLocationLoading = false;
  String? _currentAddress = UserDetails.userLocation;
  Position? _currentPosition;
  String selectedCountry = "United States of America";
  String countryCode = "+1";
  String countryFlag = "flags/usa.png";
  bool isLoading = false;
  int age = int.parse(UserDetails.userDob!.split(" ").last);
  String? userCmHeight;
  bool isChanged = false;
  bool isPhotoChanged = false;

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

  Widget buildText(title) {
    return Text(title,
        style: AppFonts.mazzardFont(TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryColorBlack,
            fontSize: AppFontSize.font14)));
  }

  Widget textFieldContainer(
      EditProfileProvider provider, hintText, controller, maxLines,
      {prefix}) {
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
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              isChanged = true;
            },
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

  Widget genderContainer(img, text) {
    return InkWell(
      onTap: () {
        selectedGender = text;
        notifyListeners();
      },
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: AppFontSize.font100,
        width: AppFontSize.font100,
        decoration: BoxDecoration(
            color: selectedGender == text
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
      var formatDate = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
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
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      locationController.text = _currentAddress!;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> profileImage(context) async {
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
        userImg = image.toString();
        fetchDataSPreferences();
        isPhotoChanged = true;
      }
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      AppSnackBarToast.buildShowSnackBar(context, "Something went wrong");
      debugPrint("Image picking failed: $e");
    }
  }

  _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper.platform.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    image = File(croppedImage!.path);
    userImg = image.toString();
    fetchDataSPreferences();
    isPhotoChanged = true;
    notifyListeners();
    print(croppedImage);
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

  getHeightCm() {
    if (feetHeightController.text.trim().isNotEmpty &&
        inchFeetController.text.trim().isNotEmpty) {
      double heightInCm =
          (double.parse(feetHeightController.text.trim()) * 30.48) +
              (double.parse(inchFeetController.text.trim()) * 2.54);
      userCmHeight = heightInCm.toString();
      notifyListeners();
    }
  }

  editUserProfileData(context, index) async {
    isLoading = true;
    notifyListeners();
    await EditProfileService.getInstance().editProfile(
      context,
      index,
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      emailController.text,
      selectedCountry,
      phoneNumController.text.trim(),
      isPhotoChanged == true ? image! : File("null"),
      "${dobController.text} $age",
      "${feetHeightController.text}'${inchFeetController.text}'' ($userCmHeight cm)",
      countryFlag.toString(),
      selectedGender.toString() == "Male"
          ? 0
          : selectedGender.toString() == "Female"
              ? 1
              : 2,
      isUtrRating ? 0 : 1,
      isUtrRating ? userUtrRating.toString() : userNtrpRating.toString(),
      locationController.text,
      textAreaController.text,
      desiredPartnerController.text,
      playingStyleController.text,
      isDiamondHand ? "Left" : "Right",
      int.parse(userMaxDrivDis.toStringAsFixed(0)),
    );
    isLoading = false;
    notifyListeners();
  }

  AppBar buildAppBar(BuildContext context, int index) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColors.secondaryColorWhite,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.primaryColorBlue,
              borderRadius: BorderRadius.circular(12)),
          child: InkWell(
              onTap: () {
                if (index == 2) {
                  getHeightCm();
                  editUserProfileData(context, index);
                } else {
                  editUserProfileData(context, index);
                }
              },
              child: Center(child: Text("Done"))),
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.secondaryColorBlack),
      centerTitle: true,
      title: Text(AppStrings.strEditProfile,
          style: AppFonts.mazzardFont(TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColorBlue,
              fontSize: AppFontSize.font16))),
    );
  }

  void openDropdown(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        AppFontSize.font20,
        AppFontSize.font180,
        AppFontSize.font20,
        AppFontSize.font20,
      ),
      items: [
        PopupMenuItem(value: "All court", child: Text("All court")),
        PopupMenuItem(
            value: "Agressive baseliner", child: Text("Agressive baseliner")),
        PopupMenuItem(
            value: "Serve and volley", child: Text("Serve and volley")),
        PopupMenuItem(value: "Counter-puncher", child: Text("Counter-puncher")),
      ],
    ).then((value) {
      if (value != null) {
        playingStyleController = TextEditingController(text: value.toString());
        notifyListeners();
      }
    });
  }
}
