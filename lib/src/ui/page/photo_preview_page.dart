import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/config_provider.dart';
import 'package:photo/src/provider/selected_provider.dart';
import 'package:photo/src/ui/page/photo_main_page.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoPreviewPage extends StatefulWidget {
  final SelectedProvider selectedProvider;

  final List<ImageEntity> list;

  final int initIndex;

  /// 这个参数是控制在内部点击check后是否实时修改provider状态
  final bool changeProviderOnCheckChange;

  /// 这里封装了结果
  final PhotoPreviewResult result;

  const PhotoPreviewPage({
    Key key,
    @required this.selectedProvider,
    @required this.list,
    @required this.changeProviderOnCheckChange,
    @required this.result,
    this.initIndex = 0,
  }) : super(key: key);

  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  ConfigProvider get config => ConfigProvider.of(context);

  Options get options => config.options;

  Color get themeColor => options.themeColor;

  Color get textColor => options.textColor;

  SelectedProvider get selectedProvider => widget.selectedProvider;

  List<ImageEntity> get list => widget.list;

  StreamController<int> pageChangeController = StreamController.broadcast();

  Stream<int> get pageStream => pageChangeController.stream;

  bool get changeProviderOnCheckChange => widget.changeProviderOnCheckChange;

  List<ImageEntity> get previewSelectedList =>
      widget.result.previewSelectedList;

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageChangeController.add(0);
    previewSelectedList.clear();
    previewSelectedList.addAll(selectedProvider.selectedList);
    pageController = PageController(
      initialPage: widget.initIndex,
    );
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
            stream: pageStream,
            initialData: widget.initIndex,
            builder: (ctx, snap) => Text(
                  "${snap.data + 1}/${widget.list.length}",
                ),
          ),
        ),
        body: PageView.builder(
          controller: pageController,
          itemBuilder: _buildItem,
          itemCount: list.length,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: _buildBottom(),
        bottomSheet: _buildThumb(),
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      height: 52.0,
      color: themeColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          _buildCheckbox(),
        ],
      ),
    );
  }

  Container _buildCheckbox() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 150.0,
      ),
      child: StreamBuilder<int>(
        builder: (ctx, snapshot) {
          var index = snapshot.data;
          var data = list[index];
          return CheckboxListTile(
            value: previewSelectedList.contains(data),
            onChanged: (bool check) {
              if (changeProviderOnCheckChange) {
                _onChangeProvider(check, index);
              } else {
                _onCheckInOnlyPreview(check, index);
              }
            },
            activeColor: Color.lerp(textColor, themeColor, 0.6),
            title: Text(
              config.provider.getSelectedOptionsText(options),
              textAlign: TextAlign.end,
              style: TextStyle(color: options.textColor),
            ),
          );
        },
        initialData: widget.initIndex,
        stream: pageStream,
      ),
    );
  }

  /// 仅仅修改预览时的状态,在退出时,再更新provider的顺序,这里无论添加与否不修改顺序
  void _onCheckInOnlyPreview(bool check, int index) {
    var item = list[index];
    if (check) {
      previewSelectedList.add(item);
    } else {
      previewSelectedList.remove(item);
    }
    pageChangeController.add(index);
  }

  /// 直接修改预览状态,会直接移除item
  void _onChangeProvider(bool check, int index) {
    var item = list[index];
    if (check) {
      if (selectedProvider.addSelectEntity(item)) {
        previewSelectedList.add(item);
      }
    } else {
      selectedProvider.removeSelectEntity(item);
      previewSelectedList.remove(item);
    }
    pageChangeController.add(index);
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

  Widget _buildThumb() {
    return Container(
      height: 80.0,
      child: ListView.builder(
        itemBuilder: _buildThumbItem,
        itemCount: previewSelectedList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildThumbItem(BuildContext context, int index) {
    // todo 这里需要一个遮盖
    var item = previewSelectedList[index];
    return GestureDetector(
      onTap: () => changeSelected(item, index),
      child: Container(
        width: 80.0,
        child: Stack(
          children: <Widget>[
            ImageItem(
              themeColor: themeColor,
              entity: item,
            ),
            IgnorePointer(
              child: StreamBuilder(
                stream: pageStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(previewSelectedList.contains(item)){
                    return Container();
                  }
                  return Container(
                    color: Colors.white.withOpacity(0.5),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeSelected(ImageEntity entity, int index) {
    var itemIndex = list.indexOf(entity);
    if (itemIndex != -1) pageController.jumpToPage(itemIndex);
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

class PhotoPreviewResult {
  List<ImageEntity> previewSelectedList = [];
}
