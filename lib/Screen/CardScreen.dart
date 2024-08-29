import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:invoiceapp/Api/ApiManager.dart';
import 'package:invoiceapp/Models/CategoriesModel.dart';
import 'package:invoiceapp/Models/FormModel.dart';
import 'package:invoiceapp/Provider/FormProvider.dart';
import 'package:invoiceapp/Utils/ImageConstant.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:invoiceapp/Utils/customDropdown.dart';
import 'package:invoiceapp/Widgets/FormWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

///bipin work here
class CardScreen extends StatefulWidget {
  String this_month;

  CardScreen({Key? key, required this.this_month}) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool isVisible = false;
  bool isVisiblePic = false;
  bool itemVisible = false;
  bool photoVisible = false;
  bool isLoading = true;
  bool isLoadingNext = false;
  bool noteVisible = false;
  var noteData = 'No Data';
  var token;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late final String formatted;
  final qty = TextEditingController();
  var _reason = "Item1";
  var selectedCategory, selectedCategoryId, respons;
  String TAG = 'CashScreen';
  List<Datum> result = [];
  var resultArray;
  List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  //Amount logic
  var amount = 0;
  var newAmount = 0;

  late SharedPreferences prefs;
  List<Asset> imagesList = <Asset>[];

  //add new amount
  void addAmount() {
    var p = int.parse(priceController.text);
    var q = int.parse(qty.text);
    newAmount = p * q;
    amount += newAmount;

    print(amount);
  }

  late FormModel _contactModel;
  var itemCount = 0;
  var itemImageCount = 0;
  late File imageFile;

  late File? _image = null;
  String _image1 = "";
  final picker = ImagePicker();

  Future _getFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image1 = pickedFile.path;
        _image = File(pickedFile.path);
        isVisiblePic = true;
        photoVisible = true;
        itemImageCount++;
        print(json.encode(_image1));
        print("file path...");
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCategoriesList();
    checkState();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy.MM.dd');
    formatted = formatter.format(now);
  }

  void checkState() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<FormWidget> forms = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorsConst.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  /*'$amount 원'*/
                  '${context.watch<FormProvider>().count} 원', //${widget.this_month}
                  style: GoogleFonts.inter(
                    color: ColorsConst.themeColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                  onPressed: () {
                    _modalBottomSheetMenu(context);
                  },
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          selectedCategory,
                          style: const TextStyle(color: Colors.white),
                        ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ColorsConst.themeColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: const BorderSide(
                          color: ColorsConst.themeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: _screenSize.width * .42, //165
                    height: 45,
                    child: MaterialButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(
                          () {
                            itemCount++;
                            isVisible = true;
                            itemVisible = true;
                            //onAdd();
                            onAddForm();
                          },
                        );
                      },
                      child: Text(
                        'Add Item',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: _screenSize.width * .42, //165
                    height: 45,
                    child: MaterialButton(
                      color: Colors.white,
                      onPressed: () {
                        //_getFromGallery();
                        loadAssets();
                      },
                      child: Text(
                        'Photo',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: itemVisible,
              maintainState: true,
              maintainAnimation: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    border: Border.all(
                      color: ColorsConst.themeColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                        ),
                        child: Text(
                          'Item ($itemCount)',
                          style: GoogleFonts.inter(
                            color: ColorsConst.themeColor,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              itemCount == 0
                                  ? isVisible = false
                                  : isVisible = !isVisible;
                            });
                          },
                          child: isVisible
                              ? const Text(
                                  '▼',
                                  style:
                                      TextStyle(color: ColorsConst.themeColor),
                                )
                              : const Text(
                                  '▲',
                                  style:
                                      TextStyle(color: ColorsConst.themeColor),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              maintainState: true,
              maintainAnimation: true,
              child: SizedBox(
                height: _screenSize.height * .35, //.43
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: forms.length,
                  itemBuilder: (_, index) {
                    return forms[index];
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: photoVisible,
              maintainState: true,
              maintainAnimation: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    border: Border.all(color: ColorsConst.themeColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Photo ($itemImageCount)',
                          style: GoogleFonts.inter(
                            color: ColorsConst.themeColor,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: () {
                            setState(
                              () {
                                itemImageCount == 0
                                    ? isVisiblePic = false
                                    : isVisiblePic = !isVisiblePic;
                              },
                            );
                          },
                          child: isVisiblePic
                              ? const Text(
                                  '▼',
                                  style:
                                      TextStyle(color: ColorsConst.themeColor),
                                )
                              : const Text(
                                  '▲',
                                  style:
                                      TextStyle(color: ColorsConst.themeColor),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisiblePic,
              maintainState: true,
              maintainAnimation: true,
              child: SizedBox(
                height: _screenSize.height * .32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: SizedBox(
                        height: _screenSize.height * .28,
                        width: double.infinity,
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                            imagesList.length,
                            (index) {
                              Asset asset = imagesList[index];
                              return Stack(
                                children: [
                                  //Image.network(used_car.imageUrl,fit: BoxFit.fill),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AssetThumb(
                                      asset: asset,
                                      width: 600,
                                      height: 600,
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    right: 20,
                                    child: InkWell(
                                      onTap: () {
                                        setState(
                                          () {},
                                        );
                                      },
                                      child: Image.asset(
                                        ImageConstant.delete,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Issued On",
                  style: GoogleFonts.inter(
                    color: ColorsConst.textColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20, right: 20),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2025),
                      ).then(
                        (selectedDate) {
                          if (selectedDate != null) {
                            dateController.text =
                                DateFormat('yyyy.MM.dd').format(selectedDate);
                          }
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date.';
                      }
                      return null;
                    },
                    controller: dateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.inter(
                        color: Colors.black,
                      ),
                      hintText: formatted,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: noteVisible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Note",
                        style: GoogleFonts.inter(
                          color: ColorsConst.textColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, right: 20),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: Text(
                          noteData,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: ColorsConst.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  MaterialButton(
                    minWidth: _screenSize.width * .6,
                    height: 40,
                    onPressed: () {
                      ShowNoteDialog();
                      //showBottomsheet();
                    },
                    child: const Text(
                      'Note',
                      style: TextStyle(color: Colors.black),
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      width: _screenSize.width * 0.2,
                      child: isLoadingNext
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                //ShowDialog();  //imagesList,
                                setState(() {
                                  print("pressed");
                                  isLoadingNext = true;
                                  //approve(Forms)
                                  FormWidget().createState().approve(
                                        context,
                                        dateController.text,
                                        "CD",
                                        //payment
                                        "",
                                        //bankname
                                        "",
                                        //bankinfo
                                        "",
                                        //status
                                        selectedCategory,
                                        noteController.text,
                                        token,
                                        forms,
                                        imagesList,
                                      );
                                });
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(fontSize: 17),
                              ),
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorsConst.themeColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: ColorsConst.themeColor),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void ShowDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/image/send.png',
                height: 120,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Send Invoice successful.',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ColorsConst.themeColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: ColorsConst.themeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void ShowNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                maxLines: 5,
                controller: noteController,
                decoration: const InputDecoration(
                  label: Text('Note'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        Navigator.pop(context);
                        noteVisible = true;
                        noteData = noteController.text;
                      },
                    );
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ColorsConst.themeColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: ColorsConst.themeColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: imagesList,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Choose Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      itemImageCount++;
      isVisiblePic = true;
      photoVisible = true;
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imagesList = resultList;
      //_error = error;
    });
  }

  Future<void> GetCategoriesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token!,
    };
    final response = await http.get(
      Uri.parse(ApiManager.BASE_URL + ApiManager.getCategories),
      headers: headers,
    );
    //print("$TAG Parameters : $body");
    if (response.statusCode == 200) {
      respons = response.body;
      print("$TAG Response: $respons");
      isLoading = false;
      var mapResponse = jsonDecode(respons);
      resultArray = mapResponse['data'];

      setState(
        () {
          isLoading = false;
          resultArray.forEach((v) {
            result.add(Datum.fromJson(v));
          });
          selectedCategory = result[0].categoryName;
          selectedCategoryId = result[0].id;
        },
      );
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to Get Data');
    }
  }

  //Delete specific form
  onRemove(String uuid) {
    setState(() {
      forms.removeWhere((element) {
        if (element.uuid == uuid) {
          itemCount--;
          return true;
        }
        return false;
      });
    });
  }

  onAdd() {
    setState(() {
      _contactModel = FormModel(
          id: forms.length, itemPrice: '', itemName: '', itemQuality: '');
      FormWidget formtWidget = FormWidget(
        index: forms.length,
        onRemoved: (String uuid) => onRemove(uuid),
      );
      forms.add(formtWidget);
      context.read<FormProvider>().addFormWidget(formtWidget);
    });
  }

  /*///on form user deleted
  void onDelete(FormModel _user) {
    setState(() {
      var find = Forms.firstWhere(
            (it) => it.contactModel == _user,
        orElse: () => null,
      );
      if (find != null) Forms.removeAt(Forms.indexOf(find));
    });
  }
*/

  ///on add form
  void onAddForm() {
    setState(() {
      forms.add(FormWidget(
        onRemoved: (String uuid) => onRemove(uuid),
      ));
    });
  }

  Widget createListView(BuildContext context, List<Datum> values) {
    return SizedBox(
      height: 170.0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              CupertinoActionSheetAction(
                child: Text(values[index].categoryName),
                onPressed: () => {
                  setState(() {
                    selectedCategory = values[index].categoryName;
                  }),
                  Navigator.pop(context)
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) async {
    //List<String> values = await plates;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Choose Categories',
        ),
        actions: <Widget>[createListView(context, result)],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }
}
