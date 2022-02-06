// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/chat_page_controller.dart';
import 'package:whatsapp_clone/controller/home_controller.dart';
import 'package:whatsapp_clone/pages/chat_screen.dart';
import 'package:whatsapp_clone/pages/live_chat_list_tile.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class ChatTabPage extends StatefulWidget {
  const ChatTabPage({Key? key}) : super(key: key);

  @override
  _ChatTabPageState createState() => _ChatTabPageState();
}

class _ChatTabPageState extends State<ChatTabPage> {
  HomeController homeController = HomeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.getUid();
    homeController.retrieveActiveChatSharedPrefs().then((value) {
      //homeController.fetchDataFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
        stream: realtimeDatabase.ref("users").onValue,
        builder: (context, snapshot) {

          var data = snapshot.data?.snapshot;

          data?.child(homeController.getUserId.value).child("unseen").children.forEach((element){
                      if(!homeController.activeChatUsersList.contains(element.key)){
                        homeController.activeChatUsersList.add(element.key);
                      }
                    });

          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : homeController.activeChatUsersList.isEmpty ? 
              Center(child: Text("Find a user from the category tab"),) 
              : ListView.builder(
                  itemCount: homeController.activeChatUsersList.length,
                  itemBuilder: (context, index) {
                    var newIndex = homeController.activeChatUsersList.length - 1 - index;
                    var readySnapshot = data?.child(homeController.activeChatUsersList[newIndex]);
                    print("haha not working");
                    
                    

                    print("haha ${data?.child(homeController.getUserId.value).child("unseen").value.toString()}");
                    
                      //print("Hello boys, "+homeController.nameList.length.toString());
              return ChatUserListTile(
                clickAction: () {
                  Get.to(() => ChatScreen(),
                      arguments:
                          homeController.activeChatUsersList[newIndex]);
                },
                    name: "${readySnapshot?.child("firstName").value} ${readySnapshot?.child("lastName").value}",
                    pictureUrl: "",
                    unseenMessageCount: 0,
                  );
                });
        });
  }
}









// ListView(
//         children: [
//           ChatUserListTile(
//             name: "Md Ismail",
//             lastMessage: "Last message",
//             pictureUrl: "https://picsum.photos/200/360",
//             unseenMessageCount: "1",
//             clickAction: (){
//               print("The item was clicked");
//             },
//           ),
//           ChatUserListTile(
//             name: "Md Hasan",
//             lastMessage: "Last message",
//             pictureUrl: "https://picsum.photos/200/350",
//             unseenMessageCount: "3",
//             clickAction: (){
//               print("The item was clicked");
//             },
//           ),
//           ChatUserListTile(
//             name: "Developer",
//             lastMessage: "Last message",
//             pictureUrl: "https://picsum.photos/200/340",
//             unseenMessageCount: "2",
//             clickAction: (){
//               print("The item was clicked");
//             },
//           ),
//         ],
//       )
