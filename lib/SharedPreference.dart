import 'package:shared_preferences/shared_preferences.dart';
class SharedPreference{
  static addPhoneNumberToSF(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', phoneNumber);
  }

  static getPhoneNumberSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    String? intValue = prefs.getString('phone_number');
    return intValue;
  }

  static addUserNameToSF(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', userName);
  }

  static getUserNameSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    String? intValue = prefs.getString('user_name');
    return intValue;
  }
}