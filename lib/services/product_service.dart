
import 'package:ecommeapp/repository/repository.dart';

class ProductService{
  Repository _repository;
  ProductService(){
    _repository = Repository();
  }

  getHotProducts() async {
    return await _repository.httpGet('get-all-hot-products');
  }

  getNewProducts() async{
    return await _repository.httpGet('get-all-new-products');
  }

  getProductByCategoryId(categoryId) async{
    return await _repository.httpGetById('get-products-by-category',categoryId);
  }
}