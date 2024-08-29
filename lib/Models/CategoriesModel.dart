// To parse this JSON data, do
//
//     final categoriesDataModel = categoriesDataModelFromJson(jsonString);

import 'dart:convert';

CategoriesDataModel categoriesDataModelFromJson(String str) => CategoriesDataModel.fromJson(json.decode(str));

String categoriesDataModelToJson(CategoriesDataModel data) => json.encode(data.toJson());

class CategoriesDataModel {
  CategoriesDataModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory CategoriesDataModel.fromJson(Map<String, dynamic> json) => CategoriesDataModel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String categoryName;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryName: json["categoryName"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
