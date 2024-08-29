import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoiceapp/Api/ApiManager.dart';
import 'package:invoiceapp/Screen/DashBoardScreen.dart';
import 'package:invoiceapp/Utils/ImageConstant.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  bool isLoading = false;

  String TAG = 'LoginScreen';
  var respons;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorsConst.bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
            ),
            Image.asset(
              ImageConstant.LoginLogo,
              height: 90,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Login to ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '7StockHoldings',
                  style: TextStyle(
                    color: ColorsConst.themeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'No.1 Consulting Company',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Container(
                      height: _screenSize.height * .08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Center(
                              child: Text(
                                'User name',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: _screenSize.width * .55,
                              child: TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: 'eg. abc',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                /*validator: (value) {
                                  if (value!.isEmpty) {
                                    */ /*'Enter User name'*/ /*
                                    ShowError('Enter User name');
                                  }
                                },*/
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                    child: Container(
                      height: _screenSize.height * .08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Center(
                              child: Text(
                                'Password',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: _screenSize.width * .43,
                              child: TextFormField(
                                controller: _passController,
                                obscureText: isVisible,
                                decoration: const InputDecoration(
                                  hintText: '******',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                /*validator: (value) {
                                  if (value!.isEmpty) {
                                    //return 'Enter Password';
                                    ShowError('Enter Password');
                                  } else if (value.length < 6) {
                                    //return 'At least 6 characters';
                                    ShowError('At least 6 characters');
                                  }
                                },*/
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: Colors.grey,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    isVisible = !isVisible;
                                  },
                                );
                              },
                              icon: isVisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                LoginUser();
                              } else {
                                ShowError('Please enter a value');
                              }
                            },
                            child: Container(
                              height: _screenSize.height * .07,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorsConst.themeColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Lorem ipsum is a placeholder text Used',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ShowError(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }

  void LoginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      'email': _emailController.text,
      'password': _passController.text,
    };
    final response = await http.post(
      Uri.parse(ApiManager.BASE_URL + ApiManager.Login),
      body: body,
    );
    print("$TAG Parameters : $body");
    if (response.statusCode == 200) {
      respons = response.body;
      print("$TAG Response: $respons");

      var jsonData = json.decode(respons);
      var success = jsonData['success'];
      var result = jsonData['results'];
      var token = result['token'];
      var data = result['data'];
      int userId = data['id'];
      var cData = data['company'];
      var companyName = cData['companyName'];
      var ownerName = data['name'];
      if (success == 200) {
        setState(
          () {
            isLoading = false;
            prefs.setString('token', token);
            prefs.setInt('userId', userId);
            prefs.setString('company_name', companyName);
            prefs.setString('owner_name', ownerName);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreen(),
              ),
            );
          },
        );
      } else {
        setState(
          () {
            isLoading = false;
            FocusManager.instance.primaryFocus?.unfocus();
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid UserName/Password"),
          ),
        );
        print("$TAG Error: $respons");
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      setState(() {
        isLoading = false;
        FocusManager.instance.primaryFocus?.unfocus();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid UserName/Password"),
        ),
      );
      throw Exception('Failed to Login User');
    }
  }
}
