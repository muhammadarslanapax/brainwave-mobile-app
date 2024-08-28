import 'package:flutter/material.dart';

snackBar(BuildContext context, {required String title}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
