import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class ChatController extends GetxController{

  var getUserId = "".obs;
  var friendUid = "".obs;
  var friendName = "".obs;
  var friendPhoto = "https://img.icons8.com/pastel-glyph/64/000000/person-male--v3.pn".obs;
  var chatroomId = "".obs;
  var sharedPrefsLoaded = false.obs;


  Future fetchDataFirebase() async {
    DataSnapshot snapshot = await realtimeDatabase.ref("users").child(friendUid.value).get();
    friendName.value = "${snapshot.child("firstName").value.toString()} ${snapshot.child("lastName").value.toString()}";
    //fetch profile photo
    if(snapshot.child("photoUrl").exists){
      friendPhoto.value = snapshot.child("photoUrl").value.toString();
    }
     
  }
  

  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getUserId.value = sharedPreferences.getString("userId") ?? "";

    setActiveInChatroom(getUserId.value);
  }

  setActiveInChatroom(String getId)async{
    DataSnapshot snapshot = await realtimeDatabase
          .ref("chats")
          .child(chatroomId.value)
          .get();
      if (snapshot.hasChild("messages")) {
        realtimeDatabase.ref("chats").child(chatroomId.value).child(getId).set("active");
      }
  }

  setInactiveInChatroom() async {
    DataSnapshot snapshot = await realtimeDatabase.ref("chats").child(chatroomId.value).get();
      if (snapshot.exists) {
        realtimeDatabase.ref("chats").child(chatroomId.value).child(getUserId.value).set("false");
      }
  }

  //when user will click the send button, this function will be called
  sendMessage(String messageText)async{
    //save the message to the realtime database

    DataSnapshot snapshot = await realtimeDatabase.ref("chats").get();

    int childCount = 0;  //get the existing message count to save the new message serially.
    if(snapshot.child(chatroomId.value).child("messages").exists) {
      childCount = int.parse(snapshot.child(chatroomId.value).child("messages").children.length.toString()) ;
      print(childCount.toString()+" childs");
    }
    
    String messageTime = Timestamp.now().toDate().toString();

    storeMessageInfo(chatroomId.value, childCount, "text", messageText);
    storeMessageInfo(chatroomId.value, childCount, "senderId", getUserId.value);
    storeMessageInfo(chatroomId.value, childCount, "receiverId", friendUid.value);
    storeMessageInfo(chatroomId.value, childCount, "read", "false");
    storeMessageInfo(chatroomId.value, childCount, "time", messageTime); //save the time as well

    
    realtimeDatabase.ref("users").child(friendUid.value).child("unseen").child(getUserId.value)
                                  .set(messageText).then((value) {
                                    print("Successfull");
                                  });

    setActiveInChatroom(getUserId.value);

    retrieveActiveChatSharedPrefs().then((value) {
      if(value.isEmpty || !value.contains(friendUid.value)){
        saveActiveChatUsers(friendUid.value, value);
      }
    });
  }
  
  storeMessageInfo(String chatroomId, int childCount, String fieldName, String value){
    realtimeDatabase.ref("chats")
                    .child(chatroomId)
                    .child("messages")
                    .child(childCount.toString())
                    .child(fieldName)
                    .set(value).then((value) {
                      print("Successfull");
                    });
  }

  Future<List<String>> retrieveActiveChatSharedPrefs()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList("active_chat_users")??[];
  }

  saveActiveChatUsers(String friendId, List<String> newList)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    newList.add(friendId);
    sharedPreferences.setStringList("active_chat_users", newList);
  }

  //create a chatroom ID. The ID will always be same between 2 users, doesn't matter if there already one exists

  String generateChatroomId(String friendId){
    List<String> sortedId = [getUserId.value, friendId];
    sortedId.sort();

    return sortedId[0] + sortedId[1];
  }
}