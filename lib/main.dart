import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoiceapp/Provider/FormProvider.dart';
import 'package:invoiceapp/Screen/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        //systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white.withOpacity(0.1), // status bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        //systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'invoiceapp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
