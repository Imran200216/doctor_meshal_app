import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

class ViewUserChatHomeModel {
  final List<ChatHomeData> data;

  ViewUserChatHomeModel({required this.data});

  factory ViewUserChatHomeModel.fromJson(Map<String, dynamic> json) {
    try {
      AppLoggerHelper.logInfo('🔄 ViewUserChatHomeModel.fromJson called');
      AppLoggerHelper.logInfo('📦 Input JSON keys: ${json.keys.toList()}');

      // Handle both cases: with View_User_Chat_Home_ wrapper and direct data
      dynamic data;

      if (json.containsKey('View_User_Chat_Home_')) {
        // Case 1: With wrapper {"View_User_Chat_Home_": {"data": [...]}}
        final viewUserChatHome =
            json['View_User_Chat_Home_'] as Map<String, dynamic>?;
        if (viewUserChatHome == null) {
          AppLoggerHelper.logWarning('⚠️ View_User_Chat_Home_ is null');
          return ViewUserChatHomeModel(data: []);
        }
        data = viewUserChatHome['data'];
      } else if (json.containsKey('data')) {
        // Case 2: Direct data {"data": [...]}
        data = json['data'];
      } else {
        AppLoggerHelper.logWarning('⚠️ No data found in JSON');
        return ViewUserChatHomeModel(data: []);
      }

      if (data == null) {
        AppLoggerHelper.logWarning('⚠️ Data is null');
        return ViewUserChatHomeModel(data: []);
      }

      if (data is! List) {
        AppLoggerHelper.logError(
          '❌ Expected List but got: ${data.runtimeType}',
        );
        return ViewUserChatHomeModel(data: []);
      }

      AppLoggerHelper.logInfo('🎯 Data list length: ${data.length}');

      final chatData = <ChatHomeData>[];
      for (var i = 0; i < data.length; i++) {
        try {
          final item = data[i];
          AppLoggerHelper.logInfo(
            '📝 Processing chat item $i: ${item.runtimeType}',
          );

          if (item is Map<String, dynamic>) {
            final chatItem = ChatHomeData.fromJson(item);
            chatData.add(chatItem);
          } else {
            AppLoggerHelper.logWarning(
              '⚠️ Item $i is not a Map: ${item.runtimeType}',
            );
          }
        } catch (e) {
          AppLoggerHelper.logError('❌ Error processing item $i: $e');
        }
      }

      AppLoggerHelper.logInfo(
        '✅ Final parsed chat data count: ${chatData.length}',
      );
      return ViewUserChatHomeModel(data: chatData);
    } catch (e, stackTrace) {
      AppLoggerHelper.logError(
        '💥 Error in ViewUserChatHomeModel.fromJson: $e',
      );
      AppLoggerHelper.logError('📋 Stack trace: $stackTrace');
      return ViewUserChatHomeModel(data: []);
    }
  }

  @override
  String toString() {
    return 'ViewUserChatHomeModel(data: $data)';
  }
}

class ChatHomeData {
  final String id;
  final String lastMessage;
  final String lastMessageTime;
  final int unReadCount;
  final Reciever reciever;
  final ChatRoom chatRoom;

  ChatHomeData({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unReadCount,
    required this.reciever,
    required this.chatRoom,
  });

  // Add getter for backward compatibility with chatRoomId name
  ChatRoom? get chatRoomId => chatRoom;

  factory ChatHomeData.fromJson(Map<String, dynamic> json) {
    try {
      AppLoggerHelper.logInfo('🔄 ChatHomeData.fromJson called');
      AppLoggerHelper.logInfo(
        '📦 ChatHomeData JSON keys: ${json.keys.toList()}',
      );

      // Parse with null checks
      final id = json['id'] as String?;
      final lastMessage = json['last_message'] as String?;
      final lastMessageTime = json['last_message_time'] as String?;
      final unReadCount = json['un_read_count'] as int?;
      final recieverJson = json['reciever_id'] as Map<String, dynamic>?;
      final chatRoomJson = json['chat_room_id'] as Map<String, dynamic>?;

      // Log values for debugging
      AppLoggerHelper.logInfo('🔍 ChatHomeData parsed values:');
      AppLoggerHelper.logInfo('   - id: $id');
      AppLoggerHelper.logInfo('   - last_message: $lastMessage');
      AppLoggerHelper.logInfo('   - last_message_time: $lastMessageTime');
      AppLoggerHelper.logInfo('   - un_read_count: $unReadCount');
      AppLoggerHelper.logInfo(
        '   - reciever_id type: ${recieverJson?.runtimeType}',
      );
      AppLoggerHelper.logInfo(
        '   - chat_room_id type: ${chatRoomJson?.runtimeType}',
      );

      return ChatHomeData(
        id: id ?? 'MISSING_ID',
        lastMessage: lastMessage ?? 'MISSING_MESSAGE',
        lastMessageTime: lastMessageTime ?? 'MISSING_TIME',
        unReadCount: unReadCount ?? -1,
        reciever: Reciever.fromJson(recieverJson ?? {}),
        chatRoom: ChatRoom.fromJson(chatRoomJson ?? {}),
      );
    } catch (e, stackTrace) {
      AppLoggerHelper.logError('💥 Error in ChatHomeData.fromJson: $e');
      AppLoggerHelper.logError('📋 Stack trace: $stackTrace');

      // Return a default invalid object that can be filtered out
      return ChatHomeData(
        id: 'ERROR_ID',
        lastMessage: 'ERROR_MESSAGE',
        lastMessageTime: 'ERROR_TIME',
        unReadCount: -999,
        reciever: Reciever(
          id: 'ERROR_RECEIVER_ID',
          firstName: 'ERROR_FIRST_NAME',
          lastName: 'ERROR_LAST_NAME',
          profileImage: 'ERROR_PROFILE_IMAGE',
        ),
        chatRoom: ChatRoom(id: 'ERROR_CHAT_ROOM_ID'),
      );
    }
  }

  // Helper method to check if this is a valid data object (not an error)
  bool get isValid => id != 'MISSING_ID' && id != 'ERROR_ID';

  // Convert to JSON for debugging
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'un_read_count': unReadCount,
      'reciever_id': reciever.toJson(),
      'chat_room_id': chatRoom.toJson(),
    };
  }

  @override
  String toString() {
    return 'ChatHomeData(id: $id, lastMessage: $lastMessage, unReadCount: $unReadCount, chatRoomId: ${chatRoom.id})';
  }
}

class Reciever {
  final String id;
  final String firstName;
  final String lastName;
  final String profileImage;

  Reciever({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory Reciever.fromJson(Map<String, dynamic> json) {
    try {
      AppLoggerHelper.logInfo('🔄 Reciever.fromJson called');
      AppLoggerHelper.logInfo('📦 Reciever JSON keys: ${json.keys.toList()}');

      return Reciever(
        id: json['id'] as String? ?? 'MISSING_RECEIVER_ID',
        firstName: json['first_name'] as String? ?? 'MISSING_FIRST_NAME',
        lastName: json['last_name'] as String? ?? 'MISSING_LAST_NAME',
        profileImage:
            json['profile_image'] as String? ?? 'MISSING_PROFILE_IMAGE',
      );
    } catch (e, stackTrace) {
      AppLoggerHelper.logError('💥 Error in Reciever.fromJson: $e');
      AppLoggerHelper.logError('📋 Stack trace: $stackTrace');
      return Reciever(
        id: 'ERROR_RECEIVER_ID',
        firstName: 'ERROR_FIRST_NAME',
        lastName: 'ERROR_LAST_NAME',
        profileImage: 'ERROR_PROFILE_IMAGE',
      );
    }
  }

  // Convert to JSON for debugging
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image': profileImage,
    };
  }

  @override
  String toString() {
    return 'Reciever(id: $id, name: $firstName $lastName)';
  }
}

class ChatRoom {
  final String id;

  ChatRoom({required this.id});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    try {
      AppLoggerHelper.logInfo('🔄 ChatRoom.fromJson called');
      AppLoggerHelper.logInfo('📦 ChatRoom JSON keys: ${json.keys.toList()}');

      return ChatRoom(id: json['id'] as String? ?? 'MISSING_CHAT_ROOM_ID');
    } catch (e, stackTrace) {
      AppLoggerHelper.logError('💥 Error in ChatRoom.fromJson: $e');
      AppLoggerHelper.logError('📋 Stack trace: $stackTrace');
      return ChatRoom(id: 'ERROR_CHAT_ROOM_ID');
    }
  }

  // Convert to JSON for debugging
  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  @override
  String toString() {
    return 'ChatRoom(id: $id)';
  }
}
