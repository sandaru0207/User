import 'dart:convert';
import 'package:canteen/config/config.dart';
import 'package:canteen/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:canteen/backgrounds/signup_bg.dart';
import 'package:http/http.dart' as http;

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

//
class _RegisterpageState extends State<Registerpage> {
  TextEditingController mobiletextcontroller = TextEditingController();
  TextEditingController nametextcontroller = TextEditingController();
  TextEditingController passwordtextcontroller = TextEditingController();
  TextEditingController addresstextcontroller = TextEditingController();

  String? selectedOption;
  List<String> options = ["FAS", "BS", "TECH"];

  @override
  Widget build(BuildContext context) {
    void registeruser() async {
      if (mobiletextcontroller.text.isNotEmpty &&
          nametextcontroller.text.isNotEmpty &&
          passwordtextcontroller.text.isNotEmpty &&
          addresstextcontroller.text.isNotEmpty) {
        var regbody = {
          "mobile_number": mobiletextcontroller.text,
          "name": nametextcontroller.text,
          "faculty": selectedOption,
          "address": addresstextcontroller.text,
          "password": passwordtextcontroller.text,
        };

        try {
          var response = await http.post(Uri.parse(register),
              headers: {"content-Type": "application/json"},
              body: jsonEncode(regbody));

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => login()));

          if (response.statusCode == 200) {
            var jsonResponce = jsonDecode(response.body);
            print("Response status: ${jsonResponce['status']}");
          } else {
            print("Server returned an error: ${response.statusCode}");
            print("Response body: ${response.body}");
          }
        } catch (e) {
          print("Requested failed: $e");
        }
      } else {
        print("Fill all field");
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
                "Register",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.1,
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
                height: size.height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(119, 187, 162, 1.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  maxLength: 15,
                  controller: nametextcontroller,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: const Color.fromRGBO(60, 121, 98, 1.0),
                      fontSize: size.height * 0.02),
                  textAlign: TextAlign.center,
                  cursorColor: const Color.fromRGBO(60, 121, 98, 1.0),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: "Name",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(60, 121, 98, 1.0),
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.center,
                width: size.width * 0.8,
                height: size.height * 0.055,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(119, 187, 162, 1.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedOption,
                    hint: Padding(
                      padding: EdgeInsets.only(left: size.width * 0.23),
                      child: const Text(
                        "Select Faculty",
                        style: TextStyle(
                          color: Color.fromRGBO(60, 121, 98, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color.fromRGBO(60, 121, 98, 1.0)),
                    dropdownColor: const Color.fromRGBO(119, 187, 162, 1.0),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Color.fromRGBO(60, 121, 98, 1.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(119, 187, 162, 1.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
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
                height: size.height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(119, 187, 162, 1.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  maxLength: 20,
                  controller: addresstextcontroller,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: const Color.fromRGBO(60, 121, 98, 1.0),
                      fontSize: size.height * 0.02),
                  textAlign: TextAlign.center,
                  cursorColor: const Color.fromRGBO(60, 121, 98, 1.0),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: "Adress",
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
                  registeruser();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(60, 121, 98, 1.0),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * 0.13, vertical: 15)),
                child: Text(
                  "Register",
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
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "Already have account? Login",
                    style: TextStyle(
                      color: const Color.fromRGBO(60, 121, 98, 1.0),
                      fontSize: size.width * 0.04,
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
