// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/controller/signup_controller.dart';
import 'package:whatsapp_clone/pages/homepage.dart';
import 'package:whatsapp_clone/widgets/constants.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var countryValue;
  var stateValue;
  var cityValue;
  bool passwordError = false;
  bool passVisibility = true;
  List<String> selectedCategories = [];
  
  bool defValue = false;
  bool categoryError = false;

  var categoryCheckboxList = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool firstName = false;
  bool lastName = false;
  bool email = false;
  bool password = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var e in allCategories) {
      categoryCheckboxList.add(CheckboxModel(title: e));
    }
  }

  @override
  Widget build(BuildContext context) {
    SignupController signupController = SignupController();

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: [
            SizedBox(height: 15),
            TextFormField(
              cursorColor: Colors.grey,
              cursorHeight: 22,
              controller: firstNameController,
              onChanged: (text) {
                setState(() {
                  if (text.isEmpty) {
                    firstName = true;
                  } else {
                    firstName = false;
                  }
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                errorText:
                    firstName == true ? "This Field Cannot be Empty" : null,
                labelText: "First Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              cursorColor: Colors.grey,
              cursorHeight: 22,
              controller: lastNameController,
              onChanged: (text) {
                setState(() {
                  if (text.isEmpty) {
                    lastName = true;
                  } else {
                    lastName = false;
                  }
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                errorText:
                    lastName == true ? "This Field Cannot be Empty" : null,
                labelText: "Last Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.grey,
              cursorHeight: 22,
              controller: emailController,
              onChanged: (text) {
                setState(() {
                  if (text.isEmpty) {
                    email = true;
                  } else {
                    email = false;
                  }
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                prefixIcon: Icon(Icons.email_rounded),
                errorText: email == true ? "Please Enter a Valid Email" : null,
                labelText: "Email",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CSCPicker(
                showStates: true,
                showCities: true,
                layout: Layout.vertical,
                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                onCountryChanged: (value) {
                  setState(() {
                    //countryValue = "$countryValue$value";
                    countryValue = value;
                    //print(value);
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    //stateValue = "$stateValue$value";
                    stateValue = value;
                    //print("state value is "+value!);
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    //cityValue = "$cityValue$value";
                    cityValue = value??"blank";
                    //print("city is "+value!);
                  });
                },
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.brown, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      categoryError == false
                          ? "Select up to 3 categories"
                          : "Too many categories selected",
                      style: TextStyle(
                          color: categoryError == false
                              ? Colors.black87
                              : Colors.red),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ...categoryCheckboxList.map((e) => Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.green,
                              value: e.checkValue,
                              onChanged: (state) {
                                setState(() {
                                  onItemClicked(e);
                                });
                              },
                            ),
                            Text(e.title),
                          ],
                        ))
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              cursorColor: Colors.grey,
              controller: passwordController,
              obscureText: passVisibility,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        passVisibility = !passVisibility;
                      });
                    },
                    child: passVisibility
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                prefixIcon: Icon(Icons.lock),
                errorText: passwordError == true
                    ? "Password must be at least 6 characters"
                    : null,
                labelText: "Enter Password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(
              height: 30,
            ),

            //signup button is down below
            SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.amber,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    minimumSize: Size(100, 40), 
                  ),
                  onPressed: () {
                    
                    print(signupController.loading.value);
                    var fname = firstNameController.value.text;
                    var lname = lastNameController.value.text;
                    var emailText = emailController.value.text;
                    var passwordText = passwordController.value.text;

                    //form data validation
                    if (fname.isNotEmpty && lname.isNotEmpty && emailText.isNotEmpty) {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailText);
                      if (emailValid == true) {
                        if (categoryError == false &&
                            selectedCategories.length >= 1) {
                          if (countryValue != null && stateValue != null) {
                            if (passwordController.text.length > 5) {
                              
                              //call signup function here
                              signupController.onSignupPressed(
                                  fname,
                                  lname,
                                  emailText,
                                  passwordText,
                                  countryValue.toString(),
                                  stateValue.toString(),
                                  cityValue.toString(),
                                  selectedCategories
                                );

                            } else {
                              Get.snackbar("Error",
                                  "Password must be at least 6 characters",
                                  backgroundColor: Colors.amber);
                            }
                          } else {
                            Get.snackbar(
                                "Error", "Please select your Country, State and City",
                                backgroundColor: Colors.amber);
                          }
                        } else {
                          Get.snackbar("Error",
                              "Please select at least one category (Max 3)",
                              backgroundColor: Colors.amber);
                        }
                      } else {
                        Get.snackbar("Error",
                            "Email is not valid, please enter a valid Email",
                            backgroundColor: Colors.amber);
                      }
                    } else {
                      Get.snackbar(
                          "Error", "Please fill all the fields correctly",
                          backgroundColor: Colors.amber);
                    }
                  },
                  //button text or loading indicator when loading is true
                  child: Obx(()=>!signupController.loading.value ? Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 16),
                  ): Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,width: 30,
                        child: CircularProgressIndicator(color: Colors.yellowAccent,)),
                      SizedBox(width: 20,),
                      Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 16),
                  ),
                    ],
                  ),)
                )),
            SizedBox(
              height: 40,
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Get.to(LoginScreen());
                  },
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                        color: Colors.pink[600],
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  onItemClicked(CheckboxModel ckbItem) {
    setState(() {
      ckbItem.checkValue = !ckbItem.checkValue;
      if (ckbItem.checkValue == true) {
        selectedCategories.add(ckbItem.title);
      } else if (ckbItem.checkValue == false) {
        selectedCategories.remove(ckbItem.title);
      }
      print(selectedCategories);

      if (selectedCategories.length > 3) {
        categoryError = true;
      } else if (selectedCategories.length <= 3) {
        categoryError = false;
      }
    });
  }
}

class CheckboxModel {
  String title;
  bool checkValue;
  CheckboxModel({required this.title, this.checkValue = false});
}

class textfieldModel {
  String hintText;
  bool enableError;
  String? textValue = "";
  textfieldModel(
      {required this.hintText, this.enableError = false, this.textValue});
}
