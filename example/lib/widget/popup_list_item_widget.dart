import 'package:example/main.dart';
import 'package:flutter/material.dart';

class PopupListItemWidget extends StatelessWidget {
  final LeaderBoard item;

  PopupListItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        item.username,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
