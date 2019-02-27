import 'package:flutter/material.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/i18n_provider.dart';

class ConfigProvider extends InheritedWidget {
  final Options options;
  final I18nProvider provider;

  ConfigProvider({
    @required this.options,
    @required this.provider,
    @required Widget child,
    Key key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ConfigProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ConfigProvider);
}
