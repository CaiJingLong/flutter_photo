import 'package:photo_manager/photo_manager.dart';

part './sort_asset_delegate.dart';

/// SortPathDelegate
abstract class SortDelegate {
  final SortAssetDelegate assetDelegate;

  const SortDelegate({
    this.assetDelegate = const DefaultAssetDelegate(),
  });

  void sort(List<AssetPathEntity> list);

  static const none = DefaultSortDelegate();

  static const common = CommonSortDelegate();
}

class DefaultSortDelegate extends SortDelegate {
  const DefaultSortDelegate({
    SortAssetDelegate assetDelegate = const DefaultAssetDelegate(),
  }) : super(assetDelegate: assetDelegate);

  @override
  void sort(List<AssetPathEntity> list) {}
}

class CommonSortDelegate extends SortDelegate {
  const CommonSortDelegate({
    SortAssetDelegate assetDelegate = const DefaultAssetDelegate(),
  }) : super(assetDelegate: assetDelegate);

  @override
  void sort(List<AssetPathEntity> list) {
    list.sort((path1, path2) {
      if (path1.isAll) {
        return -1;
      }

      if (path2.isAll) {
        return 1;
      }

      if (_isCamera(path1)) {
        return -1;
      }

      if (_isCamera(path2)) {
        return 1;
      }

      if (_isScreenShot(path1)) {
        return -1;
      }

      if (_isScreenShot(path2)) {
        return 1;
      }

      return otherSort(path1, path2);
    });
  }

  int otherSort(AssetPathEntity path1, AssetPathEntity path2) {
    return path1.name.compareTo(path2.name);
  }

  bool _isCamera(AssetPathEntity entity) {
    return entity.name.toUpperCase() == "camera".toUpperCase();
  }

  bool _isScreenShot(AssetPathEntity entity) {
    return entity.name.toUpperCase() == "screenshots".toUpperCase() ||
        entity.name.toUpperCase() == "screenshot".toUpperCase();
  }
}
