import 'package:flutter/material.dart';
import 'package:photo/src/engine/lru_cache.dart';
import 'package:photo/src/entity/options.dart';
import 'package:photo/src/provider/i18n_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class ChangeGalleryDialog extends StatefulWidget {
  final List<AssetPathEntity> galleryList;
  final I18nProvider i18n;
  final Options options;
  final AssetPathEntity current;

  const ChangeGalleryDialog({
    Key key,
    this.galleryList,
    this.i18n,
    this.options,
    this.current,
  }) : super(key: key);

  @override
  _ChangeGalleryDialogState createState() => _ChangeGalleryDialogState();
}

class _ChangeGalleryDialogState extends State<ChangeGalleryDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: widget.galleryList.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var entity = widget.galleryList[index];
    String text;

    if (entity.isAll) {
      text = widget.i18n?.getAllGalleryText(widget.options);
    }

    text = text ?? entity.name;

    return FlatButton(
      child: ListTile(
        title: Text("$text (${entity.assetCount})"),
        trailing: text == widget.current.name
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              )
            : null,
      ),
      onPressed: () {
        Navigator.pop(context, entity);
      },
    );
  }
}
