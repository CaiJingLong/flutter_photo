import 'package:flutter/material.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/config_provider.dart';
import 'package:photo/src/provider/i18n_provider.dart';
import 'package:photo/src/ui/page/photo_main_page.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoApp extends StatelessWidget {
  final Options options;
  final I18nProvider provider;

  const PhotoApp({Key key, this.options, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigProvider(
      provider: provider,
      options: options,
      child: PhotoMainPage(
        onClose: (List<AssetEntity> value) {
          Navigator.pop(context, value);
        },
      ),
    );
  }
}
