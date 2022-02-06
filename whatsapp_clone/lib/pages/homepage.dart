// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/controller/chat_page_controller.dart';
import 'package:whatsapp_clone/controller/home_controller.dart';
import 'package:whatsapp_clone/pages/category_tab_page.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

import 'chat_tab_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  
  HomeController homeController = HomeController();
  var getUserId = "".obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.getUid().then((value) {
      homeController.setOnlineStatus(true);
    });
    
    WidgetsBinding.instance!.addObserver(this);
  }

// ...

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      homeController.setOnlineStatus(true);
    }
    if (state == AppLifecycleState.paused) {
      homeController.setOnlineStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("WhatsApp Clone"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.chat),
                text: "Chat",
              ),
              Tab(
                icon: Icon(Icons.list),
                text: "Categories",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatTabPage(),
            CategoryTabPage(),
          ],
        ),
      ),
    );
  }
  // Future fetchUserId() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   getUserId.value = sharedPreferences.getString("userId") ?? "";
  // }
}
