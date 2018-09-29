import 'package:flutter/material.dart';

class Options {
  final int rowCount;

  final int maxSelected;

  final double padding;

  final double itemRadio;

  final Color themeColor;

  final Color dividerColor;

  final Color textColor;

  final Color paddingColor;

  const Options({
    this.rowCount,
    this.maxSelected,
    this.padding,
    this.itemRadio,
    this.themeColor,
    this.dividerColor,
    this.textColor,
    this.paddingColor,
  });

  @override
  String toString() {
    return 'Options{rowCount: $rowCount, maxSelected: $maxSelected, padding: $padding, themeColor: $themeColor, dividerColor: $dividerColor, textColor: $textColor, paddingColor: $paddingColor}';
  }
}
