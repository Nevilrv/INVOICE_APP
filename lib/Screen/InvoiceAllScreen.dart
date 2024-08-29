import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invoiceapp/Models/DashboardModel.dart';
import 'package:invoiceapp/Screen/SelectImagesScreen.dart';
import 'package:invoiceapp/Utils/colors.dart';

class AllInvoiceScreen extends StatefulWidget {
  List<Datum> result;

  AllInvoiceScreen({Key? key, required this.result}) : super(key: key);

  @override
  _AllInvoiceScreenState createState() => _AllInvoiceScreenState();
}

class _AllInvoiceScreenState extends State<AllInvoiceScreen> {
  String TAG = 'DashBoardScreen';

  bool isLoading = true;
  var status;
  bool grey = false;
  bool purple = false;
  bool brown = false;
  DateFormat dateFormat = DateFormat("MM.dd");

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.result.length,
              itemExtent: 70,
              itemBuilder: (context, index) {
                status = widget.result[index].status;
                print("$TAG Status: $status");
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
                            horizontal: 8.0, vertical: 10),
                        child: SizedBox(
                          width: 45,
                          child: Text(
                            /*"05:20"*/
                            dateFormat.format(widget.result[index].issueddate),
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 15,
                            ), /*TextStyle(color: Colors.black)*/
                          ),
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          /*"-12,000"*/
                          widget.result[index].total.toString(),
                          style: GoogleFonts.inter(
                            color: const Color(0xFFBE6F6F),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          widget.result[index].invoicenumber /*"User name" */,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${widget.result[index].receiptCategory.categoryName} l ${widget.result[index].payment == 'CD' ? 'Card' : 'Cash'}",
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
                                  invoicId: widget.result[index].id,
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
                            color: Color(0xA6B2BE6F6F),
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
          ),
        ],
      ),
    );
  }
}
