import 'package:photo_manager/photo_manager.dart';

abstract class SelectedProvider {
  List<AssetEntity> selectedList = [];

  int get selectedCount => selectedList.length;

  bool containsEntity(AssetEntity entity) {
    return selectedList.contains(entity);
  }

  int indexOfSelected(AssetEntity entity) {
    return selectedList.indexOf(entity);
  }

  bool isUpperLimit();

  bool addSelectEntity(AssetEntity entity) {
    if (containsEntity(entity)) {
      return false;
    }
    if (isUpperLimit() == true) {
      return false;
    }
    selectedList.add(entity);
    return true;
  }

  bool removeSelectEntity(AssetEntity entity) {
    return selectedList.remove(entity);
  }

  void compareAndRemoveEntities(List<AssetEntity> previewSelectedList) {
    var srcList = List.of(selectedList);
    selectedList.clear();
    srcList.forEach((entity) {
      if (previewSelectedList.contains(entity)) {
        selectedList.add(entity);
      }
    });
  }

  void sure();
}
