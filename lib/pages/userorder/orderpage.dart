import 'dart:convert';
import 'package:canteen/backgrounds/signup_bg.dart';
import 'package:canteen/config/config.dart';
import 'package:canteen/pages/userorder/ordercard.dart';
import 'package:canteen/pages/userorder/orderclass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class orderpage extends StatefulWidget {
  final String mobilenumber;
  const orderpage({super.key, required this.mobilenumber});

  @override
  State<orderpage> createState() => _orderpageState();
}

class _orderpageState extends State<orderpage> {
  late Future<List<Order>> orders;

  static Future<List<Order>> getorderlist(mobilenumber) async {
    var regbody = {
      "mobile_number": mobilenumber,
    };
    var response = await http.post(Uri.parse(getuserorders),
        headers: {"content-Type": "application/json"},
        body: jsonEncode(regbody));

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse.map<Order>(Order.fromJson).toList();
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();

    orders = getorderlist(widget.mobilenumber);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Background(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    height: size.height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(left: size.width * 0.045),
                                child: Image(
                                  image: AssetImage("assets/back.png"),
                                  width: size.width * 0.12,
                                ),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    splashColor: Colors.black12,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Expanded(
                            child: FutureBuilder<List<Order>>(
                                future: orders,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator
                                        .adaptive();
                                  } else if (snapshot.hasData) {
                                    final orders = snapshot.data!;

                                    return buildorders(orders);
                                  } else {
                                    return const Text("No Menu data");
                                  }
                                })),
                      ],
                    )))));
  }
}

Widget buildorders(List<Order> orders) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    itemCount: orders.length,
    itemBuilder: (context, index) {
      final Order = orders[index];

      return order_card(
          total: Order.total,
          veg_count: Order.veg_count,
          veg_price: Order.veg_price,
          egg_count: Order.egg_count,
          egg_price: Order.egg_price,
          chicken_count: Order.chicken_count,
          chicken_price: Order.chicken_price,
          rice_count: Order.rice_count,
          rice_price: Order.rice_price,
          kottu_count: Order.kottu_count,
          kottu_price: Order.kottu_price,
          fish_count: Order.fish_count,
          fish_price: Order.fish_price,
          orderid: Order.orderid);
    },
  );
}
