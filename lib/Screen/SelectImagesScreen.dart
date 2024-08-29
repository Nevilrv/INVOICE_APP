import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:invoiceapp/Api/ApiManager.dart';
import 'package:invoiceapp/Screen/DashBoardScreen.dart';
import 'package:invoiceapp/Utils/ImageConstant.dart';
import 'package:invoiceapp/Utils/colors.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImage extends StatefulWidget {
  int invoicId;

  UploadImage({Key? key, required this.invoicId}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String TAG = 'Images Screen';
  List<Asset> imagesList = <Asset>[];
  String _error = 'No Error Dectected';

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    print("$TAG InvoiceId: ${widget.invoicId}");
  }

  Widget buildGridView() {
    return GridView.count(
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
                  width: 650,
                  height: 650,
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
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imagesList = resultList;
      _error = error;
    });
  }

  Future uploadImageToServer(BuildContext context, int invoicId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token!,
    };

    try {
      setState(
        () {
          showSpinner = true;
        },
      );

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
        setState(() {
          showSpinner = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreen(),
              ));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image uploaded successfully"),
          ),
        );
        print("$TAG Response Success: Success to upload");
        //print('uploaded');
      } else {
        setState(() {
          showSpinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error uploading image,Try again later"),
          ),
        );
        print("$TAG Response Error: Failed to upload");
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Upload Invoice Image"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text('Choose images to upload Invoice'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                "Pick images",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(ColorsConst.themeColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: ColorsConst.themeColor),
                  ),
                ),
              ),
              onPressed: loadAssets,
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: buildGridView(),
            ),
            Visibility(
              visible: imagesList.isEmpty ? false : true,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    child: Text(
                      "Upload",
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: ColorsConst.themeColor),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      uploadImageToServer(context, widget.invoicId);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
