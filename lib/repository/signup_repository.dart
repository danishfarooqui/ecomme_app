

import 'package:roam_test/network/NetworkApiService.dart';
import 'package:roam_test/network/base_api_service.dart';

class SignUpRepository{

  BaseApiService _apiService = NetworkApiService();

Future<dynamic> signInPostAuth(String md5, String base64) async{
      dynamic response= await _apiService.getPostApiResponse('https://staging.commbitz.com/api/login?token='+md5, base64);

      return response;

  }
}