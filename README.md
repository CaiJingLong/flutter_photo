# photo

## 内测中

install
```yaml
dependencies:

  photo:
    git: https://github.com/CaiJingLong/flutter_photo
    ref: 5affef481c63a314333b40b4f26e1dc689c15c00 # 这里的ref看情况修改也可
```

import
```dart
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
```

调用
```dart
void _pickImage() async{
    List<ImageEntity> imgList = await PhotoPicker.pickImage(
      context: context,
      themeColor: Colors.green,
      padding: 5.0,
      dividerColor: Colors.deepOrange,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
    );

    print(imgList);
  }

```