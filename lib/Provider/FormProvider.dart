import 'package:flutter/cupertino.dart';
import 'package:invoiceapp/Models/FormModel.dart';

import '../Widgets/FormWidget.dart';

class FormProvider with ChangeNotifier {
  int _count = 0;
  var multiplyvalue, tempvalue;
  var indexvalue;

  List<FormWidget> fromWidgets = [];
  List<FormModel> formModels = [];
  var pricevalue, quantityvalue;

  //TODO: Call from cash and card screen when you add new FormWidget
  void addFormWidget(FormWidget formWidget) {
    //fromWidgets.add(formWidget);
    /*for (int i = 0; i < fromWidgets.length; i++) {
      formModels.add(fromWidgets[i].getFormModel(i));
    }
    for (int i = 0; i < formModels.length; i++) {
      pricevalue = formModels[i].itemPrice;
      quantityvalue = formModels[i].itemQuality;
    }*/
  }

  int get count => _count;


  void multiply(String price, String quantity, index) {
    //indexvalue = index;

    multiplyvalue = pricevalue * quantityvalue;
    _count=multiplyvalue;
     //multiplyvalue = int.parse(price) * int.parse(quantity);
    //multiplyvalue = _count = multiplyvalue;
    notifyListeners();
  }

  void multiplyFormModel(List<FormModel> formModels) {}

  void remove() {
    _count = 0;
    notifyListeners();
  }
}
