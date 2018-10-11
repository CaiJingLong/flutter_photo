import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ChangeGalleryDialog extends StatefulWidget {
  final List<AssetPathEntity> galleryList;

  const ChangeGalleryDialog({Key key, this.galleryList}) : super(key: key);

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
    return FlatButton(
      child: ListTile(
        title: Text(entity.name),
      ),
      onPressed: () {
        Navigator.pop(context, entity);
      },
    );
  }
}
