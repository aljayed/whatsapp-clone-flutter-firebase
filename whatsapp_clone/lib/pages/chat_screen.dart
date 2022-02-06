// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/chat_page_controller.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {

  ChatController chatController = ChatController();
  TextEditingController messageFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatController.friendUid.value = Get.arguments;
    chatController.getUid();
    chatController.fetchDataFirebase();
    chatController.getUid().then((value) {
      chatController.chatroomId.value =
          chatController.generateChatroomId(Get.arguments);
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    chatController.setInactiveInChatroom();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("Haha");
      chatController.setInactiveInChatroom();
    }

    if (state == AppLifecycleState.resumed) {
      print("Haha");
      chatController.setActiveInChatroom(chatController.getUserId.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(() => Text(chatController.friendName.value)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //future builder is needed because the user id takes time to load from shared prefs.
          Expanded(
            child: FutureBuilder(
                future: chatController.getUid(),
                builder: (context, snapshot) {
                  //Stream builder to retrieve all the chat messages from the
                  return StreamBuilder<DatabaseEvent>(
                      stream: realtimeDatabase
                          .ref("chats")
                          .child(chatController.chatroomId.value)
                          .child("messages")
                          .onValue,
                      builder: (context, snapshot) {
                        DataSnapshot? data = snapshot.data?.snapshot;

      return Center(
                child: !snapshot.hasData
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        primary: true,
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: data?.children.length,
                        itemBuilder: (context, index) {
                          var finalIndex = int.parse(
                                  "${data?.children.length.toString()}") - 1 - index;
                          return ChatMessageBubble(
                            text:"${data?.child(finalIndex.toString()).child("text").value.toString()}",
                            senderId: data?.child(finalIndex.toString()).child("senderId").value.toString(),
                          );
                        }));
                      });
                }),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 2,
                          color: Colors.grey.withOpacity(0.5),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageFieldController,
                            cursorHeight: 21,
                            decoration: InputDecoration(
                                hintText: "Type message...",
                                hintStyle: TextStyle(color: Colors.blueAccent),
                                border: InputBorder.none),
                          ),
                        ),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(Icons.photo_camera,
                              color: Colors.blueAccent),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2, // changes position of shadow
                      ),
                    ],
                  ),
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (messageFieldController.text.isNotEmpty) {
                          chatController
                              .sendMessage(messageFieldController.text);
                          messageFieldController.clear();
                        }
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        size: 22,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final text;
  final read;
  final time;
  final senderId;
  const ChatMessageBubble(
      {Key? key, this.text, this.read, this.time, this.senderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return senderId != Get.arguments
        ? ChatBubble(
            clipper: ChatBubbleClipper2(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 8, bottom: 6, right: 10),
            backGroundColor: Colors.blue,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : ChatBubble(
            clipper: ChatBubbleClipper2(type: BubbleType.receiverBubble),
            backGroundColor: Color(0xffE7E7ED),
            margin: EdgeInsets.only(top: 15, left: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
  }
}
