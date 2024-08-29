import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:invoiceapp/Provider/FormProvider.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:invoiceapp/Api/ApiManager.dart';
import 'package:invoiceapp/Models/FormModel.dart';
import 'package:invoiceapp/Screen/DashBoardScreen.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:multi_image_picker2/src/asset.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

typedef onRemoved();

class FormWidget extends StatefulWidget {
  //var onRemoved;

  FormWidget({
    Key? key,
    this.index,
    this.onRemoved,
  }) : super(key: key);
  final index;
  final Function? onRemoved;

  //final onRemoved onRemove;
  _FormWidgetState? formWidgetStat;
  String uuid = "";

  @override
  _FormWidgetState createState() {
    uuid = Uuid().v1();
    formWidgetStat = _FormWidgetState();
    return formWidgetStat!;
  }

  FormModel getFormModel(int index) {
    return formWidgetStat!.getFormModel(index);
  }
}

class _FormWidgetState extends State<FormWidget> {
  final formKey = GlobalKey<FormState>();
  String TAG = 'FormWidget';
  var apiResponse; //imagesList,
  TextEditingController nameController = TextEditingController();
  TextEditingController qualityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<FormModel> formModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("$TAG FormIndex : ${widget.index}");

  }

  FormModel getFormModel(var index) {
    debugPrint("Debug - getFormModel - $index");
    debugPrint("Debug - getFormModel - ${widget.uuid}");
    FormModel formModel = FormModel(
      id: index,
      itemName: nameController.text,
      itemQuality: qualityController.text,
      itemPrice: priceController.text,
    );
    debugPrint("Debug - getFormModel - id: ${formModel.id}, name: "
        "${formModel.itemName}, quality: ${formModel.itemQuality}, price: "
        "${formModel.itemPrice}");
    return formModel;
  }

  List<FormModel> getAllFormModels(List<FormWidget> forms) {
    for (int i = 0; i < forms.length; i++) {
      formModels.add(forms[i].getFormModel(i));
    }
    return formModels;
  }

  Future<void> approve(
      BuildContext context,
      String issuesdate,
      String payment,
      String bankName,
      String bankInfo,
      String status,
      selectedCategory,
      String note,
      token,
      List<FormWidget> forms,
      List<Asset> imagesList) async {
    print("Button approved");
    //print(imagesList);
    print(issuesdate);
    // print(payment);
    print(bankName);
    print(bankInfo);
    print(status);
    print(selectedCategory);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    debugPrint("Debug - token - ${token}");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data', //'multipart/form-data',
      'Authorization': 'Bearer ' + token!, //Bearer jaljdljalhdlha
    };

    final body = HashMap.of(
      {
        'payment': payment,
        'bankname': bankName,
        'bankinformation': bankInfo,
        'istatus': "A",
        'icategory': selectedCategory.toString(),
        'issueddate': issuesdate.toString(),

        'item':
            jsonEncode(getAllFormModels(forms).map((e) => e.toMap()).toList()),
        // 'item': "[]",
        // "[{'id':'1','itemname':'${nameController.text}','quantity':'${qualityController.text}','price':'${priceController.text}'}]",
        'inote': note,
      },
    );

    final request = await http.MultipartRequest(
      "POST",
      Uri.parse("http://ssdd.tech/public/api/v1/invoiceCreate"),
    )
      ..headers.addAll(headers)
      ..fields.addAll(body);
    var res = await request.send();
    var resBody = await http.Response.fromStream(res);

    debugPrint("Debug - status code - ${resBody.body}");
    debugPrint("Debug - status code - ${res.statusCode}");

    apiResponse = resBody.body;
    print("$TAG Parameters : ${request.fields}");
    if (res.statusCode == 200 || res.statusCode == 201) {
      // respons = res.body;
      print("$TAG Response: $apiResponse");

      var jsonData = json.decode(apiResponse);
      var success = jsonData['success'];
      var id = jsonData['data'];
      //print("$TAG Message : ${message}");

      if (success == true) {
        if (imagesList.isNotEmpty) {
          uploadImageToServer(context, id, imagesList);
        } else {
          ShowDialog(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fail To Create Receipt"),
          ),
        );
        print("$TAG Error: $apiResponse");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fail To Create Receipt"),
        ),
      );
      throw Exception('Failed to Create Receipt');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Material(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Container(
            height: _screenSize.height * .26,
            decoration: BoxDecoration(
              color: ColorsConst.whiteColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Item',
                          style: GoogleFonts.inter(
                            color: ColorsConst.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          'Qty',
                          style: GoogleFonts.inter(
                            color: ColorsConst.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        height: 45,
                        width: _screenSize.width * .66,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Center(
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Item Name',
                                hintStyle: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Item Name';
                                }
                              },
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 45,
                        width: _screenSize.width * .12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Center(
                            child: TextFormField(
                              controller: qualityController,
                              decoration: const InputDecoration(
                                hintText: '1',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              onFieldSubmitted: (_) =>
                                  context.read<FormProvider>().multiply(
                                        priceController.text,
                                        qualityController.text,
                                        widget.index,
                                      ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Price';
                                }
                              },
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Price",
                    style: GoogleFonts.inter(
                      color: ColorsConst.textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        height: 45,
                        width: _screenSize.width * .68,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Center(
                            child: TextFormField(
                              controller: priceController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  context.read<FormProvider>().multiply(
                                        priceController.text,
                                        qualityController.text,
                                        widget.index,
                                      ),
                              decoration: InputDecoration(
                                hintText: '1,000,000',
                                hintStyle: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Price';
                                }
                              },
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 45,
                        width: _screenSize.width * .1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    /*itemCount--;
                                    itemCount == 0
                                        ? isVisible = false
                                        : isVisible = true;*/
                                    widget.onRemoved!(widget.uuid);
                                    //context.read<FormProvider>().remove();
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: ColorsConst.themeColor,
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
        ),
      ),
    );
  }

  void ShowDialog(BuildContext context) {
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
                    //pref.remove('KeyNameHere');
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashBoardScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorsConst.themeColor),
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

  Future<void> uploadImageToServer(
      BuildContext context, int invoicId, imagesList) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token!,
    };

    try {
      var uri = Uri.parse(ApiManager.BASE_URL + 'invoiceUpdatePhoto/$invoicId');
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      //request.fields['userid'] = '1';
      request.headers.addAll(headers);

      List<http.MultipartFile> newList = <http.MultipartFile>[];

      for (int i = 0; i < imagesList.length; i++) {
        var path =
            await FlutterAbsolutePath.getAbsolutePath(imagesList[i].identifier);
        File imageFile = File(path);

        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var multipartFile = http.MultipartFile("images[]", stream, length,
            filename: basename(imageFile.path));
        newList.add(multipartFile);
      }

      request.files.addAll(newList);
      var response = await request.send();
      //print(response.toString());
      print("$TAG Response: $response");

      response.stream.transform(utf8.decoder).listen((value) {
        //print('value');
        //print(value);
        print("$TAG Response Value: $value");
      });

      if (response.statusCode == 201) {
        ShowDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image uploaded successfully"),
          ),
        );
        print("$TAG Response Success: Success to upload");
        //print('uploaded');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error uploading image,Try again later"),
          ),
        );
        print("$TAG Response Error: Failed to upload");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
