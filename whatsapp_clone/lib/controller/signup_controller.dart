import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/pages/homepage.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

class SignupController extends GetxController {
  var loading = false.obs;
  onSignupPressed(
      String firstName,
      String lastName,
      String email,
      String password,
      String country,
      String state,
      String city,
      List<String> category) async {
    //do all the sign up functions here
    //do firebase works here.

    loading.value = true;

    try {
      UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;
      Future<DataSnapshot> snapshot = realtimeDatabase.ref("users").get();
      snapshot.then((value) {
        //childCount = value.children.length;
        storeDataFirebase(uid, "email", email);
        storeDataFirebase(uid, "firstName", firstName);
        storeDataFirebase(uid, "lastName", lastName);
        storeDataFirebase(uid, "country", country);
        storeDataFirebase(uid, "state", state);
        storeDataFirebase(uid, "city", city);
        storeDataFirebase(uid, "online", "true");
        storeDataFirebase(uid, "userId", uid);

        category.asMap().forEach((index, element) {
        realtimeDatabase.ref("users").child(uid)
        .child("category").child(index.toString())
        .set(element);
        });
        saveUseridSharedPrefs(uid);
        //All data saving works have been completed, now just move to the homescreen

        loading.value = false;
        Get.offAll(() => Homepage());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error Creating Account",
            'The email is already used, please enter another email or reset the password',
            backgroundColor: Colors.amber);
      }
    } catch (err) {
      Get.snackbar("Error creating account", err.toString());
    }
  }

  storeDataFirebase(String uid, String item, String value) {
    realtimeDatabase
        .ref("users")
        .child(uid)
        .child(item)
        .set(value);
  }
  saveUseridSharedPrefs(String uid) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("userId", uid);
  }
}
