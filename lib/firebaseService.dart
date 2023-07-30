import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_application/utils.dart';
import 'package:chat_application/Model/usersModel.dart';
import 'package:chat_application/Model/messageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FireBaseService{

  //---------------------Getting User Details from FireBase-------------------
  static Stream<List<User>> getAllUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapShot) => snapShot.docs
      .map((document) => User.fromJson(document.data()))
      .toList());

//---------------------uploading User Details to FireBase-------------------

  static addUserToFirebase(String userId, String username) async{
    final refUsers = FirebaseFirestore.instance.collection('/users');
    final newUser = User(
        idUser: userId,
        name: username,
        phoneNumber: userId,
        lastMessageTime: DateTime.now()
    );
    await refUsers.doc(userId).set(newUser.toJson());
  }

  //---------------------uploading message to FireBase-------------------

  static Future uploadMessage(String idUser, String message, String receiverId, String senderId) async {
    String idUserValue ;
    if(int.parse(senderId)>int.parse(receiverId)){
      idUserValue = senderId + "_" + receiverId;
    }else{
      idUserValue = receiverId + "_" + senderId;
    }
    final refMessages =
    FirebaseFirestore.instance.collection('chats_details/$idUserValue/messages');

    SharedPreferences userNamePrefs = await SharedPreferences.getInstance();
    String? userName = userNamePrefs.getString('user_name');

    SharedPreferences phoneNumberPrefs = await SharedPreferences.getInstance();
    String? userId = phoneNumberPrefs.getString('phone_number');

    final newMessage = Message(
      idUser: userId!,
//      username: userName,
      message: message,
      receiverId: receiverId,
      senderId: senderId,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  //---------------------getting message from FireBase-------------------

  static Stream<List<Message>> getMessages(String idUser)=>

      FirebaseFirestore.instance
          .collection('chats_details/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));


  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(idUser: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }

}