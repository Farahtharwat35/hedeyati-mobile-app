import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Gift {
  String description;

  String imageUrl;
  String price;
  bool isPledged;

  Gift({
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isPledged = false,
  });
}