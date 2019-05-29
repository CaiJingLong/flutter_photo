import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import './asset_image.dart';

class PreviewPage extends StatelessWidget {
  final List<AssetEntity> list;

  const PreviewPage({Key key, this.list = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview"),
      ),
      body: ListView(
        children: list
            .map((item) => AssetImageWidget(
                  assetEntity: item,
                  width: 300,
                  height: 200,
                  boxFit: BoxFit.cover,
                ))
            .toList(),
      ),
    );
  }
}
