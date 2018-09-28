library photo;

import 'package:flutter/material.dart';

import 'package:photo_manager/photo_manager.dart';

import 'package:photo/src/entity/options.dart';

/// A Calculator.
class PhotoPicker {
  static PhotoPicker _instance;

  PhotoPicker._();

  factory PhotoPicker() {
    _instance ??= PhotoPicker._();
    return _instance;
  }

  void pickImage({
    @required BuildContext context,
    int rowCount = 3,
    int maxSelected = 9,
    double padding = 0.5,
    Color themeColor,
    Color dividerColor,
    Color textColor,
    Color paddingColor,
  }) {
    themeColor ??= Theme.of(context)?.primaryColor ?? Colors.black;
    dividerColor ??= Theme.of(context)?.dividerColor ?? Colors.grey;
    paddingColor ??= Theme.of(context)?.dividerColor ?? Colors.grey;
    textColor ??= Colors.white;

    Options(
      rowCount: rowCount,
      dividerColor: dividerColor,
      maxSelected: maxSelected,
      padding: padding,
      paddingColor: paddingColor,
      textColor: textColor,
      themeColor: themeColor,
    );
  }
}
