import 'package:flutter/material.dart';

class DoctorBottomNav extends StatelessWidget {
  const DoctorBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Center(child: Text("hi doctor"))),
    );
  }
}
