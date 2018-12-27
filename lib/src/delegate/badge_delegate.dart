import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class BadgeDelegate {
  const BadgeDelegate();

  Widget buildBadge(BuildContext context, AssetType type);
}

class DefaultBadgeDelegate extends BadgeDelegate {
  final AlignmentGeometry alignment;

  const DefaultBadgeDelegate({
    this.alignment = Alignment.topLeft,
  });

  @override
  Widget buildBadge(BuildContext context, AssetType type) {
    if (type == AssetType.video) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 2.0,
          left: 2.0,
        ),
        child: Align(
          alignment: alignment,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Text(
              "video",
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
            padding: const EdgeInsets.all(4.0),
          ),
        ),
      );
    }

    return Container();
  }
}
