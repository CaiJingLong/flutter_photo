part of './sort_delegate.dart';

abstract class SortAssetDelegate {
  const SortAssetDelegate();

  void sort(List<AssetEntity> list);
}

class DefaultAssetDelegate extends SortAssetDelegate {
  const DefaultAssetDelegate();

  @override
  void sort(List<AssetEntity> list) {
    list.sort((entity1, entity2) {
      return entity2.createDateTime.compareTo(entity1.createDateTime);
    });
  }
}
