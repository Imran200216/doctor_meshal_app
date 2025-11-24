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

// ✅ FIXED: Now extends Equatable!
class ChatData extends Equatable {
  final List<ChatMessage> messages;
  final bool isReceiverOnline;
  final String? senderFirstName;
  final String? senderLastName;
  final String? senderProfileImage;

  const ChatData({
    // ✅ Added const constructor
    required this.messages,
    required this.isReceiverOnline,
    this.senderFirstName,
    this.senderLastName,
    this.senderProfileImage,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    final chatDataList = json['chat_data_'] as List? ?? [];

    return ChatData(
      messages: chatDataList.map((item) => ChatMessage.fromJson(item)).toList(),
      isReceiverOnline: json['is_receiver_online'] as bool? ?? false,
      senderFirstName: json['sender_room_id']?['user_id']?['first_name'],
      senderLastName: json['sender_room_id']?['user_id']?['last_name'],
      senderProfileImage: json['sender_room_id']?['user_id']?['profile_image'],
    );
  }

  // ✅ CRITICAL: This makes BlocBuilder rebuild when data changes!
  @override
  List<Object?> get props => [
    messages.length,
    // Rebuild when message count changes
    messages.isNotEmpty ? messages.last.id : null,
    // Rebuild when last message changes
    isReceiverOnline,
    // Rebuild when online status changes
    senderFirstName,
    senderLastName,
    senderProfileImage,
  ];

  // ✅ Optional: Add copyWith for easier state updates
  ChatData copyWith({
    List<ChatMessage>? messages,
    bool? isReceiverOnline,
    String? senderFirstName,
    String? senderLastName,
    String? senderProfileImage,
  }) {
    return ChatData(
      messages: messages ?? this.messages,
      isReceiverOnline: isReceiverOnline ?? this.isReceiverOnline,
      senderFirstName: senderFirstName ?? this.senderFirstName,
      senderLastName: senderLastName ?? this.senderLastName,
      senderProfileImage: senderProfileImage ?? this.senderProfileImage,
    );
  }

  // ✅ Optional: Add toString for debugging
  @override
  String toString() =>
      'ChatData(messages: ${messages.length}, online: $isReceiverOnline, sender: $senderFirstName $senderLastName)';
}
