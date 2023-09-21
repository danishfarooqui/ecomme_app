import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:roam_test/model/brands_model.dart';
import 'package:roam_test/view/brands_screen.dart';
import 'package:roam_test/view/widgets/navigation_drawer.dart';
import 'package:roam_test/view_model/number_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_model/BrandsViewModel.dart';

class PopupScreen extends StatefulWidget {
  const PopupScreen({Key? key}) : super(key: key);

  @override
  _PopupScreenState createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> {
  String countryCode = '';
  String number = '';
  String countryId = '';
  String countryName = '';
  bool flag1 = false;//for hiding or showing email text field
  bool flag2 = false;//for hiding or showing email text field
  bool phoneFlag = false;//for hiding number text field
  String otpPin = '';
  bool status = true;
  bool status2 = true;
  bool enable = true; //enabling or disabling number text field
  OtpFieldController otpbox = OtpFieldController();
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkEmail();
    checkNumber();
  }

  @override
  Widget build(BuildContext context) {
    final brandsProvider = Provider.of<BrandsViewModel>(context, listen: false);
    final numberProvider = Provider.of<NumberViewModel>(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              
              SizedBox(height: 10,),
              Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Please enter your whatsapp number to verify", style: TextStyle(color: Colors.white),),
                ),
              ),
              SizedBox(height: 10,),
              phoneFlag?Container(
                  child: IntlPhoneField(
                    enabled: enable,
               style: TextStyle(color: Colors.white),
               dropdownIcon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  //decoration for Input Field
                  counterStyle: TextStyle(color: Colors.white),
                  hintStyle:TextStyle(color: Colors.white),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                initialCountryCode: 'NP', //default contry code, NP for Nepal
                onChanged: (phone) {
                  setState(() {
                    countryCode = phone.countryCode;
                    number = phone.number;
                  });
                  //when phone number country code is changed
                  print(phone.completeNumber); //get complete number
                  print("Country Code: " +
                      phone.countryCode); // get country code only
                  print(phone.number); // only phone number
                },
                onCountryChanged: (country) {
                  setState(() {});
                  countryName = country.name;
                  print(country.name);
                  print("--" + country.dialCode);
                },
              )):Container(),

              SizedBox(height: 5,),

              phoneFlag?SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    List<BrandsModel> brands =
                    await brandsProvider.getBrands();
                    if(number.length<10){
                      showTopSnackBar('Enter Valid Mobile Number!',Colors.red);
                      return;
                    }

                    brands.forEach((element) {
                      if (element.brandName.toString() == countryName) {
                        setState(() {
                          countryId = element.countryId.toString();
                        });
                      }
                      print("Country Id----:" + countryId);
                      print('country Name----' + countryName.toString());
                      return;
                    });
                    numberProvider.updateNumber(number, countryCode, countryId);
                    SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                    preferences.setString('phone', number);
                    otpBox(numberProvider); //calling otpBox
                  },
                  child: Text("Generate Number OTP"),
                ),
              ):Container(),

              SizedBox(height: 40,),

              flag1?Container(
                      child: TextField(
                        controller: _editingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: "Enter email",
                          hintText: 'Enter your email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ):Container(),
              SizedBox(
                height: 10,
              ),

              flag1?SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {

                    print(_editingController.text.toString());
                    numberProvider.updateEmail(_editingController.text.toString());

                     otpBoxEmail(numberProvider); //calling otpBox
                  },
                  child: Text("Generate Email OTP"),
                ),
              ):Container(),

              SizedBox(
                height: 10,
              )
            ],
          )),

    );
  }

  //This Method will show a snack bar from top
  showTopSnackBar(String message, color) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: color,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // checkNumber() async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: const [
  //                   Icon(
  //                     Icons.cancel,
  //                     color: Colors.red,
  //                   ),
  //                   Text("Enter Correct Number"),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  checkNumber() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phoneFlag = false;
    if (preferences.getString('phone').toString() == '0') {
      setState(() {
        phoneFlag = true;
      });
    } else {
      setState(() {
        phoneFlag = false;
      });
    }
  }
  checkEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    flag1 = false;
    if (preferences.getString('email').toString() == '') {
      setState(() {
        flag1 = true;
      });
    } else {
      setState(() {
        flag1 = false;
      });
    }
  }

  otpBox(otpProvider) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Dialog(
                insetPadding:
                    EdgeInsets.only(left: 8.0, right: 8, top: 300, bottom: 300),
                child: Center(
                  child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "Enter OTP Code",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(20)),
                          OTPTextField(
                            controller: otpbox,
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            style: TextStyle(fontSize: 14),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (pin) async {
                              setState(() {
                                otpPin = pin;
                              });
                              print("OTP Pin: " + otpPin);
                              //checking api status here for otp
                              status = await otpProvider.updateNumber(
                                  number, countryCode, countryId, otp: otpPin);

                              if (status) {
                                setState(() {
                                  flag2 = true;
                                  enable = false;
                                });
                                showTopSnackBar("Mobile Number Updated", Colors.green);
                                Navigator.pop(context);
                              } else {
                                showTopSnackBar('Eneter correct OTP',Colors.red);
                              }

                              SharedPreferences _pref = await SharedPreferences.getInstance();
                              if(status && _pref.getString('email')!='')
                              {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: ((context) => BrandsScreen())));
                              }

                              print("Entered OTP Code: $pin");
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),

                        ],
                      )),
                )),
          );
        });
  }
  otpBoxEmail(otpProvider) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Dialog(
                insetPadding:
                EdgeInsets.only(left: 8.0, right: 8, top: 300, bottom: 300),
                child: Center(
                  child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "Enter OTP Code",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(20)),
                          OTPTextField(
                            controller: otpbox,
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            style: TextStyle(fontSize: 14),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (pin) async {
                              setState(() {
                                otpPin = pin;
                              });
                              print("OTP Pin: " + otpPin);
                              //checking api status here for otp

                              status2 = await otpProvider.updateEmail(_editingController.text.toString(), otp: otpPin);
                              print(status2);
                              if(status2){
                                showTopSnackBar('Email Updated', Colors.green);
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: ((context) => BrandsScreen())));
                              } else {
                                showTopSnackBar('Eneter correct OTP',Colors.red);
                              }
                              print("Entered OTP Code: $pin");
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),

                        ],
                      )),
                )),
          );
        });
  }
}
