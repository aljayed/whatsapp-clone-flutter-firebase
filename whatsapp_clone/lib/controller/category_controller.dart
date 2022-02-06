import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class CategoryController extends GetxController {
  var categoryName = "".obs;
  var userIdList = [].obs;
  var userNameList = [].obs;
  var userLocationList = [].obs;
  var userOnlineStatusList = [].obs;
  var dataLoaded = false.obs;
  var getUserId = "".obs;

  //user personal info

  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getUserId.value = sharedPreferences.getString("userId") ?? "";
  }

  fetchDataFirebase() {
    Future<DataSnapshot> snapshot = realtimeDatabase.ref("users").get();
    snapshot.then((value) {
      value.children.toList().asMap().forEach((key, value) {
          checkUserCategory(value, 0, categoryName.value);
          checkUserCategory(value, 1, categoryName.value);
          checkUserCategory(value, 2, categoryName.value);
      });
    });
  }

  checkUserCategory(DataSnapshot value, int index, String categoryName) {
    if (value.child("category").child(index.toString()).exists) {
      if (value.child("category").child(index.toString()).value == categoryName) {
        
        userIdList.add(value.key.toString());
        userNameList.add(
            "${value.child("firstName").value.toString()} ${value.child("lastName").value.toString()}");
        userOnlineStatusList.add(value.child("online").value.toString());

        if(value.child("city").value.toString()!="blank"){
          userLocationList.add(
            "${value.child("city").value.toString()}, ${value.child("state").value.toString()}, ${value.child("country").value.toString()}"
          );
        }
        else{
          userLocationList.add(
            "${value.child("state").value.toString()}, ${value.child("country").value.toString()}"
          );
        }
        
      }
    }
    dataLoaded.value = true;
  }
}
