

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:roam_test/repository/brands_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/brands_model.dart';
import '../network/NetworkApiService.dart';
import '../network/base_api_service.dart';
import 'package:http/http.dart' as http;

class BrandsViewModel extends ChangeNotifier{

  final _brandsRepository = BrandsRepository();

  List<BrandsModel> _brandsData = [];
  // List<BrandsModel> fourBrands = [];

  List<BrandsModel> get brandsData => _brandsData;

  setData(List<BrandsModel> data){
    _brandsData = data;
    print(_brandsData.toString());
    notifyListeners();
  }

  Future<List<BrandsModel>> getBrands() async{

    //Getting saved token from preferences
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final token = _pref.getString('token');
    Map<String,dynamic> valueData = {};
    valueData['"user_id"'] ='"'+token.toString()+'"';
    String md55 = generateMd5("user_id="+token.toString());
    String base64 = generateBase64(valueData.toString());
    final response = await _brandsRepository.getPostBrandsApi(md55, base64);
    final List res = response['data'];
    print('ppppppp: '+res.toString());
    final data = res.map((e) => BrandsModel.fromJson(e)).toList();
    print('ashadjhsdj: '+data.toString());
    notifyListeners();
   return data;

  }

  Future<List<BrandsModel>> getFour() async{
    List<BrandsModel> brands = await getBrands();
    List<BrandsModel> newBrands = [];
    for(int i=0;i<brands.length;i++){
      if(brands[i].brandName=='Turkey'){
        print(brands[i].brandName);
        newBrands.add(brands[i]);
      }
      else if(brands[i].brandName=='United States'){
        print(brands[i].brandName);
        newBrands.add(brands[i]);
      }
      else if(brands[i].brandName=='United Kingdom'){
        print(brands[i].brandName);
        newBrands.add(brands[i]);
      }
      else if(brands[i].brandName=='Austria'){
        print(brands[i].brandName);
        newBrands.add(brands[i]);
      }
    }
    setData(newBrands);
    notifyListeners();
    return _brandsData;
  }

  Future<List<BrandsModel>> searchResult(String searchQuery) async{
    List<BrandsModel> brands = await getBrands();
    _brandsData = brands.where((element) => element.brandName!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    print('-----Calling search result');
   notifyListeners();
    return _brandsData;

  }



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

//{status: true, data: [{id: 83, oauth_uid: 6242159969245122}]}

// Future<List<BrandsModel>> fetchAlbum() async {
//   SharedPreferences _pref = await SharedPreferences.getInstance();
//   final token = _pref.getString('token');
//
//   print('------------'+token.toString());
//   Map<String,dynamic> valueData = {};
//   valueData['"user_id"'] ='"'+token.toString()+'"';
//   String md55 = generateMd5("user_id="+token.toString());
//   String base64 = generateBase64(valueData.toString());
//   final response = await http.post(Uri.parse(
//       'https://staging.commbitz.com/api/get-brands?token='+md55),body:base64);
//
//   if (response.statusCode == 200) {
//     final result = json.decode(response.body);
//     final List res = result['data'];
//     print('ppppppp: '+res.toString());
//     final data = res.map((e) => BrandsModel.fromJson(e)).toList();
//     print('ashadjhsdj: '+data.toString());
//     return data;
//   } else {
//     throw Exception('Failed to load data');
//   }
// }