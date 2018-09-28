import 'package:flutter/material.dart';

class Options {
  final int rowCount;
  final int maxSelected;
  final double padding;
  final Color themeColor;
  final Color dividerColor;
  final Color textColor;
  final Color paddingColor;

  const Options(
      {this.rowCount,
      this.maxSelected,
      this.padding,
      this.themeColor,
      this.dividerColor,
      this.textColor,
      this.paddingColor});
}
