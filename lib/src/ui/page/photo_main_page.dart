import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo/src/delegate/badge_delegate.dart';
import 'package:photo/src/delegate/loading_delegate.dart';
import 'package:photo/src/engine/lru_cache.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/config_provider.dart';
import 'package:photo/src/provider/gallery_list_provider.dart';
import 'package:photo/src/provider/i18n_provider.dart';
import 'package:photo/src/provider/selected_provider.dart';
import 'package:photo/src/ui/dialog/change_gallery_dialog.dart';
import 'package:photo/src/ui/page/photo_preview_page.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoMainPage extends StatefulWidget {
  final ValueChanged<List<AssetEntity>> onClose;

  const PhotoMainPage({
    Key key,
    this.onClose,
  }) : super(key: key);

  @override
  _PhotoMainPageState createState() => _PhotoMainPageState();
}

class _PhotoMainPageState extends State<PhotoMainPage>
    with SelectedProvider, GalleryListProvider {
  Options get options => ConfigProvider.of(context).options;

  I18nProvider get i18nProvider => ConfigProvider.of(context).provider;

  List<AssetEntity> list = [];

  Color get themeColor => options.themeColor;

  AssetPathEntity _currentPath = AssetPathEntity.all;

  bool _isInit = false;

  AssetPathEntity get currentPath {
    if (_currentPath == null) {
      return null;
    }
    return _currentPath;
  }

  set currentPath(AssetPathEntity value) {
    _currentPath = value;
  }

  GlobalKey scaffoldKey;
  ScrollController scrollController;

  bool isPushed = false;

  @override
  void initState() {
    super.initState();
    _refreshList();
    scaffoldKey = GlobalKey();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scaffoldKey = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: options.textColor,
      fontSize: 14.0,
    );
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: options.themeColor),
      child: DefaultTextStyle(
        style: textStyle,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: _cancel,
            ),
            title: Text(
              i18nProvider.getTitleText(options),
            ),
            actions: <Widget>[
              FlatButton(
                splashColor: Colors.transparent,
                child: Text(
                  i18nProvider.getSureText(options, selectedCount),
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
            key: scaffoldKey,
            provider: i18nProvider,
            options: options,
            galleryName: currentPath.name,
            onGalleryChange: _onGalleryChange,
            onTapPreview: selectedList.isEmpty ? null : _onTapPreview,
            selectedProvider: this,
            galleryListProvider: this,
          ),
        ),
      ),
    );
  }

  void _cancel() {
    selectedList.clear();
    widget.onClose(selectedList);
  }

  @override
  bool isUpperLimit() {
    var result = selectedCount == options.maxSelected;
    if (result) _showTip(i18nProvider.getMaxTipText(options));
    return result;
  }

  void sure() {
    widget.onClose?.call(selectedList);
  }

  void _showTip(String msg) {
    if (isPushed) {
      return;
    }
    Scaffold.of(scaffoldKey.currentContext).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: options.textColor,
            fontSize: 14.0,
          ),
        ),
        duration: Duration(milliseconds: 1500),
        backgroundColor: themeColor.withOpacity(0.7),
      ),
    );
  }

  Future<void> _refreshList() async {
    var pathList = await PhotoManager.getAssetPathList();

    options.sortDelegate.sort(pathList);

    galleryPathList.clear();
    galleryPathList.addAll(pathList);

    var imageList = await currentPath.assetList;
    AssetPathEntity.all.name = i18nProvider.getAllGalleryText(options);
    this.list.clear();
    this.list.addAll(imageList);
    setState(() {
      _isInit = true;
    });
  }

  Widget _buildBody() {
    if (!_isInit) {
      return _buildLoading();
    }

    return Container(
      color: options.dividerColor,
      child: GridView.builder(
        controller: scrollController,
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

  Widget _buildItem(BuildContext context, int index) {
    var data = list[index];
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => _onItemClick(data, index),
        child: Stack(
          children: <Widget>[
            ImageItem(
              entity: data,
              themeColor: themeColor,
              size: options.thumbSize,
              loadingDelegate: options.loadingDelegate,
              badgeDelegate: options.badgeDelegate,
            ),
            _buildMask(containsEntity(data)),
            _buildSelected(data),
          ],
        ),
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

  Widget _buildSelected(AssetEntity entity) {
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

  Widget _buildText(AssetEntity entity) {
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

  void changeCheck(bool value, AssetEntity entity) {
    if (value) {
      addSelectEntity(entity);
    } else {
      removeSelectEntity(entity);
    }
    setState(() {});
  }

  void _onGalleryChange(AssetPathEntity value) {
    _currentPath = value;

    _currentPath.assetList.then((v) {
      list.clear();
      list.addAll(v);
      scrollController.jumpTo(0.0);
      setState(() {});
    });
  }

  void _onItemClick(AssetEntity data, int index) {
    var result = new PhotoPreviewResult();
    isPushed = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return ConfigProvider(
            provider: ConfigProvider.of(context).provider,
            options: options,
            child: PhotoPreviewPage(
              selectedProvider: this,
              list: List.of(list),
              initIndex: index,
              changeProviderOnCheckChange: true,
              result: result,
            ),
          );
        },
      ),
    ).then((v) {
      if (handlePreviewResult(v)) {
        Navigator.pop(context, v);
        return;
      }
      isPushed = false;
      setState(() {});
    });
  }

  void _onTapPreview() {
    var result = new PhotoPreviewResult();
    isPushed = true;
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (ctx) => ConfigProvider(
              provider: ConfigProvider.of(context).provider,
              options: options,
              child: PhotoPreviewPage(
                selectedProvider: this,
                list: List.of(selectedList),
                changeProviderOnCheckChange: false,
                result: result,
              ),
            ),
      ),
    )
        .then(
      (v) {
        if (handlePreviewResult(v)) {
          print(v);
          Navigator.pop(context, v);
          return;
        }
        isPushed = false;
        compareAndRemoveEntities(result.previewSelectedList);
      },
    );
  }

  bool handlePreviewResult(List<AssetEntity> v) {
    if (v == null) {
      return false;
    }
    if (v is List<AssetEntity>) {
      return true;
    }
    return false;
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            padding: const EdgeInsets.all(5.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(themeColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              i18nProvider.loadingText(),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class _BottomWidget extends StatefulWidget {
  final ValueChanged<AssetPathEntity> onGalleryChange;

  final Options options;

  final I18nProvider provider;

  final SelectedProvider selectedProvider;

  final String galleryName;

  final GalleryListProvider galleryListProvider;
  final VoidCallback onTapPreview;

  const _BottomWidget({
    Key key,
    this.onGalleryChange,
    this.options,
    this.provider,
    this.selectedProvider,
    this.galleryName = "",
    this.galleryListProvider,
    this.onTapPreview,
  }) : super(key: key);

  @override
  __BottomWidgetState createState() => __BottomWidgetState();
}

class __BottomWidgetState extends State<_BottomWidget> {
  Options get options => widget.options;

  I18nProvider get i18nProvider => widget.provider;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 14.0);
    const textPadding = const EdgeInsets.symmetric(horizontal: 16.0);
    return Container(
      color: options.themeColor,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Container(
          height: 52.0,
          child: Row(
            children: <Widget>[
              FlatButton(
                onPressed: _showGallerySelectDialog,
                splashColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  height: 44.0,
                  padding: textPadding,
                  child: Text(
                    widget.galleryName,
                    style: textStyle.copyWith(color: options.textColor),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              FlatButton(
                onPressed: widget.onTapPreview,
                textColor: options.textColor,
                splashColor: Colors.transparent,
                disabledTextColor: options.disableColor,
                child: Container(
                  height: 44.0,
                  alignment: Alignment.center,
                  child: Text(
                    i18nProvider.getPreviewText(
                        options, widget.selectedProvider),
                    style: textStyle,
                  ),
                  padding: textPadding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGallerySelectDialog() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => ChangeGalleryDialog(
            galleryList: widget.galleryListProvider.galleryPathList,
          ),
    );

    if (result != null) widget.onGalleryChange?.call(result);
  }
}

class ImageItem extends StatelessWidget {
  final AssetEntity entity;

  final Color themeColor;

  final int size;

  final LoadingDelegate loadingDelegate;

  final BadgeDelegate badgeDelegate;

  const ImageItem({
    Key key,
    this.entity,
    this.themeColor,
    this.size = 64,
    this.loadingDelegate,
    this.badgeDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thumb = ImageLruCache.getData(entity, size);
    if (thumb != null) {
      return _buildImageItem(context, thumb);
    }

    return FutureBuilder<Uint8List>(
      future: entity.thumbDataWithSize(size, size),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        var futureData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done &&
            futureData != null) {
          ImageLruCache.setData(entity, size, futureData);
          return _buildImageItem(context, futureData);
        }
        return Center(
          child: loadingDelegate.buildPreviewLoading(
            context,
            entity,
            themeColor,
          ),
        );
      },
    );
  }

  Widget _buildImageItem(BuildContext context, Uint8List data) {
    var image = Image.memory(
      data,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
    // FutureBuilder()
    var badge = FutureBuilder<Duration>(
      future: entity.videoDuration,
      builder: (ctx, snapshot) {
        if (snapshot.hasData && snapshot != null) {
          var buildBadge =
              badgeDelegate?.buildBadge(context, entity.type, snapshot.data);
          if (buildBadge == null) {
            return Container();
          } else {
            return buildBadge;
          }
        } else {
          return Container();
        }
      },
    );

    return Stack(
      children: <Widget>[
        image,
        IgnorePointer(
          child: badge,
        ),
      ],
    );
  }
}
