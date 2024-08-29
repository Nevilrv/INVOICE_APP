import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invoiceapp/Api/ApiManager.dart';
import 'package:invoiceapp/Models/DashboardModel.dart';
import 'package:invoiceapp/Screen/SelectImagesScreen.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CardInvoiceScreen extends StatefulWidget {
  String token;

  CardInvoiceScreen({Key? key, required this.token}) : super(key: key);

  @override
  _CardInvoiceScreenState createState() => _CardInvoiceScreenState();
}

class _CardInvoiceScreenState extends State<CardInvoiceScreen> {
  var respons, type;
  bool isLoading = true;
  List<Datum> result = [];
  var resultArray;
  String TAG = 'CardInvoiceScreen';
  var payment = 'CD', sortBy = '';
  DateFormat dateFormat = DateFormat("MM.dd");
  var status;
  bool grey = false;
  bool purple = false;
  bool brown = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    GetDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: result.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: GetDataFromServer,
                          child: ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              status = result[index].status;
                              if (status == "P") {
                                grey = true;
                                purple = false;
                                brown = false;
                              } else if (status == "PP") {
                                purple = true;
                                grey = false;
                                brown = false;
                              } else if (status == "R") {
                                brown = true;
                                purple = false;
                                grey = false;
                              } else if (status == "A") {
                                grey = false;
                                purple = false;
                                brown = false;
                              }
                              return Stack(
                                children: [
                                  ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8),
                                      child: SizedBox(
                                        width: 45,
                                        child: Text(
                                          /*"05:20"*/
                                          dateFormat
                                              .format(result[index].issueddate),
                                          style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ), /*TextStyle(color: Colors.black)*/
                                        ),
                                      ),
                                    ),
                                    trailing: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        result[index].total.toString(),
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFFBE6F6F),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        result[index]
                                            .invoicenumber /*"User name" */,
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        "${result[index].receiptCategory.categoryName} l ${result[index].payment == 'CD' ? 'Card' : 'Cash'}",
                                        style: GoogleFonts.inter(),
                                      ),
                                    ),
                                  ),
                                  //grey
                                  Visibility(
                                    visible: grey,
                                    child: Positioned(
                                      top: 7,
                                      child: Container(
                                        width: _screenSize.width,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          color: Color(0xA6000000),
                                          boxShadow: [kDefaultShadow],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Waiting to confirm',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //purple
                                  Visibility(
                                    visible: purple,
                                    child: Positioned(
                                      top: 7,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UploadImage(
                                                invoicId: result[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: _screenSize.width,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            color: Color(0xA67A6FBE),
                                            boxShadow: [kDefaultShadow],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Please upload a photo',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //brown
                                  Visibility(
                                    visible: brown,
                                    child: Positioned(
                                      top: 7,
                                      child: Container(
                                        width: _screenSize.width,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          color: Color(0xa6b2be6f6f),
                                          boxShadow: [kDefaultShadow],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'It has been rejected',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text('No Data Available'),
                        ),
                ),
        ],
      ),
    );
  }

  Future<void> GetDataFromServer() async {
    result.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + widget.token,
    };
    const String url = ApiManager.BASE_URL + ApiManager.getInvoice;
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
      if (success == true) {
        setState(
          () {
            isLoading = false;
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
