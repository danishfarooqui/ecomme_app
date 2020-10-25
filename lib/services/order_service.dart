
import 'package:ecommeapp/repository/repository.dart';

class OrderService{

  Repository _repository;

  OrderService(){
    _repository = Repository();
  }

  getOrderByUserId(int userId) async{
    return await _repository.httpGetById('order-list-by-user-id', userId);
  }

}