import 'dart:convert';
import 'package:canteen/backgrounds/signup_bg.dart';
import 'package:canteen/config/config.dart';
import 'package:canteen/pages/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController mobiletextcontroller = TextEditingController();
  TextEditingController passwordtextcontroller = TextEditingController();

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedpref();
  }

  void initSharedpref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    void login() async {
      if (mobiletextcontroller.text.isNotEmpty &&
          passwordtextcontroller.text.isNotEmpty) {
        var reqbody = {
          "mobile_number": mobiletextcontroller.text,
          "password": passwordtextcontroller.text
        };

        var response = await http.post(Uri.parse(loginn),
            headers: {"content-Type": "application/json"},
            body: jsonEncode(reqbody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          var myToken = jsonResponse['token'];

          prefs.setString('token', myToken);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => menupage(token: myToken)));
        } else {
          print("Somthing went wrong");
        }
      }
    }

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
                          height: size.height * 0.1,
                        ),
                        Image.asset(
                          "assets/profile.png",
                          width: size.width * 0.4,
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(60, 121, 98, 1.0)),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(119, 187, 162, 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextField(
                            maxLength: 10,
                            controller: mobiletextcontroller,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: const Color.fromRGBO(60, 121, 98, 1.0),
                                fontSize: size.height * 0.02),
                            textAlign: TextAlign.center,
                            cursorColor: const Color.fromRGBO(60, 121, 98, 1.0),
                            decoration: const InputDecoration(
                              counterText: '',
                              hintText: "Mobile Number",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(60, 121, 98, 1.0),
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(119, 187, 162, 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextField(
                            obscureText: true,
                            controller: passwordtextcontroller,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: const Color.fromRGBO(60, 121, 98, 1.0),
                                fontSize: size.height * 0.02),
                            textAlign: TextAlign.center,
                            cursorColor: const Color.fromRGBO(60, 121, 98, 1.0),
                            decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(60, 121, 98, 1.0),
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(60, 121, 98, 1.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.height * 0.13,
                                  vertical: 15)),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              "Doesn't has account? Register Now",
                              style: TextStyle(
                                color: const Color.fromRGBO(60, 121, 98, 1.0),
                                fontSize: size.width * 0.04,
                              ),
                            )),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Image.asset(
                          "assets/plate.png",
                          width: size.width * 0.4,
                        ),
                      ],
                    )))));
  }
}
