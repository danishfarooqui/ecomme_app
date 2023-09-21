import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:roam_test/model/plans_model.dart';
import 'package:roam_test/repository/plans_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/brands_repository.dart';

class PlansViewModel extends ChangeNotifier{

  final _plansRepository = PlansRepository();

  List<PlansModel> _plansData = [];


  List<PlansModel> get plansData => _plansData;

  setData(List<PlansModel> data){
    _plansData = data;
    print("_plansData"+_plansData.toString());
    notifyListeners();
  }

  Future<List<PlansModel>> getPlans(String id) async{
    //Getting saved token from preferences
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final token = _pref.getString('token');
    Map<String,dynamic> valueData = {};
    valueData['"user_id"'] ='"'+token.toString()+'"';
    valueData['"brand_id"'] ='"'+id.toString()+'"';
    String md55 = generateMd5("user_id="+token.toString()+"&brand_id="+id);
    String base64 = generateBase64(valueData.toString());
    final response = await _plansRepository.getPostPlansApi(md55, base64);
    final List res = response['data'];
    print('plans repo: '+res.toString());
    final data = res.map((e) => PlansModel.fromJson(e)).toList();
    print('ashadjhsdj: '+data.toString());
    setData(data);
    notifyListeners();
    return data;
  }

  // Future<List<PlansModel>> getFour() async{
  //   List<PlansModel> plans = await getPlans(id);
  //   notifyListeners();
  //   return plans;
  // }

  String generateMd5(String input){
    return md5.convert(utf8.encode(input)).toString();
  }

  String generateBase64(String input) {
    String mydata = input;
    String bs64 = base64.encode(mydata.codeUnits);
    print(bs64);
    return bs64;
  }
}