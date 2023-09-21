
import 'package:roam_test/repository/app_url.dart';

import '../network/NetworkApiService.dart';
import '../network/base_api_service.dart';

class MobNumberRepository{

  BaseApiService _apiService = NetworkApiService();

  Future<dynamic> getPostNumberApi(String md5, String base64) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.baseUrl+AppUrl.numberEndpoint+md5, base64);
      print("MobiNumber Repository: "+response.toString());
      return response;
    }
    catch(e){
      throw e;
    }
  }

  Future<dynamic> getPostEmailUpdateApi(String md5, String base64) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.baseUrl+AppUrl.emailUpdateEndpoint+md5, base64);
      print("Email Repository: "+response.toString());
      return response;
    }
    catch(e){
      throw e;
    }
  }
}