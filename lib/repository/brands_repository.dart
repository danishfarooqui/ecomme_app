
import 'package:roam_test/network/NetworkApiService.dart';
import 'package:roam_test/network/base_api_service.dart';
import 'app_url.dart';

class BrandsRepository{

  BaseApiService _apiService = NetworkApiService();

  Future<dynamic> getPostBrandsApi(String md5, String base64) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.baseUrl+AppUrl.brandsEndpoint+md5, base64);
      print("BrandsRepository: "+response.toString());
      return response;
    }
    catch(e){
      throw e;
    }
  }
}