import 'package:chat_application/SharedPreference.dart';
import 'package:chat_application/chatDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/Model/messageModel.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/dateAndTime.dart';
import 'firebaseService.dart';

class ChatDetails extends StatefulWidget {
  String? userName;
  String? userId;
  String? uniqueId;
  ChatDetails({this.userName, this.userId, this.uniqueId});
  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetails> {
  TextEditingController _messageController = new TextEditingController();
  String? senderId;
  String? phoneNumber;

  @override
  void initState() {
    getPhoneNumber();
    super.initState();
  }

  //----------------getting userPhone number from SharedPreferences---------------
  getPhoneNumber() async {
    SharedPreferences phoneNumberPrefs = await SharedPreferences.getInstance();
    senderId = phoneNumberPrefs.getString('phone_number');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(this.widget.userName!),
            Text(
              this.widget.userId!,
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<List<Message>>(
              stream: FireBaseService.getMessages(this.widget.uniqueId!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: false,
                          reverse: true,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return Visibility(
                              visible: snapshot.data![index].message!.isNotEmpty,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment:
                                  (snapshot.data![index].idUser == senderId
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color:
                                          (snapshot.data![index].idUser == senderId
                                              ? Colors.blue[200]
                                              : Colors.grey.shade200),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: <Widget>[
//                                            Align(
//                                              alignment: Alignment.bottomLeft,
//                                              child:
                                            Text(
                                              snapshot.data![index].message!,
                                              style: TextStyle(fontSize: 15),
                                            ),
//                                            ),
//                                            Align(
//                                              alignment: Alignment.bottomLeft,
//                                              child: Text(DateAndTime.getDisplayDateNotes(snapshot.data[index].createdAt.toString()),
//                                                textAlign: TextAlign.right,
//                                              style: TextStyle(
//                                                fontSize: 10
//                                              ),),
//                                            )

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_messageController.text != " " &&
                          _messageController.text.length != 0) {
                        FireBaseService.uploadMessage(
                            this.widget.userId!, _messageController.text,this.widget.userId!,senderId!);
                        _messageController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String returnUserId(String receiverId) {
    print("phoneNumer---------------$phoneNumber");

    String idUserValue ;
    if(int.parse(phoneNumber!)>int.parse(receiverId)){
      idUserValue = phoneNumber! + "_" + receiverId;
    }else{
      idUserValue = receiverId + "_" + phoneNumber!;
    }
    return idUserValue;
  }
}
