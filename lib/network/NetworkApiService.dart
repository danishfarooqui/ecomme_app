
import 'dart:convert';
import 'package:roam_test/network/base_api_service.dart';
import 'package:http/http.dart' as http;

class NetworkApiService implements BaseApiService{

  @override
  Future getGetApiResponse(String url) async{
    dynamic responseJson;
    try{
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }catch(e){
      print(e.toString());
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, data) async{
    dynamic responseJson;
    try{
      http.Response response = await http.post(Uri.parse(url),body: data).timeout(Duration(seconds: 10));
        responseJson = returnResponse(response);
        print("Network response: "+response.body);
      print("NetworkApiservice: "+responseJson['status'].toString());
    }catch(e){
      print("error post response: "+e.toString());
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response){

    switch(response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 500:
      case 404:
        throw Exception(response.body.toString());
      default:
        throw Exception('Error occured while communicating with server '+
            'with status code '+response.statusCode.toString());
    }
  }

}