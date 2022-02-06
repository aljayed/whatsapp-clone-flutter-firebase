// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/pages/homepage.dart';
import 'package:whatsapp_clone/pages/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      openScreen();
    });
  }

  openScreen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      String getUserId = sharedPreferences.getString("userId") ?? "";
      getUserId.isEmpty
          ? Get.off(() => SignupScreen())
          : Get.off(() => Homepage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.ease,
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double opacity, Widget? child) {
                return Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    "assets/images/icon.jpg",
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                );
              })),
    );
  }
}
