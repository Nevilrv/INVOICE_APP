// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) =>
    DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  DashBoardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
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
    required this.employeeId,
    required this.category,
    required this.invoicenumber,
    required this.companyId,
    required this.status,
    required this.payment,
    required this.issueddate,
    required this.bankname,
    required this.bankinformation,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.total,
    required this.employee,
    required this.receiptCategory,
    required this.company,
  });

  int id;
  int employeeId;
  String category;
  String invoicenumber;
  int companyId;
  String status;
  String payment;
  DateTime issueddate;
  String bankname;
  String bankinformation;
  String note;
  var total;
  DateTime createdAt;
  DateTime updatedAt;
  Employee employee;
  ReceiptCategory receiptCategory;
  Company company;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        employeeId: json["employeeId"],
        category: json["category"],
        invoicenumber: json["invoicenumber"],
        companyId: json["companyId"],
        status: json["status"],
        payment: json["payment"],
        issueddate: DateTime.parse(json["issueddate"]),
        bankname: json["bankname"] == null ? '' : json["bankname"],
        bankinformation:
            json["bankinformation"] == null ? '' : json["bankinformation"],
        note: json["note"] == null ? '' : json["note"],
        total: json["total"] == null ? '' : json["total"],
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
        employee: Employee.fromJson(json["employee"] ?? ''),
        receiptCategory: ReceiptCategory.fromMap(json["receipt_category"]),
//ReceiptCategory.fromJson(json.decode(json['receipt_category'])),

        company: Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "category": category,
        "invoicenumber": invoicenumber,
        "companyId": companyId,
        "status": status,
        "payment": payment,
        "issueddate":
            "${issueddate.year.toString().padLeft(4, '0')}-${issueddate.month.toString().padLeft(2, '0')}-${issueddate.day.toString().padLeft(2, '0')}",
        "bankname": bankname == null ? null : bankname,
        "bankinformation": bankinformation == null ? null : bankinformation,
        "note": note == null ? null : note,
        "total": total == null ? null : total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "employee": employee.toJson(),
        "receipt_category":
            receiptCategory == null ? null : receiptCategory.toMap(),
        "company": company.toJson(),
      };
}

class Company {
  Company({
    required this.id,
    required this.companyName,
    required this.ownerName,
    required this.consultdate,
    required this.reviewdate,
    this.enddate,
    this.companylogo,
    required this.createdBy,
    required this.isApproved,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String companyName;
  String ownerName;
  DateTime consultdate;
  DateTime reviewdate;
  dynamic enddate;
  dynamic companylogo;
  String createdBy;
  String isApproved;
  String isActive;
  String isDelete;
  DateTime createdAt;
  DateTime updatedAt;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        companyName: json["companyName"],
        ownerName: json["ownerName"],
        consultdate: DateTime.parse(json["consultdate"]),
        reviewdate: DateTime.parse(json["reviewdate"]),
        enddate: json["enddate"],
        companylogo: json["companylogo"],
        createdBy: json["createdBy"],
        isApproved: json["isApproved"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
        "ownerName": ownerName,
        "consultdate":
            "${consultdate.year.toString().padLeft(4, '0')}-${consultdate.month.toString().padLeft(2, '0')}-${consultdate.day.toString().padLeft(2, '0')}",
        "reviewdate":
            "${reviewdate.year.toString().padLeft(4, '0')}-${reviewdate.month.toString().padLeft(2, '0')}-${reviewdate.day.toString().padLeft(2, '0')}",
        "enddate": enddate,
        "companylogo": companylogo,
        "createdBy": createdBy,
        "isApproved": isApproved,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.email,
    this.passencrypt,
    required this.position,
    required this.companyId,
    this.emailVerifiedAt,
    this.level,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.apiToken,
    required this.isActive,
    required this.isDelete,
  });

  int id;
  String name;
  String email;
  dynamic passencrypt;
  String position;
  int companyId;
  dynamic emailVerifiedAt;
  dynamic level;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic apiToken;
  String isActive;
  String isDelete;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        passencrypt: json["passencrypt"],
        position: json["position"],
        companyId: json["company_id"],
        emailVerifiedAt: json["email_verified_at"],
        level: json["level"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        apiToken: json["api_token"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "passencrypt": passencrypt,
        "position": position,
        "company_id": companyId,
        "email_verified_at": emailVerifiedAt,
        "level": level,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "api_token": apiToken,
        "isActive": isActive,
        "isDelete": isDelete,
      };
}

class ReceiptCategory {
  ReceiptCategory({
    required this.id,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String categoryName;
  DateTime createdAt;
  DateTime updatedAt;

  factory ReceiptCategory.fromMap(Map<String, dynamic> map) => ReceiptCategory(
        //runnerId: map["runnerId"],
        id: map["id"],
        categoryName: map["categoryName"],
        createdAt: DateTime.parse(map["created_at"]),
        updatedAt: DateTime.parse(map["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        //"runnerId": runnerId,
        "id": id,
        "categoryName": categoryName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
/*

// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) =>
    DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  DashBoardModel({
    required this.success,
    required this.message,
    required this.thisMonth,
    required this.data,
  });

  bool success;
  String message;
  String thisMonth;
  List<Datum> data;

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
        success: json["success"],
        message: json["message"],
        thisMonth: json["this_month"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "this_month": thisMonth,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.employeeId,
    required this.category,
    required this.invoicenumber,
    required this.companyId,
    required this.status,
    required this.payment,
    required this.issueddate,
    required this.bankname,
    required this.bankinformation,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    this.total,
    required this.receiptitem,
    required this.employee,
    required this.receiptCategory,
    required this.company,
  });

  int id;
  int employeeId;
  String category;
  String invoicenumber;
  int companyId;
  Status status;
  Payment payment;
  DateTime issueddate;
  Bankname bankname;
  String bankinformation;
  String note;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic total;
  List<Receiptitem> receiptitem;
  Employee employee;
  ReceiptCategory receiptCategory;
  Company company;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        employeeId: json["employeeId"],
        category: json["category"],
        invoicenumber: json["invoicenumber"],
        companyId: json["companyId"],
        status: statusValues.map[json["status"]],
        payment: paymentValues.map[json["payment"]],
        issueddate: DateTime.parse(json["issueddate"]),
        bankname: json["bankname"] == null
            ? null
            : banknameValues.map[json["bankname"]],
        bankinformation:
            json["bankinformation"] == null ? null : json["bankinformation"],
        note: json["note"] == null ? null : json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        total: json["total"],
        receiptitem: List<Receiptitem>.from(
            json["receiptitem"].map((x) => Receiptitem.fromJson(x))),
        employee: Employee.fromJson(json["employee"]),
        receiptCategory: ReceiptCategory.fromJson(json["receipt_category"]),
        company: Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "category": category,
        "invoicenumber": invoicenumber,
        "companyId": companyId,
        "status": statusValues.reverse[status],
        "payment": paymentValues.reverse[payment],
        "issueddate":
            "${issueddate.year.toString().padLeft(4, '0')}-${issueddate.month.toString().padLeft(2, '0')}-${issueddate.day.toString().padLeft(2, '0')}",
        "bankname": bankname == null ? null : banknameValues.reverse[bankname],
        "bankinformation": bankinformation == null ? null : bankinformation,
        "note": note == null ? null : note,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "total": total,
        "receiptitem": List<dynamic>.from(receiptitem.map((x) => x.toJson())),
        "employee": employee.toJson(),
        "receipt_category": receiptCategory.toJson(),
        "company": company.toJson(),
      };
}

enum Bankname { SBI, DEMO, BANK_NAME }

final banknameValues = EnumValues({
  "bankName": Bankname.BANK_NAME,
  "demo": Bankname.DEMO,
  "SBI": Bankname.SBI
});

class Company {
  Company({
    required this.id,
    required this.companyName,
    required this.ownerName,
    required this.consultdate,
    required this.reviewdate,
    required this.enddate,
    this.companylogo,
    required this.createdBy,
    required this.isApproved,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  CompanyName companyName;
  OwnerName ownerName;
  DateTime consultdate;
  DateTime reviewdate;
  DateTime enddate;
  dynamic companylogo;
  String createdBy;
  Is isApproved;
  Is isActive;
  IsDelete isDelete;
  DateTime createdAt;
  DateTime updatedAt;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        companyName: companyNameValues.map[json["companyName"]],
        ownerName: ownerNameValues.map[json["ownerName"]],
        consultdate: DateTime.parse(json["consultdate"]),
        reviewdate: DateTime.parse(json["reviewdate"]),
        enddate:
            json["enddate"] == null ? null : DateTime.parse(json["enddate"]),
        companylogo: json["companylogo"],
        createdBy: json["createdBy"],
        isApproved: isValues.map[json["isApproved"]],
        isActive: isValues.map[json["isActive"]],
        isDelete: isDeleteValues.map[json["isDelete"]],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyNameValues.reverse[companyName],
        "ownerName": ownerNameValues.reverse[ownerName],
        "consultdate":
            "${consultdate.year.toString().padLeft(4, '0')}-${consultdate.month.toString().padLeft(2, '0')}-${consultdate.day.toString().padLeft(2, '0')}",
        "reviewdate":
            "${reviewdate.year.toString().padLeft(4, '0')}-${reviewdate.month.toString().padLeft(2, '0')}-${reviewdate.day.toString().padLeft(2, '0')}",
        "enddate": enddate == null
            ? null
            : "${enddate.year.toString().padLeft(4, '0')}-${enddate.month.toString().padLeft(2, '0')}-${enddate.day.toString().padLeft(2, '0')}",
        "companylogo": companylogo,
        "createdBy": createdBy,
        "isApproved": isValues.reverse[isApproved],
        "isActive": isValues.reverse[isActive],
        "isDelete": isDeleteValues.reverse[isDelete],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum CompanyName { EMPTY, COMPANY_NAME }

final companyNameValues =
    EnumValues({"코드에셋": CompanyName.COMPANY_NAME, "조윈": CompanyName.EMPTY});

enum Is { Y }

final isValues = EnumValues({"Y": Is.Y});

enum IsDelete { N }

final isDeleteValues = EnumValues({"N": IsDelete.N});

enum OwnerName { WTETTTTT, HARRY }

final ownerNameValues =
    EnumValues({"Harry": OwnerName.HARRY, "WTETTTTT": OwnerName.WTETTTTT});

class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.email,
    this.passencrypt,
    required this.position,
    required this.companyId,
    this.emailVerifiedAt,
    this.level,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.apiToken,
    required this.isActive,
    required this.isDelete,
  });

  int id;
  Name name;
  Email email;
  dynamic passencrypt;
  String position;
  int companyId;
  dynamic emailVerifiedAt;
  dynamic level;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic apiToken;
  Is isActive;
  Is isDelete;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: nameValues.map[json["name"]],
        email: emailValues.map[json["email"]],
        passencrypt: json["passencrypt"],
        position: json["position"],
        companyId: json["company_id"],
        emailVerifiedAt: json["email_verified_at"],
        level: json["level"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        apiToken: json["api_token"],
        isActive: isValues.map[json["isActive"]],
        isDelete: isValues.map[json["isDelete"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "email": emailValues.reverse[email],
        "passencrypt": passencrypt,
        "position": position,
        "company_id": companyId,
        "email_verified_at": emailVerifiedAt,
        "level": level,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "api_token": apiToken,
        "isActive": isValues.reverse[isActive],
        "isDelete": isValues.reverse[isDelete],
      };
}

enum Email { EMPLOYEE }

final emailValues = EnumValues({"employee": Email.EMPLOYEE});

enum Name { EMPLOYEE_1 }

final nameValues = EnumValues({"Employee 1": Name.EMPLOYEE_1});

enum Payment { CD, CH, EMPTY }

final paymentValues =
    EnumValues({"CD": Payment.CD, "CH": Payment.CH, "": Payment.EMPTY});

class ReceiptCategory {
  ReceiptCategory({
    required this.id,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  CategoryName categoryName;
  DateTime createdAt;
  DateTime updatedAt;

  factory ReceiptCategory.fromJson(Map<String, dynamic> json) =>
      ReceiptCategory(
        id: json["id"],
        categoryName: categoryNameValues.map[json["categoryName"] ?? ''],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryNameValues.reverse[categoryName],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum CategoryName { FOOD, PLASTICS, GROSSARY }

final categoryNameValues = EnumValues({
  "Food": CategoryName.FOOD,
  "Grossary": CategoryName.GROSSARY,
  "Plastics": CategoryName.PLASTICS
});

class Receiptitem {
  Receiptitem({
    required this.id,
    required this.receiptId,
    required this.item,
    required this.quantity,
    required this.price,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int receiptId;
  String item;
  int quantity;
  int price;
  int total;
  DateTime createdAt;
  DateTime updatedAt;

  factory Receiptitem.fromJson(Map<String, dynamic> json) => Receiptitem(
        id: json["id"],
        receiptId: json["receiptId"],
        item: json["item"],
        quantity: json["quantity"],
        price: json["price"],
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiptId": receiptId,
        "item": item,
        "quantity": quantity,
        "price": price,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum Status { R, PP, P, A }

final statusValues =
    EnumValues({"A": Status.A, "P": Status.P, "PP": Status.PP, "R": Status.R});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
*/
