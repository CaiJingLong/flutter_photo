import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo/src/engine/lru_cache.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/i18n_provider.dart';
import 'package:photo/src/provider/selected_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoMainPage extends StatefulWidget {
  final Options options;
  final I18nProvider provider;

  const PhotoMainPage({Key key, this.options, this.provider}) : super(key: key);

  @override
  _PhotoMainPageState createState() => _PhotoMainPageState();
}

class _PhotoMainPageState extends State<PhotoMainPage> with SelectedProvider {
  Options get options => widget.options;

  I18nProvider get i18nProvider => widget.provider;

  List<ImageEntity> selectedList = [];
  List<ImageParentPath> pathList = [];

  List<ImageEntity> list = [];

  Color get themeColor => options.themeColor;

  ImageParentPath _currentPath;

  ImageParentPath get currentPath {
    if (_currentPath == null) {
      return null;
    }
    return _currentPath;
  }

  set currentPath(ImageParentPath value) {
    _currentPath = value;
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: options.textColor,
      fontSize: 14.0,
    );
    return WillPopScope(
      child: DefaultTextStyle(
        style: textStyle,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: options.themeColor,
            title: Text(
              i18nProvider.getTitleText(options),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  i18nProvider.getSureText(options, this),
                  style: selectedCount == 0
                      ? textStyle.copyWith(color: options.disableColor)
                      : textStyle,
                ),
                onPressed: selectedCount == 0 ? null : sure,
              ),
            ],
          ),
          body: _buildBody(),
          bottomNavigationBar: _BottomWidget(
            provider: i18nProvider,
            options: options,
            onGalleryChange: _onGalleryChange,
            selectedProvider: this,
          ),
        ),
      ),
      onWillPop: () async {
        selectedList.clear();
        Navigator.of(context).pop(selectedList);
        return false;
      },
    );
  }

  void _refreshList() async {
    pathList = await ImageScanner.getImagePathList();
    var path = pathList[0];
    var imageList = await path.imageList;
    this.list.clear();
    this.list.addAll(imageList);
    print(list);
    setState(() {});
  }

  Widget _buildBody() {
    return Container(
      color: options.disableColor,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: options.rowCount,
          childAspectRatio: options.itemRadio,
          crossAxisSpacing: options.padding,
          mainAxisSpacing: options.padding,
        ),
        itemBuilder: _buildItem,
        itemCount: list.length,
      ),
    );
  }

  @override
  int get selectedCount => selectedList.length;

  @override
  bool containsEntity(ImageEntity entity) {
    return selectedList.contains(entity);
  }

  @override
  int indexOfSelected(ImageEntity entity) {
    return selectedList.indexOf(entity);
  }

  Widget _buildItem(BuildContext context, int index) {
    var data = list[index];
    return GestureDetector(
      onTap: () => _onItemClick(data),
      child: Stack(
        children: <Widget>[
          ImageItem(
            entity: data,
            themeColor: themeColor,
          ),
          _buildMask(containsEntity(data)),
          _buildSelected(data),
        ],
      ),
    );
  }

  _buildMask(bool showMask) {
    return IgnorePointer(
      child: AnimatedContainer(
        color: showMask ? Colors.black.withOpacity(0.5) : Colors.transparent,
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildSelected(ImageEntity entity) {
    var currentSelected = containsEntity(entity);
    return Positioned(
      right: 0.0,
      width: 36.0,
      height: 36.0,
      child: GestureDetector(
        onTap: () {
          changeCheck(!currentSelected, entity);
        },
        behavior: HitTestBehavior.translucent,
        child: _buildText(entity),
      ),
    );
  }

  Widget _buildText(ImageEntity entity) {
    var isSelected = containsEntity(entity);
    Widget child;
    BoxDecoration decoration;
    if (isSelected) {
      child = Text(
        (indexOfSelected(entity) + 1).toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.0,
          color: options.textColor,
        ),
      );
      decoration = BoxDecoration(color: themeColor);
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        border: Border.all(
          color: themeColor,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: decoration,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  void changeCheck(bool value, ImageEntity entity) {
    if (value) {
      selectedList.add(entity);
    } else {
      selectedList.remove(entity);
    }
    setState(() {});
  }

  void sure() {
    Navigator.pop(context, selectedList);
  }

  void _onItemClick(ImageEntity data) {}

  void _onGalleryChange(ImageParentPath value) {}
}

class _BottomWidget extends StatefulWidget {
  final ValueChanged<ImageParentPath> onGalleryChange;

  final Options options;

  final I18nProvider provider;

  final SelectedProvider selectedProvider;

  final String galleryName;

  const _BottomWidget({
    Key key,
    this.onGalleryChange,
    this.options,
    this.provider,
    this.selectedProvider,
    this.galleryName = "",
  }) : super(key: key);

  @override
  __BottomWidgetState createState() => __BottomWidgetState();
}

class __BottomWidgetState extends State<_BottomWidget> {
  Options get options => widget.options;

  I18nProvider get i18nProvider => widget.provider;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 14.0, color: options.textColor);
    print(MediaQuery.of(context).padding.bottom);
    return Container(
      color: options.themeColor,
      child: SafeArea(
        bottom: true,
        child: Container(
          height: 44.0,
          child: Row(
            children: <Widget>[
              Text(
                widget.galleryName,
                style: textStyle,
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                height: 44.0,
                alignment: Alignment.center,
                child: Text(
                  i18nProvider.getPreviewText(options, widget.selectedProvider),
                  style: textStyle,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageItem extends StatelessWidget {
  final ImageEntity entity;

  final Color themeColor;

  const ImageItem({
    Key key,
    this.entity,
    this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thumb = ImageLruCache.getData(entity);
    if (thumb != null) {
      return _buildImageItem(thumb);
    }
    return FutureBuilder<Uint8List>(
      future: entity.thumbData,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        var futureData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done &&
            futureData != null) {
          ImageLruCache.setData(entity, futureData);
          return _buildImageItem(futureData);
        }
        return Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(themeColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageItem(Uint8List data) {
    return Image.memory(
      data,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
