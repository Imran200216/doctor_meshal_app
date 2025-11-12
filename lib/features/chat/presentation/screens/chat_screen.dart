import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: KAppBar(title: "Chat"),

        body: Center(child: Text("hi chat")));
  }
}
