import 'package:ar_app/screens/ar_view_screen.dart';
import 'package:ar_app/services/model.dart';
import 'package:flutter/material.dart';

void showARView(BuildContext context, Model model, VoidCallback callback) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => ARViewScreen(model: model)),
  ).then((_) => callback());
}