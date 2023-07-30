import 'package:chat_application/Model/dateAndTime.dart';
import 'package:chat_application/chatDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebaseService.dart';
import 'package:chat_application/Model/usersModel.dart';

import 'login.dart';

class RecentChatPage extends StatefulWidget {
  final String userId;
  RecentChatPage(this.userId);

  @override
  _RecentChatPageState createState() => _RecentChatPageState();
}

class _RecentChatPageState extends State<RecentChatPage> {
  ScrollController _scrollController = ScrollController();
  final TextEditingController _userController =  TextEditingController();
  final TextEditingController _userIdController =  TextEditingController();

  bool isLoading = false;
  int currentMax = 10;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {}
      });

  }

  getPhoneNumber() async {
    SharedPreferences phoneNumberPrefs = await SharedPreferences.getInstance();
    phoneNumber = phoneNumberPrefs.getString('phone_number');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text("Recent Chat"),
            InkWell(child: const Text("Logout"),onTap: (){
              Navigator.of(context).push(MaterialPageRoute<Login>(
                  builder: (BuildContext context) {
                    return Login();
                  }));
            },)
          ],
        ),
      ),
      body: showRecentChat(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  showRecentChat() {
    return Center(
      child: StreamBuilder<List<User>>(
          stream: FireBaseService.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                print("snapshot.hasdata---------------${snapshot}");

                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return Visibility(
                        visible: returnUserList(snapshot.data!, index)!="",
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ChatDetails(
                                      userName: snapshot.data![index].name,
                                      userId: snapshot.data![index].idUser,uniqueId:returnUniqueId(snapshot.data![index].idUser!,this.widget.userId));
                                }));
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(returnUserList(
                                          snapshot.data!, index),textAlign: TextAlign.start,),
                                    ),
                                    const Spacer(),
                                    Text(DateAndTime.getDisplayDateNotes(snapshot.data![index].lastMessageTime.toString()),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
            }
          }),
    );
  }

  //--------------------Dialog box for adding username and phone number----------------
  addUserToFirebase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Add Users"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: _userController,
                onSubmitted: (value) {},
                autofocus: false,
                onTap: () {},
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Add UserName",
                  filled: false,
                  focusedBorder: InputBorder.none,
                ),
              ),
              TextField(
                controller: _userIdController,
                onSubmitted: (value) {},
                autofocus: false,
                onTap: () {},
                keyboardType: TextInputType.phone,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Add Phone Number",
                  filled: false,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                if (_userIdController.text.length >= 10) {
                  FireBaseService.addUserToFirebase(
                      _userIdController.text, _userController.text);
                  Navigator.of(context).pop();
                } else {}
              },
            ),
          ],
        );
      },
    );
  }

  String returnUserList(
      List<User> userData,
      int index,
      ) {
    String userName;
    if (userData[index].idUser != phoneNumber) {
      userName = userData[index].name!;
    }else{
      userName = "";
    }
    return userName;
  }

  String returnUniqueId(String receiverId, String senderId) {
    String idUserValue ;
    if(int.parse(phoneNumber!)>int.parse(receiverId)){
      idUserValue = phoneNumber! + "_" + receiverId;
    }else{
      idUserValue = receiverId + "_" + phoneNumber!;
    }
    return idUserValue;
  }
}
