import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  const IconTextButton({Key key, this.icon, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: ListTile(
          leading: Icon(icon ?? Icons.device_unknown),
          title: Text(text ?? ""),
        ),
      ),
    );
  }
}
