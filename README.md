# photo

[![pub package](https://img.shields.io/pub/v/photo.svg)](https://pub.dartlang.org/packages/photo) [![pub package](https://img.shields.io/pub/v/photo?include_prereleases)](https://pub.dartlang.org/packages/photo)
[![GitHub](https://img.shields.io/github/license/CaiJingLong/flutter_photo.svg?style=flat-square)](https://github.com/CaiJingLong/flutter_photo)
[![GitHub stars](https://img.shields.io/github/stars/CaiJingLong/flutter_photo.svg?style=social&label=Stars)](https://github.com/CaiJingLong/flutter_photo)

image picker, multi picker

support ios icloud

support video

use flutter as ui

if you want to build custom ui, you just need api to make custom ui. to use [photo_manager](https://github.com/CaiJingLong/flutter_photo_manager) or fork the library to custom ui.

## Screenshot

![image](https://github.com/CaiJingLong/some_asset/blob/master/image_picker1.gif)

## install

latest version : [![pub package](https://img.shields.io/pub/v/photo.svg)](https://pub.dartlang.org/packages/photo) [![pub package](https://img.shields.io/pub/v/photo?include_prereleases)](https://pub.dartlang.org/packages/photo)

```yaml
dependencies:
  photo: $latest_version
```

## Import

```dart
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
```

## Usage

### Simple use

```dart
void pickAssets() async {
    List<AssetEntity> assetList = await PhotoPicker.pickAsset(context: context);
    /// Use assetList to do something.
}
```

### More option

The context is required, other params is optional.

```dart
void pickAsset() async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      // BuildContext requied

      /// The following are optional parameters.
      themeColor: Colors.green,
      // the title color and bottom color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 8,
      // max picker image count
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 5,
      // item row count
      textColor: Colors.white,
      // text color
      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
        checkColor: Colors.blue,
      ), // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      loadingDelegate:
          this, // if you want to build custom loading widget,extends LoadingDelegate [see example/lib/main.dart]

      badgeDelegate: const DefaultBadgeDelegate(), /// or custom class extends [BadgeDelegate]

      pickType: type, // all/image/video

      List<AssetPathEntity> photoPathList, /// when [photoPathList] is not null , [pickType] invalid .
    );
```

### About photoPathList params

You can use [photo_manager] package to get `List<AssetPathEntity>` and handle or cache.

This parameter is then passed into the `pickAsset` method, where the incoming photoList is rendered instead of the data in the album.

## Whole example

You can see [github](https://github.com/caijinglong/flutter_photo/blob/master/example/) [main.dart](https://github.com/caijinglong/flutter_photo/blob/master/example/lib/main.dart)

## About android

### Migrate to androidX

See the [gitbook](https://caijinglong.gitbooks.io/migrate-flutter-to-androidx/content/)

### Glide

Android native use glide to create image thumb bytes, version is 4.8.0.

If your other android library use the library, and version is not same, then you need edit your android project's build.gradle.

```groovy
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

## About ios

Because the album is a privacy privilege, you need user permission to access it. You must to modify the `Info.plist` file in Runner project.

like next

```plist
<key>NSPhotoLibraryUsageDescription</key>
<string>App need your agree, can visit your album</string>
```

xcode like image
![in xcode](https://github.com/CaiJingLong/some_asset/blob/master/flutter_photo2.png)

### Build error

if you build error like include of non-modular header inside framework module, see [#10](https://github.com/CaiJingLong/flutter_photo/issues/10) or [so](https://stackoverflow.com/questions/27776497/include-of-non-modular-header-inside-framework-module)

## Thanks

Part of the Android code comes from [debuggerx01](https://github.com/debuggerx01).

## Donate

If my code helps you, and you're willing to buy me a cup of coffee.

you can use [paypal](https://paypal.me/caijinglong)

or scan my alipay

<img width="200px"  src="https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20181228213953.png"/>
