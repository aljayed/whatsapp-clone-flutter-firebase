import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class HomeController extends GetxController{

  var getUserId = "".obs;
  var activeChatUsersList = [].obs;

  //var nameList = [].obs;
  //var isOnlineList = [].obs;
  //var locationList = [].obs;
  //var dataLoaded = false.obs;

  // fetchDataFirebase() async{
  //   DataSnapshot snapshot = await realtimeDatabase.ref("users").get();
  //   if(activeChatUsersList.isNotEmpty){
  //     activeChatUsersList.map((element) {
  //       nameList.add(snapshot.child(element).child("firstName").value.toString() 
  //                       + snapshot.child(element).child("lastName").value.toString());
      
  //     });
  //   }
  //   dataLoaded.value = true;
  // }

  //Retrieve Active Chat Users
  Future retrieveActiveChatSharedPrefs()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    activeChatUsersList.value = sharedPreferences.getStringList("active_chat_users")??[];
  }

  setOnlineStatus(bool isOnline) {
    realtimeDatabase.ref("users").child(getUserId.value).child("online").set(isOnline.toString());
  }
  
  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getUserId.value = sharedPreferences.getString("userId") ?? "";
  }
}