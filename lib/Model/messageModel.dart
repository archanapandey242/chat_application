import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String? idUser;
//  final String username;
  final String? message;
  final DateTime? createdAt;
  final String? senderId;
  final String? receiverId;


  const Message({
    @required this.idUser,
//    @required this.username,
    @required this.message,
    @required this.createdAt,
    @required this.senderId,
    @required this.receiverId,

  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    idUser: json['idUser'],
//    username: json['username'],
    message: json['message'],
    senderId: json['sender_id'],
    receiverId: json['receiver_id'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'idUser': idUser,
//    'username': username,
    'message': message,
    'sender_id': senderId,
    'receiver_id':receiverId,
    'createdAt': Utils.fromDateTimeToJson(createdAt!),
  };
}
