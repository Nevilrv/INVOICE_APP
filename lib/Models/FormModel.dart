import 'package:flutter/cupertino.dart';

class FormModel with ChangeNotifier {
  var id;
  String itemName;
  String itemQuality;
  String itemPrice;

  FormModel({
    required this.id,
    required this.itemName,
    required this.itemQuality,
    required this.itemPrice,
  });

  factory FormModel.fromMap(Map<String, dynamic> json) => FormModel(
        id: json["id"],
        itemName: json["itemname"],
        itemPrice: json["price"],
        itemQuality: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "itemname": itemName,
        "price": itemPrice,
        "quantity": itemQuality
      };
}
