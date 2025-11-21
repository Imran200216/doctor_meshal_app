import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String? image;
  final String message;
  final String status;
  final String time;
  final String type;

  const ChatMessage({
    required this.id,
    this.image,
    required this.message,
    required this.status,
    required this.time,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      image: json['image'] as String?,
      message: json['message'] as String,
      status: json['status'] as String,
      time: json['time'] as String,
      type: json['type'] as String,
    );
  }

  @override
  List<Object?> get props => [id, image, message, status, time, type];
}

class UserProfile extends Equatable {
  final String firstName;
  final String lastName;
  final String? profileImage;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      profileImage: json['profile_image'] as String?,
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [firstName, lastName, profileImage];
}

class ChatData extends Equatable {
  final bool isReceiverOnline;
  final UserProfile receiverProfile;
  final List<ChatMessage> messages;

  const ChatData({
    required this.isReceiverOnline,
    required this.receiverProfile,
    required this.messages,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    // Handle different response structures for subscription vs query
    final chatMessages =
        (json['chat_data_'] as List<dynamic>?)
            ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // Try to get receiver profile from different possible locations
    UserProfile? receiverProfile;

    // Try subscription format first
    final recRoom = json['reciever_room_id'] as Map<String, dynamic>?;
    if (recRoom != null) {
      final userProfileJson = recRoom['user_id'] as Map<String, dynamic>?;
      if (userProfileJson != null) {
        receiverProfile = UserProfile.fromJson(userProfileJson);
      }
    }

    // Try query format if subscription format didn't work
    if (receiverProfile == null) {
      final senderRoom = json['sender_room_id'] as Map<String, dynamic>?;
      if (senderRoom != null) {
        final userProfileJson = senderRoom['user_id'] as Map<String, dynamic>?;
        if (userProfileJson != null) {
          receiverProfile = UserProfile.fromJson(userProfileJson);
        }
      }
    }

    // Fallback to empty profile if still null
    receiverProfile ??= const UserProfile(firstName: "User", lastName: "");

    return ChatData(
      isReceiverOnline: json['is_receiver_online'] as bool? ?? false,
      receiverProfile: receiverProfile,
      messages: chatMessages,
    );
  }

  @override
  List<Object?> get props => [isReceiverOnline, receiverProfile, messages];
}
