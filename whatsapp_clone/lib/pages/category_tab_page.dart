// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/pages/users_under_category_page.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class CategoryTabPage extends StatefulWidget {
  const CategoryTabPage({Key? key}) : super(key: key);

  @override
  _CategoryTabPageState createState() => _CategoryTabPageState();
}

class _CategoryTabPageState extends State<CategoryTabPage> {

  var getUserId = "".obs;

  @override
  void initState() {
    super.initState();
    fetchUserId().then((value) {
      print(getUserId.value);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allCategories.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(5),
              onTap: (){
                Get.to(()=> UsersUnderCategoryPage(), arguments: allCategories[index]);
              },
              title: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  allCategories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(Icons.arrow_forward_ios, size: 20,),
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }

  Future fetchUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getUserId.value = sharedPreferences.getString("userId") ?? "";
  }
}
