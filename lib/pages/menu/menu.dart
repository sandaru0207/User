import 'dart:convert';
import 'package:canteen/backgrounds/signup_bg.dart';
import 'package:canteen/pages/menu/food_card.dart';
import 'package:canteen/pages/menu/food_class.dart';
import 'package:canteen/pages/menu/food_item.dart';
import 'package:canteen/pages/userorder/orderpage.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:canteen/config/config.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Totalprovider with ChangeNotifier {
  int total = 0;

  inctotal(int price) {
    total = total + price;
    notifyListeners();
  }

  dectotal(int price) {
    total = total - price;
    notifyListeners();
  }
}

class menupage extends StatefulWidget {
  final token;
  const menupage({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<menupage> createState() => _menupageState();
}

class _menupageState extends State<menupage> {
  Future<List<Menu>> menus = getmenu();

  String proname = "";
  String profac = "";
  String proaddress = "";

  static Future<List<Menu>> getmenu() async {
    final response = await http.get(Uri.parse(menulist));
    final body = json.decode(response.body);
    return body.map<Menu>(Menu.fromJson).toList();
  }

  late String student_id;
  String mobile_number = "";

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    student_id = jwtDecodedToken['student_id'];
    getmenu();
  }

  @override
  Widget build(BuildContext context) {
    void getprofiledetails(size) async {
      var regbody = {
        "student_id": student_id,
      };

      var response = await http.post(Uri.parse(getprodetails),
          headers: {"content-Type": "application/json"},
          body: jsonEncode(regbody));

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      setState(() {
        proname = jsonResponse['name'];
        profac = jsonResponse['faculty'];
        proaddress = jsonResponse['address'];
        mobile_number = jsonResponse['mobile_number'] ?? "";
      });

      profileshowdialog(size);
    }

    void placeorder(int total) async {
      var regbody = {
        "student_id": student_id,
        "total": total,
        "veg_count": food_item.veg_count,
        "veg_price": food_item.veg_price,
        "egg_count": food_item.egg_count,
        "egg_price": food_item.egg_price,
        "chicken_count": food_item.chicken_count,
        "chicken_price": food_item.chicken_price,
        "rice_count": food_item.rice_count,
        "rice_price": food_item.rice_price,
        "kottu_count": food_item.kottu_count,
        "kottu_price": food_item.kottu_price,
        "fish_count": food_item.fish_count,
        "fish_price": food_item.fish_price,
      };

      try {
        var response = await http.post(Uri.parse(placeorderapi),
            headers: {"content-Type": "application/json"},
            body: jsonEncode(regbody));

        if (response.statusCode == 200) {
          var jsonResponce = jsonDecode(response.body);
          print("Response status: ${jsonResponce['status']}");
        } else {
          print("Server returned an error: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("Place order failed: $e");
      }
    }

    Size size = MediaQuery.of(context).size;
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
String title = "$date Menu";

    return ChangeNotifierProvider(
      create: (context) => Totalprovider(),
      child: Scaffold(
        body: Background(
          child: Container(
            width: double.infinity,
            height: size.height,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: size.height * 0.01,
                    ),
                    Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/profile.png"),
                          width: size.width * 0.12,
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              splashColor: Colors.black12,
                              onTap: () {
                                getprofiledetails(size);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Hi $student_id',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.05,
                          color: const Color.fromRGBO(60, 121, 98, 1.0)),
                    ),
                    Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/cart.png"),
                          width: size.width * 0.12,
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              splashColor: Colors.black12,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => orderpage(
                                              studentId: student_id,
                                            )));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.height * 0.01,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  "$date Menu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.06,
                      color: const Color.fromRGBO(60, 121, 98, 1.0)),
                ),
                Expanded(
                    child: FutureBuilder<List<Menu>>(
                        future: menus,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive();
                          } else if (snapshot.hasData) {
                            final menus = snapshot.data!;

                            return buildmenus(menus);
                          } else {
                            return const Text("No Menu data");
                          }
                        })),
                Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: size.width * 0.04),
                        Container(
                          padding: EdgeInsets.only(
                              left: size.width * 0.03,
                              top: size.width * 0.02,
                              bottom: size.width * 0.02,
                              right: size.width * 0.03),
                          width: size.width * 0.25,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(119, 187, 162, 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: IconButton(
                              color: const Color.fromARGB(255, 11, 105, 69),
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              icon: const Icon(Icons.backspace_sharp)),
                        ),
                        Consumer<Totalprovider>(
                          builder: (context, totalprovider, child) => Container(
                            padding: EdgeInsets.only(
                                left: size.width * 0.03,
                                top: size.width * 0.02,
                                bottom: size.width * 0.02,
                                right: size.width * 0.03),
                            width: size.width * 0.35,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(119, 187, 162, 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Rs. ${totalprovider.total}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.05,
                                  color:
                                      const Color.fromRGBO(60, 121, 98, 1.0)),
                            ),
                          ),
                        ),
                        Consumer<Totalprovider>(
                          builder: (context, totalprovider, child) => Container(
                            padding: EdgeInsets.only(
                                left: size.width * 0.03,
                                top: size.width * 0.02,
                                bottom: size.width * 0.02,
                                right: size.width * 0.03),
                            width: size.width * 0.25,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(119, 187, 162, 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: IconButton(
                                color: const Color.fromARGB(255, 11, 105, 69),
                                onPressed: () {
                                  if (totalprovider.total > 0) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GiffyDialog.lottie(
                                          backgroundColor: Colors.white,
                                          entryAnimation: EntryAnimation.bottom,
                                          Lottie.asset(
                                            "assets/cooking.json",
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(
                                            'Confirm Your Order',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.05,
                                                color: const Color.fromRGBO(
                                                    60, 121, 98, 1.0)),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'CANCEL'),
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            size.width * 0.035,
                                                        color: const Color
                                                            .fromRGBO(
                                                            60, 121, 98, 1.0)),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    placeorder(
                                                        totalprovider.total);

                                                    Navigator.pop(
                                                        context, 'OK');
                                                  },
                                                  child: Text('OK',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: size.width *
                                                              0.035,
                                                          color: const Color
                                                              .fromRGBO(60, 121,
                                                              98, 1.0))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(Icons.double_arrow)),
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                      ],
                    ),
                    SizedBox(height: size.height * 0.15),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void profileshowdialog(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GiffyDialog.lottie(
            backgroundColor: Colors.white,
            Lottie.asset(
              "assets/profile.json",
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            title: Text(
              'Profile Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.05,
                  color: const Color.fromRGBO(60, 121, 98, 1.0)),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Name:",
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        proname,
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Student ID:",
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        student_id,
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Mobile:",
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        mobile_number,
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Faculty:",
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        profac,
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Address:",
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        proaddress,
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'CANCEL'),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.035,
                          color: const Color.fromRGBO(60, 121, 98, 1.0)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: Text('OK',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.035,
                            color: const Color.fromRGBO(60, 121, 98, 1.0))),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Widget buildmenus(List<Menu> menus) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    itemCount: menus.length,
    itemBuilder: (context, index) {
      final Menu = menus[index];

      return food_card(food_name: Menu.name, price: Menu.price ?? 0);
    },
  );
}
