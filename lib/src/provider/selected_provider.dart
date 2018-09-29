import 'package:photo_manager/photo_manager.dart';

abstract class SelectedProvider {

  int get selectedCount;

  bool containsEntity(ImageEntity entity);

  int indexOfSelected(ImageEntity entity);

  void sure();
}
