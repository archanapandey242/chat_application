import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String? idUser;
  final String? name;
  final DateTime? lastMessageTime;
  final String? phoneNumber;

  const User({
    this.idUser,
    this.name,
    this.lastMessageTime,
    this.phoneNumber
  });

  User copyWith({
    String? idUser,
    String? name,
    DateTime? lastMessageTime,
    String? phoneNumber
  }) =>
      User(
          idUser: idUser ?? this.idUser,
          name: name ?? this.name,
          lastMessageTime: lastMessageTime,
          phoneNumber: phoneNumber??this.phoneNumber
      );

  static User fromJson(Map<String, dynamic> json) => User(
    idUser: json['userId'],
    name: json['username'],
    phoneNumber: json['phone_number'],
    lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
  );

  Map<String, dynamic> toJson() => {
    'userId': idUser,
    'username': name,
    'phone_number':phoneNumber,
    'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime!),
  };
}
