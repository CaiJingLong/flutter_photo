import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/config_provider.dart';
import 'package:photo/src/provider/selected_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoPreviewPage extends StatefulWidget {
  final SelectedProvider selectedProvider;

  final List<ImageEntity> list;

  const PhotoPreviewPage({Key key, this.selectedProvider, this.list})
      : super(key: key);

  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  ConfigProvider get config => ConfigProvider.of(context);

  Options get options => config.options;

  Color get themeColor => options.themeColor;

  Color get textColor => options.textColor;

  List<ImageEntity> get list => widget.list;

  StreamController<int> pageChangeController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    pageChangeController.add(0);
  }

  @override
  void dispose() {
    pageChangeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: options.themeColor),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: config.options.themeColor,
          title: StreamBuilder(
            stream: pageChangeController.stream,
            initialData: 0,
            builder: (ctx, snap) => Text(
                  "${snap.data + 1}/${widget.list.length}",
                ),
          ),
        ),
        body: PageView.builder(
          itemBuilder: _buildItem,
          itemCount: list.length,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      height: 44.0,
      color: themeColor,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var data = list[index];
    return BigPhotoImage(
      imageEntity: data,
    );
  }

  void _onPageChanged(int value) {
    pageChangeController.add(value);
  }
}

class BigPhotoImage extends StatefulWidget {
  final ImageEntity imageEntity;

  const BigPhotoImage({Key key, this.imageEntity}) : super(key: key);

  @override
  _BigPhotoImageState createState() => _BigPhotoImageState();
}

class _BigPhotoImageState extends State<BigPhotoImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.imageEntity.file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        var file = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done && file != null) {
          return Image.file(
            file,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          );
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
