import 'package:chat_application/Model/usersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebaseService.dart';
import 'recentChat.dart';
import 'SharedPreference.dart';
import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final TextEditingController _userIdController =  TextEditingController();
  final TextEditingController _userNameController =  TextEditingController();

  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool showError = false;
  bool isSignUp = false;
  String? userName;
  String? invalidNumberText;
  bool is_valid = false;
  LocalStorage localStorage =  LocalStorage('isLoggedIn');
  LocalStorage localStoragePhoneNumber =  LocalStorage('phone_number');

  @override
  Widget build(BuildContext context) {
    final phoneNumber = TextField(
      controller: _userIdController,
      keyboardType: TextInputType.phone,
      style: style,
      onChanged: (text) {
        setState(() {
          showError = false;
          invalidNumberText = "";
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Mobile Number",
          errorText: invalidNumberText,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final userName = TextField(
      controller: _userNameController,
      style: style,
      onTap: () {
        setState(() {
          showError = false;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter User Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    //Sign Up
    final signUp = TextButton(
      onPressed: () {
        setState(() {
          isSignUp = !isSignUp;
        });
      },
      child:  const Text(
        "Sign Up",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(visible: isSignUp, child: userName),
                const SizedBox(
                  height: 35.0,
                ),
                phoneNumber,
                const SizedBox(
                  height: 35.0,
                ),
                Visibility(
                    visible: showError,
                    child: const Text(
                      "Enter value",
                      style: TextStyle(color: Colors.red),
                    )),
                const SizedBox(
                  height: 35.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: const Color(0xff01A0C7),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      if (_userIdController.text.length < 10) {
                        setState(() {
                          showError = true;
                        });
                      } else {
                        setState(() {
                          localStorage.setItem("isLoggedIn", true);
                          localStoragePhoneNumber.setItem(
                              "phone_number", _userIdController.text);
                          SharedPreference.addPhoneNumberToSF(
                              _userIdController.text);
                          SharedPreference.addUserNameToSF(
                              _userNameController.text);
                          if (isSignUp) {
                            if (_userIdController.text.length >= 10) {
                              FireBaseService.addUserToFirebase(
                                  _userIdController.text,
                                  _userNameController.text);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return RecentChatPage(_userIdController.text);
                                  }));
                            }
                          } else {
                            FirebaseFirestore.instance
                                .collection("/users")
                                .get()
                                .then((querySnapshot) {
                              querySnapshot.docs.forEach((result) {
                                result.data().forEach((key, value) {
                                  if (key == 'phone_number' &&
                                      value == _userIdController.text) {
                                    print("gfcfvjb jn =======$value");

                                    setState(() {
                                      invalidNumberText = "";
                                      is_valid = true;
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return RecentChatPage(
                                                _userIdController.text);
                                          }));
                                    });
                                  }else{
                                    setState(() {
                                      invalidNumberText = "Please register your number";
                                    });
                                  }
                                });
                              });
                            });
                          }
                        });
                      }
                    },
                    child: Text(isSignUp ? "Register" : "Login",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                signUp
              ],
            ),
          ),
        ),
      ),
    );
  }
}
