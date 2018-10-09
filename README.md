# photo

image picker, multi picker
use flutter as ui

if you want to build custom ui, you just need api to make custom ui. to use [photo_manager](https://github.com/CaiJingLong/flutter_photo_manager)

## screenshot

![image](https://github.com/CaiJingLong/some_asset/blob/master/image_picker1.gif)

## install

```yaml
dependencies:
  photo: ^0.0.4
```

## import

```dart
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
```

## use

```dart
  void _pickImage(BuildContext context) async {
    List<ImageEntity> imgList = await PhotoPicker.pickImage(
      context: context, // BuildContext requied

      /// The following are optional parameters.
      themeColor: Colors.green, // the title color and bottom color
      padding: 5.0, // item padding
      dividerColor: Colors.deepOrange, // divider color
      disableColor: Colors.grey.shade300, // the check box disable color
      itemRadio: 0.88, // the content item radio
      maxSelected: 8, // max picker image count
      provider: CNProvider(), // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 5,  // item row count
      textColor: Colors.white, // text color
      thumbSize: 150, // preview thumb size, optional, default is 64
    );

    imgList.forEach((e) async {
      print(e.id);
    });
  }
```

## about android

### glide

android use glide to create image thumb, version is 4.8.0

if you other android library use the library, and version is not same, then you need edit your android project's build.gradle

```gradle
rootProject.allprojects {

    subprojects {
        project.configurations.all {
            resolutionStrategy.eachDependency { details ->
                if (details.requested.group == 'com.github.bumptech.glide'
                        && details.requested.name.contains('glide')) {
                    details.useVersion "4.8.0"
                }
            }
        }
    }

}
```

if you use the proguard

see the [github](https://github.com/bumptech/glide#proguard)
