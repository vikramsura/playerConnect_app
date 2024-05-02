class RecommendedUserModel {
  int? success;
  int? code;
  String? message;
  List<RecommendedUserModelBody>? body;

  RecommendedUserModel({this.success, this.code, this.message, this.body});

  RecommendedUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <RecommendedUserModelBody>[];
      json['body'].forEach((v) {
        body!.add(RecommendedUserModelBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecommendedUserModelBody {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? country;
  String? countryCode;
  String? loginTime;
  String? latitude;
  var locationRange;
  var longitude;
  var otp;
  String? images;
  int? gender;
  String? dob;
  String? password;
  String? deviceToken;
  var deviceType;
  int? role;
  var totalexperience;
  String? height;
  String? about;
  String? city;
  String? desiredPartner;
  int? ratingtype;
  String? rating;
  String? playingstyle;
  String? dominnantHand;
  String? countryFlag;
  var socialType;
  var socialId;
  int? isNotification;
  int? is_online;
  String? createdAt;
  String? updatedAt;
  var senderStatus1;
  var receiverStatus1;
  var senderStatus2;
  var receiverStatus2;

  RecommendedUserModelBody(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.country,
      this.countryCode,
      this.loginTime,
      this.latitude,
      this.locationRange,
      this.longitude,
      this.otp,
      this.images,
      this.gender,
      this.dob,
      this.password,
      this.deviceToken,
      this.deviceType,
      this.role,
      this.totalexperience,
      this.height,
      this.about,
      this.city,
      this.desiredPartner,
      this.ratingtype,
      this.rating,
      this.playingstyle,
      this.dominnantHand,
      this.countryFlag,
      this.socialType,
      this.socialId,
      this.isNotification,
      this.is_online,
      this.createdAt,
      this.updatedAt,
        this.senderStatus1,
        this.receiverStatus1,
        this.senderStatus2,
        this.receiverStatus2,});

  RecommendedUserModelBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
    countryCode = json['country_code'];
    loginTime = json['loginTime'];
    latitude = json['latitude'];
    locationRange = json['location_range'];
    longitude = json['longitude'];
    otp = json['otp'];
    images = json['images'];
    gender = json['gender'];
    dob = json['dob'];
    password = json['password'];
    deviceToken = json['deviceToken'];
    deviceType = json['deviceType'];
    role = json['role'];
    totalexperience = json['totalexperience'];
    height = json['height'];
    about = json['about'];
    city = json['city'];
    desiredPartner = json['desired_partner'];
    ratingtype = json['ratingtype'];
    rating = json['rating'];
    playingstyle = json['playingstyle'];
    dominnantHand = json['dominnant_hand'];
    countryFlag = json['country_flag'];
    socialType = json['social_type'];
    socialId = json['social_id'];
    isNotification = json['isNotification'];
    is_online = json['is_online'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    senderStatus1 = json['sender_status_1'];
    receiverStatus1 = json['receiver_status_1'];
    senderStatus2 = json['sender_status_2'];
    receiverStatus2 = json['receiver_status_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['loginTime'] = this.loginTime;
    data['latitude'] = this.latitude;
    data['location_range'] = this.locationRange;
    data['longitude'] = this.longitude;
    data['otp'] = this.otp;
    data['images'] = this.images;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['password'] = this.password;
    data['deviceToken'] = this.deviceToken;
    data['deviceType'] = this.deviceType;
    data['role'] = this.role;
    data['totalexperience'] = this.totalexperience;
    data['height'] = this.height;
    data['about'] = this.about;
    data['city'] = this.city;
    data['desired_partner'] = this.desiredPartner;
    data['ratingtype'] = this.ratingtype;
    data['rating'] = this.rating;
    data['playingstyle'] = this.playingstyle;
    data['dominnant_hand'] = this.dominnantHand;
    data['country_flag'] = this.countryFlag;
    data['social_type'] = this.socialType;
    data['social_id'] = this.socialId;
    data['isNotification'] = this.isNotification;
    data['is_online'] = this.is_online;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['sender_status_1'] = this.senderStatus1;
    data['receiver_status_1'] = this.receiverStatus1;
    data['sender_status_2'] = this.senderStatus2;
    data['receiver_status_2'] = this.receiverStatus2;
    return data;
  }
}
