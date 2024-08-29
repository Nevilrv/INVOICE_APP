import 'package:flutter/material.dart';
import 'package:invoiceapp/Screen/CardScreen.dart';
import 'package:invoiceapp/Screen/CashScreen.dart';
import 'package:invoiceapp/Screen/DashBoardScreen.dart';
import 'package:invoiceapp/Screen/loginSreen.dart';
import 'package:invoiceapp/Utils/ImageConstant.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String TAG = 'SplashScreen';

  @override
  void initState() {
    super.initState();
    CheckLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.themeColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          ImageConstant.splashImage,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void CheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    var companyName = prefs.getString('company_name');
    var ownerName = prefs.getString('owner_name');
    var token = prefs.getString('token');
    print("$TAG UserId : ${userId}");
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (userId == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DashBoardScreen();
              },
            ),
          );
        }
      },
    );
  }
}
