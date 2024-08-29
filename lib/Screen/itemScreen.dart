import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoiceapp/Provider/FormProvider.dart';
import 'package:invoiceapp/Screen/CardScreen.dart';
import 'package:invoiceapp/Screen/CashScreen.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsScreen extends StatefulWidget {
  String pageIndex;
  String this_month;

  ItemsScreen(this.pageIndex, {Key? key, required this.this_month})
      : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
    with SingleTickerProviderStateMixin {
  int _activeTabIndex = 0;
  var payment = '';
  String TAG = 'ItemsScreen';
  late SharedPreferences prefs;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
    //_activeTabIndex = widget.pageIndex == 'Cash' ? 0 : 1;
    if (_activeTabIndex == 0) {
      //payment = 'CH';
      setState(
        () {
          context.read<FormProvider>().remove();
        },
      );
    } else if (_activeTabIndex == 1) {
      payment = 'CD';
      setState(
        () {
          context.read<FormProvider>().remove();
        },
      );
    }
    print("$TAG TabBarPayment: $payment");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _activeTabIndex,
      //initialIndex: widget.pageIndex == 'Cash' ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FormProvider>().remove();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 35,
              color: Colors.grey,
            ),
          ),
          backgroundColor: ColorsConst.whiteColor,
          flexibleSpace: Center(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              //physics: const NeverScrollableScrollPhysics(),
              indicatorColor: Colors.transparent,
              labelColor: ColorsConst.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: const Color(0xFF929290),
              unselectedLabelStyle: GoogleFonts.inter(color: Colors.black),
              tabs: [
                Tab(
                  icon: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        "Cash",
                        style: GoogleFonts.inter(fontSize: 21),
                      ),
                    ),
                  ),
                ),
                Tab(
                  icon: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Card",
                      style: GoogleFonts.inter(fontSize: 21),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CashScreen(
              this_month: widget.this_month,
            ),
            CardScreen(
              this_month: widget.this_month,
            ),
          ],
        ),
      ),
    );
  }
}
