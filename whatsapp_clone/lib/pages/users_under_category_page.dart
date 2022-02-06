// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/category_controller.dart';
import 'package:whatsapp_clone/controller/home_controller.dart';
import 'package:whatsapp_clone/models/category_user_model.dart';
import 'package:whatsapp_clone/pages/chat_screen.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class UsersUnderCategoryPage extends StatefulWidget {
  UsersUnderCategoryPage({Key? key}) : super(key: key);

  @override
  State<UsersUnderCategoryPage> createState() => _UsersUnderCategoryPageState();
}

class _UsersUnderCategoryPageState extends State<UsersUnderCategoryPage> {
  CategoryController categoryController = CategoryController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryController.categoryName.value = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Get.arguments ?? "Something went wrong"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder(
            future: categoryController.fetchDataFirebase(),
            builder: (context, snapshot) {
              return Obx(() {
                  
                  return !categoryController.dataLoaded.value?
                    Center(child: CircularProgressIndicator()):
                    categoryController.userIdList.isEmpty
                              ? Center(child: Text("No user found"))
                              :
                    ListView.builder(
                        itemCount: categoryController.userIdList.length,
                        itemBuilder: (context, index) {
                          
                          return CategoryBasedUserListTile(
                            userId: categoryController.userIdList[index],
                            title: categoryController.userNameList[index],
                            location:
                                categoryController.userLocationList[index],
                            pictureUrl: "",
                            onlineStatus:
                                categoryController.userOnlineStatusList[index],
                          );
                        },
                      );
                }
              );
            }));
  }
}

class CategoryBasedUserListTile extends StatelessWidget {
  final title;
  final location;
  final pictureUrl;
  final onlineStatus;
  final userId;
  const CategoryBasedUserListTile({
    Key? key,
    required this.title,
    required this.pictureUrl,
    this.onlineStatus,
    required this.location,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          onTap: () {
            Get.to(() => ChatScreen(), arguments: userId);
          },
          leading: Container(
            height: 65,
            width: 65,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 34,
              foregroundImage: NetworkImage(pictureUrl),
            ),
            alignment: Alignment.center,
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          subtitle: Text(
            location,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.circle,
              size: 12,
              color: onlineStatus == "true" ? Colors.green : Colors.grey,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
