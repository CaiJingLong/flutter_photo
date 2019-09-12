part of '../photo_main_page.dart';

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
    var badge;
    final badgeBuilder =
        badgeDelegate?.buildBadge(context, entity.type, entity.videoDuration);
    if (badgeBuilder == null) {
      badge = Container();
    } else {
      badge = badgeBuilder;
    }

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
