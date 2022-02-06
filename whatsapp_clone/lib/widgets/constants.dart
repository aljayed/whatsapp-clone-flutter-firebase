import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
var realtimeDatabase = FirebaseDatabase.instance;

List<String> allCategories = [
    "Category 1", "Category 2", "Category 3", "Category 4", "Category 5", "Category 6", "Category 7", "Category 8", "Category 9",  "Category 10", "Category 11", "Category 12", "Category 13", "Category 14", "Category 15", "Category 16", "Category 17", "Category 18", "Category 19", "Category 20",
  ];


