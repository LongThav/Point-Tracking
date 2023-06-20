import 'package:flutter/cupertino.dart';

class Count with ChangeNotifier{
  int _count = 1;
  int get count => _count;

  int _countProduct = 0;
  int get countPrduct => _countProduct;
  void increment(){
    _count++;
    notifyListeners();
  }

  void decrement(){
    _count --;
    notifyListeners();
  }

  void incrementProduct(){
    _countProduct ++;
    notifyListeners();
  }

  void decrementProduct(){
    _countProduct --;
    notifyListeners();
  }
}