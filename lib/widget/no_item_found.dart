import 'package:flutter/material.dart';

class NoItemFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.folder_open,
            size: 24,
            color: Colors.grey[900].withOpacity(0.7),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "No data found",
            style: TextStyle(
                fontSize: 16.0, color: Colors.grey[900].withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
