class ChatPlayerListing {
  int? id;
  int? senderId;
  int? receiverId;
  int? status;
  String? lastMessage;
  String? createdAt;
  String? updatedAt;
  String? senderFirstName;
  String? receiverFirstName;
  String? senderImages;
  String? receiverImages;
  String? senderCity;
  String? receiverCity;
  int? senderIsOnline;
  int? receiverIsOnline;

  ChatPlayerListing(
      {this.id,
        this.senderId,
        this.receiverId,
        this.status,
        this.lastMessage,
        this.createdAt,
        this.updatedAt,
        this.senderFirstName,
        this.receiverFirstName,
        this.senderImages,
        this.receiverImages,
        this.senderCity,
        this.receiverCity,
        this.senderIsOnline,
        this.receiverIsOnline});

  ChatPlayerListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    status = json['status'];
    lastMessage = json['last_message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    senderFirstName = json['sender_first_name'];
    receiverFirstName = json['receiver_first_name'];
    senderImages = json['sender_images'];
    receiverImages = json['receiver_images'];
    senderCity = json['sender_city'];
    receiverCity = json['receiver_city'];
    senderIsOnline = json['sender_is_online'];
    receiverIsOnline = json['receiver_is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['status'] = this.status;
    data['last_message'] = this.lastMessage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sender_first_name'] = this.senderFirstName;
    data['receiver_first_name'] = this.receiverFirstName;
    data['sender_images'] = this.senderImages;
    data['receiver_images'] = this.receiverImages;
    data['sender_city'] = this.senderCity;
    data['receiver_city'] = this.receiverCity;
    data['sender_is_online'] = this.senderIsOnline;
    data['receiver_is_online'] = this.receiverIsOnline;
    return data;
  }
}
