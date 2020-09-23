

import 'package:ecommeapp/models/Payment.dart';
import 'package:ecommeapp/repository/repository.dart';

class PaymentService{
    Repository _repository;

    PaymentService(){
      _repository = Repository();
    }

    makePayment(Payment payment) async{
      return await _repository.httpPost('make-payment', payment.toJson());
    }

}