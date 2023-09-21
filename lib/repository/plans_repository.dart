

import 'package:roam_test/network/NetworkApiService.dart';
import 'package:roam_test/network/base_api_service.dart';

import 'app_url.dart';

class PlansRepository{

  BaseApiService _apiService = NetworkApiService();

  Future<dynamic> getPostPlansApi(String md5, String base64) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.baseUrl+AppUrl.plansEndpoint+md5, base64);
      print("BrandsRepository: "+response.toString());
      return response;
    }
    catch(e){
      throw e;
    }
  }
}