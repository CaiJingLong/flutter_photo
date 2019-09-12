import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetImageWidget extends StatelessWidget {
  final AssetEntity assetEntity;
  final double width;
  final double height;
  final BoxFit boxFit;

  const AssetImageWidget({
    Key key,
    @required this.assetEntity,
    this.width,
    this.height,
    this.boxFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (assetEntity == null) {
      return _buildContainer();
    }

    print(
        "assetEntity.width = ${assetEntity.width} , assetEntity.height = ${assetEntity.height}");

    return FutureBuilder<Uint8List>(
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return _buildContainer(
            child: Image.memory(
              snapshot.data,
              width: width,
              height: height,
              fit: boxFit,
            ),
          );
        } else {
          return _buildContainer();
        }
      },
      future: assetEntity.thumbDataWithSize(
        width.toInt(),
        height.toInt(),
      ),
    );
  }

  Widget _buildContainer({Widget child}) {
    child ??= Container();
    return Container(
      width: width,
      height: height,
      child: child,
    );
  }
}
