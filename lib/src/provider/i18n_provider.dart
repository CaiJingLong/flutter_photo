import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/selected_provider.dart';

abstract class I18nProvider {
  const I18nProvider._();

  String getTitleText(Options options);

  String getSureText(Options options, int currentCount);

  String getPreviewText(Options options, SelectedProvider selectedProvider);

  String getSelectedOptionsText(Options options);

  String getMaxTipText(Options options);

  String getAllGalleryText(Options options);

  String loadingText() {
    return "Loading...";
  }

  I18NPermissionProvider getNotPermissionText(Options options);

  static const I18nProvider chinese = CNProvider();

  static const I18nProvider english = ENProvider();

  static const I18nProvider german = DEProvider();

  String getNoSelectedText(Options options) {
    return 'Select Folder';
  }
}

class CNProvider extends I18nProvider {
  const CNProvider() : super._();

  @override
  String getTitleText(Options options) {
    return "图片选择";
  }

  @override
  String getPreviewText(Options options, SelectedProvider selectedProvider) {
    return "预览(${selectedProvider.selectedCount})";
  }

  @override
  String getSureText(Options options, int currentCount) {
    return "确定($currentCount/${options.maxSelected})";
  }

  @override
  String getSelectedOptionsText(Options options) {
    return "选择";
  }

  @override
  String getMaxTipText(Options options) {
    return "您已经选择了${options.maxSelected}张图片";
  }

  @override
  String getAllGalleryText(Options options) {
    return "全部";
  }

  @override
  String loadingText() {
    return "加载中...";
  }

  @override
  String getNoSelectedText(Options options) {
    return getAllGalleryText(options);
  }

  @override
  I18NPermissionProvider getNotPermissionText(Options options) {
    return I18NPermissionProvider(
        cancelText: "取消", sureText: "去开启", titleText: "没有访问相册的权限");
  }
}

class ENProvider extends I18nProvider {
  const ENProvider() : super._();

  @override
  String getTitleText(Options options) {
    return "Image Picker";
  }

  @override
  String getPreviewText(Options options, SelectedProvider selectedProvider) {
    return "Preview (${selectedProvider.selectedCount})";
  }

  @override
  String getSureText(Options options, int currentCount) {
    return "Save ($currentCount/${options.maxSelected})";
  }

  @override
  String getSelectedOptionsText(Options options) {
    return "Selected";
  }

  @override
  String getMaxTipText(Options options) {
    return "Select ${options.maxSelected} pictures at most";
  }

  @override
  String getAllGalleryText(Options options) {
    return "Recent";
  }

  @override
  I18NPermissionProvider getNotPermissionText(Options options) {
    return I18NPermissionProvider(
        cancelText: "Cancel",
        sureText: "Allow",
        titleText: "No permission to access gallery");
  }
}

class DEProvider extends I18nProvider {
  const DEProvider() : super._();

  @override
  String getTitleText(Options options) {
    return "Medienauswahl";
  }

  @override
  String getPreviewText(Options options, SelectedProvider selectedProvider) {
    return "Vorschau (${selectedProvider.selectedCount})";
  }

  @override
  String getSureText(Options options, int currentCount) {
    return "Speichern ($currentCount/${options.maxSelected})";
  }

  @override
  String getSelectedOptionsText(Options options) {
    return "Ausgewählt";
  }

  @override
  String getMaxTipText(Options options) {
    return "Wählen Sie höchstens ${options.maxSelected} Medien aus";
  }

  @override
  String getAllGalleryText(Options options) {
    return "Alle";
  }

  String loadingText() {
    return "Lädt...";
  }

  String getNoSelectedText(Options options) {
    return 'Ordner auswählen';
  }

  @override
  I18NPermissionProvider getNotPermissionText(Options options) {
    return I18NPermissionProvider(
        cancelText: "Abbrechen",
        sureText: "Erlauben",
        titleText: "Kein Zugriff auf den Ordner");
  }
}

abstract class I18NCustomProvider implements I18nProvider {
  final String maxTipText;
  final String previewText;
  final String selectedOptionsText;
  final String sureText;
  final String titleText;
  final I18NPermissionProvider notPermissionText;

  I18NCustomProvider(
      this.maxTipText,
      this.previewText,
      this.selectedOptionsText,
      this.sureText,
      this.titleText,
      this.notPermissionText);

  @override
  String getMaxTipText(Options options) {
    return maxTipText;
  }

  @override
  String getSelectedOptionsText(Options options) {
    return selectedOptionsText;
  }

  @override
  String getTitleText(Options options) {
    return titleText;
  }

  @override
  I18NPermissionProvider getNotPermissionText(Options options) {
    return notPermissionText;
  }
}

class I18NPermissionProvider {
  final String titleText;
  final String sureText;
  final String cancelText;

  const I18NPermissionProvider(
      {this.titleText, this.sureText, this.cancelText});
}
