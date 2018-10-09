import 'package:photo_manager/photo_manager.dart';

abstract class SortDelegate {
  const SortDelegate();

  void sort(List<ImagePathEntity> list);

  static const none = DefaultSortDelegate();

  static const common = CommonSortDelegate();
}

class DefaultSortDelegate extends SortDelegate {
  const DefaultSortDelegate();

  @override
  void sort(List<ImagePathEntity> list) {}
}

class CommonSortDelegate extends SortDelegate {
  const CommonSortDelegate();

  @override
  void sort(List<ImagePathEntity> list) {
    list.sort((path1, path2) {
      if (path1 == ImagePathEntity.all) {
        return -1;
      }

      if (path2 == ImagePathEntity.all) {
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

  int otherSort(ImagePathEntity path1, ImagePathEntity path2) {
    return path1.name.compareTo(path2.name);
  }

  bool _isCamera(ImagePathEntity entity) {
    return entity.name.toUpperCase() == "camera".toUpperCase();
  }

  bool _isScreenShot(ImagePathEntity entity) {
    return entity.name.toUpperCase() == "screenshots".toUpperCase() ||
        entity.name.toUpperCase() == "screenshot".toUpperCase();
  }
}
