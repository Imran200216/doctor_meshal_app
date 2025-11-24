class ViewUserChatHomeModel {
  final List<ChatHomeData> data;

  ViewUserChatHomeModel({required this.data});

  factory ViewUserChatHomeModel.fromJson(Map<String, dynamic> json) {
    // The JSON structure is: {"data": [...]}
    final dataList = json['data'] as List?;

    if (dataList == null) {
      return ViewUserChatHomeModel(data: []);
    }

    final chatData = dataList.map((item) {
      return ChatHomeData.fromJson(item);
    }).toList();

    return ViewUserChatHomeModel(data: chatData);
  }
}

class ChatHomeData {
  final String id;
  final String lastMessage;
  final String lastMessageTime;
  final int unReadCount;
  final Receiver receiver;
  final ChatRoom chatRoom;

  ChatHomeData({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unReadCount,
    required this.receiver,
    required this.chatRoom,
  });

  factory ChatHomeData.fromJson(Map<String, dynamic> json) {
    return ChatHomeData(
      id: json['id'] as String? ?? '',
      lastMessage: json['last_message'] as String? ?? '',
      lastMessageTime: json['last_message_time'] as String? ?? '',
      unReadCount: json['un_read_count'] as int? ?? 0,
      receiver: Receiver.fromJson(json['reciever_id'] as Map<String, dynamic>? ?? {}),
      chatRoom: ChatRoom.fromJson(json['chat_room_id'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Receiver {
  final String id;
  final String firstName;
  final String lastName;
  final String profileImage;

  Receiver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      profileImage: json['profile_image'] as String? ?? '',
    );
  }
}

class ChatRoom {
  final String id;

  ChatRoom({required this.id});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String? ?? '',
    );
  }
}