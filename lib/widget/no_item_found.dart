import 'package:flutter/material.dart';

class NoItemFound extends StatelessWidget {
  final String title;
  final IconData icon;

  const NoItemFound({
    this.title = "No data found",
    this.icon = Icons.folder_open,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 24, color: Colors.grey[900]!.withOpacity(0.7)),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[900]!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
