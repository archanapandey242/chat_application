import 'package:chat_application/recentChat.dart';
import 'package:chat_application/recentChat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//  await FirebaseApi.addRandomUsers(Users.initUsers);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Demo', home: MyHomePage(),debugShowCheckedModeBanner: false,);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false;
  String? userName;
  String? phoneNumber;
  LocalStorage localStorage =  LocalStorage('isLoggedIn');
  LocalStorage phoneNumberLocalStorage =  LocalStorage("phone_number");

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: localStorage.ready,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == true) {
            //checking user logged in or not
            isLoggedIn = localStorage.getItem('isLoggedIn')??false;
            phoneNumber = phoneNumberLocalStorage.getItem('phone_number');
            // ignore: unnecessary_null_comparison
            if(isLoggedIn==null) {
              return Login();
            }else{
              return isLoggedIn ? RecentChatPage(phoneNumber!) : Login();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }


}
