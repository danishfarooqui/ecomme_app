import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:roam_test/repository/mobnumber_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberViewModel extends ChangeNotifier {
  final _numberRepository = MobNumberRepository();

  Future updateNumber(String number, String countryCode, String countryId, {String otp = ''}) async {

    bool status = true;
    //Getting saved token from preferences
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final token = _pref.getString('token');
    final Map<String, dynamic> valueData = {};
    valueData['"user_id"'] = '"' + token.toString() + '"';
    valueData['"country_code"'] = '"' + countryCode.toString() + '"';
    valueData['"mobile_number"'] = '"' + number.toString() + '"';
    valueData['"country_id"'] = '"' + countryId.toString() + '"';
    String params = '';
    if (otp == '') {
      valueData['"type"'] = '"send-otp"';
      params = '&type=send-otp';
    } else {
      valueData['"otp"'] = '"' + otp + '"';
      params = '&otp=' + otp;
    }
    String md55 = generateMd5("user_id=" +
        token.toString() +
        "&country_code=" +
        countryCode +
        "&mobile_number=" +
        number +
        "&country_id=" +
        countryId +
        params);
    String base64 = generateBase64(valueData.toString());
    final response =
        await _numberRepository.getPostNumberApi(md55, base64).then((value) {
      status = value['status'];
    });


    return status;
  }


  Future updateEmail(String email,{String otp=''})async{
    print('method printing');
    bool status = true;
    //Getting saved token from preferences
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final token = _pref.getString('token');
    final Map<String, dynamic> valueData = {};
    valueData['"user_id"'] = '"' + token.toString() + '"';
    valueData['"email"'] = '"' + email.toString() + '"';
    String params = '';
    if (otp == '') {
      valueData['"type"'] = '"send-otp"';
      params = '&type=send-otp';
    } else {
      valueData['"otp"'] = '"' + otp + '"';
      params = '&otp=' + otp;
    }
    String md55 = generateMd5("user_id=" + token.toString() +"&email="+email+ params);
    String base64 = generateBase64(valueData.toString());
    final response = await _numberRepository.getPostEmailUpdateApi(md55, base64).then((value) {
      status = value['status'];
    });

    if(status){
      _pref.setString('email', email);
    }

    return status;
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String generateBase64(String input) {
    String mydata = input;
    String bs64 = base64.encode(mydata.codeUnits);
    print(bs64);
    return bs64;
  }
}
