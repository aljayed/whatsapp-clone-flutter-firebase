// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginController loginController = LoginController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool email = false;
  bool passwordError = false;
  bool passVisibility = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                  prefixIcon: Icon(Icons.email_rounded),
                  errorText: email == true ? "Please Enter a Valid Email" : null,
                  labelText: "Email",
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(height: 30,),
              TextFormField(
                cursorColor: Colors.grey,
                controller: passwordController,
                obscureText: passVisibility,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  suffix: GestureDetector(onTap: (){ setState(() {
                    passVisibility = !passVisibility;
                  }); },
                  child: passVisibility ? Icon(Icons.visibility_off): Icon(Icons.visibility)),
                  prefixIcon: Icon(Icons.lock),
                  errorText: passwordError == true
                      ? "Password must be at least 6 characters"
                      : null,
                  labelText: "Enter Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),

              SizedBox(
              height: 40,
            ),
            SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.amber,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    minimumSize: Size(100, 40), //////// HERE
                  ),
                  onPressed: (){
                    var emailText = emailController.value.text;
                    var passwordText = passwordController.value.text;

                    //form data validation
                    if (emailText.isNotEmpty) {
                     
                      
                            if (passwordController.text.length > 5) {
                              //call signup function
                              loginController.onLoginPressed(
                                  emailText,
                                  passwordText
                                );
                            } else {
                              Get.snackbar("Error",
                                  "Password must be at least 6 characters",
                                  backgroundColor: Colors.amber);
                            }
                          }else {
                      Get.snackbar(
                          "Error", "Please fill all the fields correctly",
                          backgroundColor: Colors.amber);
                    }
                  },
                  child: Obx(()=>!loginController.loading.value ? Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 16),
                  ): Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,width: 30,
                        child: CircularProgressIndicator(color: Colors.yellowAccent,)),
                      SizedBox(width: 20,),
                      Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 16),
                  ),
                    ],
                  ),),
                )),
          ],
        ),
      ),
    );
  }
}