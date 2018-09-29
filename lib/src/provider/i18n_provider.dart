import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/SelectedProvider.dart';

abstract class I18nProvider {

  String getTitleText(Options options);

  String getSureText(Options options, SelectedProvider selectedProvider);

  String getPreviewText(Options options, SelectedProvider selectedProvider);

  static I18nProvider chinese = _CNProvider();

  static I18nProvider english = _ENProvider();

}

class _CNProvider extends I18nProvider {
  @override
  String getTitleText(Options options) {
    return "图片选择";
  }

  @override
  String getPreviewText(Options options, SelectedProvider selectedProvider) {
    return "预览(${selectedProvider.selectedCount})";
  }

  @override
  String getSureText(Options options, SelectedProvider selectedProvider) {
    return "确定(${selectedProvider.selectedCount}/${options.maxSelected})";
  }
}

class _ENProvider extends I18nProvider {
  @override
  String getTitleText(Options options) {
    return "image picker";
  }

  @override
  String getPreviewText(Options options, SelectedProvider selectedProvider) {
    return "preview(${selectedProvider.selectedCount})";
  }

  @override
  String getSureText(Options options, SelectedProvider selectedProvider) {
    return "sure(${selectedProvider.selectedCount}/${options.maxSelected})";
  }
}
