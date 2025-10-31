import 'dart:core';
import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double>_baseIngredientAmounts = [];
  int get currentNumber => _currentNumber;
  // Set luong nguyen lieu ban dau
  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    notifyListeners();
  }
  // Update luong nguyen lieu khi thay doi so luong phan an
  List<String> get updateIngredientAmounts{
    return _baseIngredientAmounts.map<String>((amount) => (amount * _currentNumber).toStringAsFixed(1))
    .toList();
  }
  // tang so luong phan an
  void increaseQuantity(){
    _currentNumber++;
    notifyListeners();
  }
  // giam so luong phan an
  void decreaseQuantity(){
    if(_currentNumber >1){
      _currentNumber--;
      notifyListeners();
    }
  }
}