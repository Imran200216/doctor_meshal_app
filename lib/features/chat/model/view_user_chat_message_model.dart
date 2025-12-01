import 'package:equatable/equatable.dart';

import '../../../core/utils/utils.dart';

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
      id: _parseString(json['id']),
      image: _parseNullableString(json['image']),
      message: _parseString(json['message']),
      status: _parseString(json['status']),
      time: _parseString(json['time']),
      type: _parseString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'message': message,
      'status': status,
      'time': time,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, image, message, status, time, type];
}

class UserProfile extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? profileImage;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UserProfile(
        id: 'unknown',
        firstName: 'Unknown',
        lastName: 'User',
        profileImage: null,
      );
    }

    return UserProfile(
      id: _parseString(json['id'], fallback: 'unknown'),
      firstName: _parseString(json['first_name'], fallback: 'Unknown'),
      lastName: _parseString(json['last_name'], fallback: 'User'),
      profileImage: _parseNullableString(json['profile_image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image': profileImage,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, profileImage];
}

class ChatRoom extends Equatable {
  final String id;
  final UserProfile user;

  const ChatRoom({required this.id, required this.user});

  factory ChatRoom.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChatRoom(
        id: 'unknown',
        user: const UserProfile(
          id: 'unknown',
          firstName: 'Unknown',
          lastName: 'User',
        ),
      );
    }

    return ChatRoom(
      id: _parseString(json['id'], fallback: 'unknown'),
      user: UserProfile.fromJson(json['user_id'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'user_id': user.toJson()};
  }

  @override
  List<Object?> get props => [id, user];
}

class ChatData extends Equatable {
  final List<ChatMessage> messages;
  final bool isReceiverOnline;
  final ChatRoom senderRoom;
  final ChatRoom receiverRoom;

  const ChatData({
    required this.messages,
    required this.isReceiverOnline,
    required this.senderRoom,
    required this.receiverRoom,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    try {
      AppLoggerHelper.logInfo('🔄 Parsing ChatData from JSON');

      final chatDataList = json['chat_data_'];
      List<ChatMessage> messages = [];

      if (chatDataList is List) {
        messages = chatDataList.map((item) {
          try {
            return ChatMessage.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            AppLoggerHelper.logError('❌ Failed to parse chat message: $e');
            return const ChatMessage(
              id: 'error',
              message: 'Failed to load message',
              status: 'error',
              time: '1970-01-01T00:00:00Z',
              type: 'error',
            );
          }
        }).toList();
      } else {
        AppLoggerHelper.logWarning(
          '⚠️ chat_data_ is not a List: $chatDataList',
        );
      }

      final isReceiverOnline = json['is_receiver_online'] as bool? ?? false;

      final senderRoom = ChatRoom.fromJson(
        json['sender_room_id'] as Map<String, dynamic>?,
      );
      final receiverRoom = ChatRoom.fromJson(
        json['reciever_room_id'] as Map<String, dynamic>?,
      );

      AppLoggerHelper.logInfo(
        '✅ Successfully parsed ChatData with ${messages.length} messages',
      );

      return ChatData(
        messages: messages,
        isReceiverOnline: isReceiverOnline,
        senderRoom: senderRoom,
        receiverRoom: receiverRoom,
      );
    } catch (e) {
      AppLoggerHelper.logError('💥 Failed to parse ChatData: $e');
      AppLoggerHelper.logError('💥 JSON data: $json');

      return ChatData(
        messages: [],
        isReceiverOnline: false,
        senderRoom: const ChatRoom(
          id: 'error',
          user: UserProfile(id: 'error', firstName: 'Error', lastName: 'User'),
        ),
        receiverRoom: const ChatRoom(
          id: 'error',
          user: UserProfile(id: 'error', firstName: 'Error', lastName: 'User'),
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_data_': messages.map((msg) => msg.toJson()).toList(),
      'is_receiver_online': isReceiverOnline,
      'sender_room_id': senderRoom.toJson(),
      'reciever_room_id': receiverRoom.toJson(),
    };
  }

  String get senderName => senderRoom.user.fullName;

  String get receiverName => receiverRoom.user.fullName;

  String? get senderProfileImage => senderRoom.user.profileImage;

  String? get receiverProfileImage => receiverRoom.user.profileImage;

  @override
  List<Object?> get props => [
    messages.length,
    messages.isNotEmpty ? messages.last.id : null,
    isReceiverOnline,
    senderRoom,
    receiverRoom,
  ];

  ChatData copyWith({
    List<ChatMessage>? messages,
    bool? isReceiverOnline,
    ChatRoom? senderRoom,
    ChatRoom? receiverRoom,
  }) {
    return ChatData(
      messages: messages ?? this.messages,
      isReceiverOnline: isReceiverOnline ?? this.isReceiverOnline,
      senderRoom: senderRoom ?? this.senderRoom,
      receiverRoom: receiverRoom ?? this.receiverRoom,
    );
  }

  @override
  String toString() =>
      'ChatData(messages: ${messages.length}, online: $isReceiverOnline, sender: $senderName, receiver: $receiverName)';
}

// Helper functions
String _parseString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  return value.toString();
}

String? _parseNullableString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  final stringValue = value.toString();
  return stringValue.isEmpty ? null : stringValue;
}
