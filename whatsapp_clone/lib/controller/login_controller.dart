import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/pages/homepage.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class LoginController extends GetxController{

  var loading = false.obs;

  onLoginPressed(String email, String password)async{

    loading.value = true;

    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    saveUseridSharedPrefs(uid);

    loading.value = false;
    Get.offAll(() => Homepage());
    
    } on FirebaseAuthException catch(error) {
      Get.snackbar("Login error", error.message.toString(), backgroundColor: Colors.amber);
    }
  }

  saveUseridSharedPrefs(String uid)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("userId", uid);
  }
}