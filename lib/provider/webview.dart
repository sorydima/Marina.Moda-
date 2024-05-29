import 'package:flutter/cupertino.dart';

class WebViewProvider with ChangeNotifier {
  String currentUrl = "https://marina.moda";

  changeUrl({String? oldUrl}) {
    currentUrl = oldUrl!;
    notifyListeners();
  }
}
