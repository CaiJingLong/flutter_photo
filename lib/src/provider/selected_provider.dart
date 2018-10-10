import 'package:photo_manager/photo_manager.dart';

abstract class SelectedProvider {
  List<ImageEntity> selectedList = [];

  int get selectedCount => selectedList.length;

  bool containsEntity(ImageEntity entity) {
    return selectedList.contains(entity);
  }

  int indexOfSelected(ImageEntity entity) {
    return selectedList.indexOf(entity);
  }

  bool isUpperLimit();

  bool addSelectEntity(ImageEntity entity) {
    if (containsEntity(entity)) {
      return false;
    }
    if (isUpperLimit() == true) {
      return false;
    }
    selectedList.add(entity);
    return true;
  }

  bool removeSelectEntity(ImageEntity entity) {
    return selectedList.remove(entity);
  }

  void compareAndRemoveEntities(List<ImageEntity> previewSelectedList) {
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
