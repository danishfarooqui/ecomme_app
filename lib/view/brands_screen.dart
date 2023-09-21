import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:roam_test/model/brands_model.dart';
import 'package:roam_test/routes/routes_name.dart';
import 'package:roam_test/view/plans_screen.dart';
import 'package:roam_test/view/widgets/navigation_drawer.dart';
import 'package:roam_test/view_model/BrandsViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/routes_config.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({Key? key}) : super(key: key);

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showNumberPopUp(context);
    // });
  }

  @override
  Widget build(BuildContext context) {

    final brandsProvider = Provider.of<BrandsViewModel>(context, listen: false);

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Choose your destination'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                      // Color.fromRGBO(205, 193, 255, 1.0),
                      Color.fromRGBO(7, 4, 33, 1),
                      Color.fromRGBO(7, 4, 33, 1),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      height: screenSize.height * 0.12,
                      width: screenSize.width,
                      child: Center(
                          child: Text(
                        'Select your country where you want to \nsetup your Budding plan',
                        style: TextStyle(
                            color: Colors.white, fontSize: 14, height: 1.5),
                      )),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Search by country',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            // Use a Material design search bar
                            child: TextField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: TextStyle(color: Colors.white),
                              controller: _searchController,
                              decoration: InputDecoration(
                                focusColor: Colors.white,
                                hintText: 'Country Name',
                                hintStyle: TextStyle(color: Colors.white),
                                // Add a search icon or button to the search bar
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Perform the search here
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            child: FutureBuilder<List<BrandsModel>>(
                              future: _searchController.text.isEmpty
                                  ? brandsProvider.getFour()
                                  : brandsProvider.searchResult(
                                      _searchController.text.toString().trim()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _searchController.text.isEmpty
                                        ? brandsProvider.brandsData.length
                                        : (brandsProvider.brandsData.length > 4
                                            ? 4
                                            : brandsProvider.brandsData.length),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {

                                          Navigator.of(context).pushNamed(
                                              RoutesName.plans,
                                          arguments: ScreenArguments(snapshot.data![index].id.toString()));

                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => PlansScreen(id: snapshot.data![index].id.toString())));
                                        },
                                        child: Card(
                                            color: Colors.black38,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Image.network(snapshot
                                                    .data![index].flag
                                                    .toString()),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].brandName
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )
                                              ],
                                            )),
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                )),
          ),
        ],
      ),
      drawer: Drawer(
        child: NavigationDrawer(),
      ),
    );
  }

  // showNumberPopUp(context) async {
  //   TextEditingController _controller = TextEditingController();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? number = await preferences.getString('phone');
  //   print("Number check: " + number.toString());
  //   if (number.toString() == '0') {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20.0)), //this right here
  //             child: Container(
  //               color: Colors.white,
  //               height: 200,
  //               width: MediaQuery.of(context).size.width,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     TextField(
  //                       style: TextStyle(color: Colors.white),
  //                       controller: _controller,
  //                       decoration: InputDecoration(
  //                         focusColor: Colors.white,
  //                         hintText: 'Country Name',
  //                         hintStyle: TextStyle(color: Colors.white),
  //                         // Add a search icon or button to the search bar
  //                         prefixIcon: IconButton(
  //                           icon: Icon(
  //                             Icons.search,
  //                             color: Colors.white,
  //                           ),
  //                           onPressed: () {
  //                             // Perform the search here
  //                           },
  //                         ),
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: Colors.white, width: 2.0),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: Colors.blue, width: 2.0),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 320.0,
  //                       child: TextButton(
  //                         onPressed: () {},
  //                         child: Text(
  //                           "Save",
  //                           style: TextStyle(color: Colors.black),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //
  //           // return AlertDialog(
  //           //   backgroundColor: Colors.white,
  //           //   title: Text(
  //           //     'Enter your number', style: TextStyle(color: Colors.black),),
  //           //   content: TextField(
  //           //     controller: _controller,
  //           //     decoration: InputDecoration(
  //           //       hintText: "Number",
  //           //     ),
  //           //   ),
  //           //   actions: [
  //           //     MaterialButton(
  //           //       onPressed: () {
  //           //         Navigator.pop(context);
  //           //       },
  //           //       color: Colors.black,
  //           //       child: Text('Submit', style: TextStyle(color: Colors.white),),
  //           //     )
  //           //   ],
  //           // );
  //           // return Container(
  //           //   height: 200,
  //           //   width: 200,
  //           //   color: Colors.white,
  //           //   child: Text('PopUp Window'),
  //           // );
  //         });
  //   }
  // }
}
