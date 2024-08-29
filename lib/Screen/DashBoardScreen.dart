import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoiceapp/Api/ApiManager.dart';
import 'package:invoiceapp/Models/DashboardModel.dart';
import 'package:invoiceapp/Screen/CardInvoiceScreen.dart';
import 'package:invoiceapp/Screen/CashInvoiceScreen.dart';
import 'package:invoiceapp/Screen/InvoiceAllScreen.dart';
import 'package:invoiceapp/Screen/itemScreen.dart';
import 'package:invoiceapp/Screen/loginSreen.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashBoardScreen extends StatefulWidget {
  //String companyName, owenerName, token;

  DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  String TAG = 'DashBoardScreen';
  var respons, type;
  bool isLoading = true;
  List<Datum> result = [];
  var resultArray, recipient;
  late TabController _tabController;
  var payment = '', sortBy = '';
  int _activeTabIndex = 0;
  var _reason = "1";
  var this_month = "0";
  var companyName = 'No Data', owenerName = 'No Data', token;
  late SharedPreferences prefs;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    CheckPreferences();

    //GetDataFromServer();
    super.initState();
  }

  void CheckPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
    if (_activeTabIndex == 1) {
      payment = 'CH';
      setState(() {
        GetDataFromServer();
      });
    } else if (_activeTabIndex == 2) {
      payment = 'CD';
      setState(() {
        GetDataFromServer();
      });
    } else {
      payment = '';
      setState(() {
        GetDataFromServer();
      });
    }
    print("$TAG TabBarPayment: $payment");
  }

  void getSharedInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyName = prefs.getString('company_name')!;
    owenerName = prefs.getString('owner_name')!;
    token = prefs.getString('token');
    GetDataFromServer();
    print(companyName);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getSharedInstance();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      owenerName /*"Song harry"*/,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "[$companyName]",
                      style: GoogleFonts.inter(),
                    ),
                  ],
                ),
              ),
              /*Company name*/
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: MaterialButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      color: Colors.indigo,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.indigo,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            "This month",
            style: GoogleFonts.inter(
              color: const Color(0xFF92929D),
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "$this_month 원",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: double.infinity, // <-- Your width
                      height: 45, // <-- Your height
                      child: ElevatedButton(
                        child: Text(
                          "Cash",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConst.themeColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                color: ColorsConst.themeColor,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          //prefs.setString('payment', 'CH');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemsScreen(
                                "Cash",
                                this_month: this_month,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: SizedBox(
                      width: double.infinity, // <-- Your width
                      height: 45, // <-- Your height
                      child: ElevatedButton(
                        child: Text(
                          "Card",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConst.themeColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: ColorsConst.themeColor),
                            ),
                          ),
                        ),
                        onPressed: () {
                          //prefs.setString('payment', "CD");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemsScreen(
                                "Card",
                                this_month: this_month,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.transparent,
                  isScrollable: true,
                  onTap: (value) {
                    var tapvalue = value;
                  },
                  controller: _tabController,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                  tabs: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        child: Text(
                          'All',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        child: Text(
                          'Cash',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        child: Text(
                          'Card',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  underline: const SizedBox(),
                  value: _reason,
                  items: [
                    DropdownMenuItem(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Newest",
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      value: "1",
                    ),
                    /*DropdownMenuItem(
                      child: Text(
                        "Sort By",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: "2",
                    ),*/
                    DropdownMenuItem(
                      child: Text(
                        "Oldest",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                      value: "3",
                    ),
                  ],
                  onChanged: (value) {
                    _reason = value!;
                    setState(
                      () {
                        if (_reason == "1") {
                          sortBy = 'desc';
                        } else if (_reason == "3") {
                          sortBy = 'asc';
                        } else {
                          sortBy = '';
                        }
                        //result.clear();
                        GetDataFromServer();
                        print("Reason:-" + sortBy);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: GetDataFromServer,
                        child: AllInvoiceScreen(
                          result: result,
                        ),
                      ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CashInvoiceScreen(
                        token: token,
                      ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CardInvoiceScreen(
                        token: token,
                      ),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> GetDataFromServer() async {
    result.clear();
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    };
    var url = ApiManager.BASE_URL + ApiManager.getInvoice;
    final uri = Uri.parse(url).replace(queryParameters: {
      'payment': payment,
      'sort_by': sortBy,
    });
    final response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      respons = response.body;
      print("$TAG Response: $respons");

      var jsonData = json.decode(respons);
      var success = jsonData['success'];
      var message = jsonData['message'];

      resultArray = jsonData['data'];
      print("$TAG Message: $message");
      if (success == true) {
        setState(
          () {
            isLoading = false;
            this_month = jsonData['this_month'];
            resultArray.forEach((v) {
              result.add(Datum.fromJson(v));
            });
            print("$TAG Lenght: ${result.length}");
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
          SnackBar(
            content: Text(message),
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
          content: Text("Failed to Get Data"),
        ),
      );
      throw Exception('Failed to Get Data');
    }
  }
}
