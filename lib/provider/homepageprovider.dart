
import 'package:flutter/foundation.dart';

class HomePageProvider with ChangeNotifier {
  int currentIndex = 0;
  changeBottomMenu({int?  oldIndex}){
    currentIndex=oldIndex!;
   notifyListeners();
  }

      bool floatingValueCurrent=false;
  floatingOnOff({bool?  oldFloatingValue}){
    floatingValueCurrent=oldFloatingValue!;
   notifyListeners();
  }




}
