# CHANGELOG

## 0.5.0-dev.3

Fix:

video type error.

Feature:

Clear memory cache.

## 0.5.0-dev.2

- Rollback photo_manager

Fix:

- no selected text

## 0.4.8

- Rollback photo_manager

Fix:

- pickedAssetList error

## 0.4.7

- Rollback photo_manager.
- Add `pickedAssetList` for `pickAsset`.

## 0.4.5+1

Fix:

- `photoPathList` of `PhotoPicker.pickAsset`.

## 0.4.5

Rollback `photo_manager` to `0.4.5`.

## 0.4.4

Rollback `photo_manager` to `0.4.4`.

To fix some error.

## 0.4.3+1

Fix a error for build.

## 0.4.3

Rollback `photo_manager` to `0.4.3`.

## 0.4.2+1

Rollback `photo_manager` to `0.4.2`.

## 0.4.2

## 0.4.1+1

Rollback `photo_manager` to `0.4.1`.

## 0.4.1

**The version will build fail.**

Rollback `photo_manager` to `0.4.1`.

## 0.4.0

**The version will build fail.**

Rollback `photo_manager` to `0.4.0`.

- support androidQ.

## 0.3.4+1

fix:

- title and left icon color.
- checkColor in preview can be edit.

## 0.3.4

Rollback `photo_manager` to `0.3.4`

## 0.3.3

Rollback `photo_manager` to `0.3.3`

## 0.3.2

Rollback `photo_manager` to `0.3.2`

## 0.3.1

`photo_manager` to `0.3.1`

If the selected image is deleted by other applications, the selected status in the selector will be updated correctly.

## 0.3.0 add params photoList

**Breaking change**. Migrate from the deprecated original Android Support Library to AndroidX. This shouldn't result in any functional changes, but it requires any Android apps using this plugin to also migrate if they're using the original support library.

add:

- When the album changes, it refreshes in real time.

fix:

- Video duration badge time problem.
- Images sort by create time.

## 0.2.0

**break change**
support pick only image or video

## 0.1.11

fix pubspec version

## 0.1.10 fix bug

fix a error widget bug.

## 0.1.9

fix all assets i18n provider

## 0.1.8

Fixed crash bug when the number of photos or videos was zero.

## 0.1.7

add a badge delegate for asset

## 0.1.6 Rollback photo_manager version

sort asset by date

## 0.1.5 Rollback photo_manager version

## 0.1.4 fix thumb is null bug

fix thumb bug.

## 0.1.3 support ios icloud asset

## 0.1.2 fix bug

fix all path hasVideo property bug

## 0.1.1 fix bug and add params

add loadingDelegate

## 0.1.0 support video

API incompatibility

ImageXXX rename AssetXXX

## 0.0.8 fix bug

DefaultCheckBoxBuilderDelegate params checkColor not valid bug

## 0.0.7 fix bug

fix dividerColor not valid bug

## 0.0.6 add checkbox delegate

users can use CheckBoxDelegate to custom preview right bottom widget

## 0.0.5 add a params

add the sort delegate to help user sort gallery

Optimized LruCache

add a loading refresh indicator in the gallery

## 0.0.4 fix #1

fix request other permission will crash bug

depo photo_manager 0.0.3

## 0.0.3 add the thumb size to option

add a params for pick image , thumb size

## 0.0.2 fix bug

preview sure button bug
preview bottom safeArea

## 0.0.1 first version

image picker
