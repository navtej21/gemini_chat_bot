import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  var items = <Map<String, String>>[].obs;

  void addItem(String message, String user) {
    items.add({"user": user, "message": message});
  }

  void removeItem(String item) {
    items.remove(item);
  }
}
