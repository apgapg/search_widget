import 'package:example/widget/my_text_field.dart';
import 'package:example/widget/no_items_found.dart';
import 'package:example/widget/popup_list_item_widget.dart';
import 'package:example/widget/selected_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:search_widget/search_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Widget',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LeaderBoard> list = <LeaderBoard>[
    LeaderBoard("Flutter", 54.0),
    LeaderBoard("React", 22.5),
    LeaderBoard("Ionic", 24.7),
    LeaderBoard("Xamarin", 22.1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Widget"),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              SearchWidget<LeaderBoard>(
                dataList: list,
                hideSearchBoxWhenItemSelected: false,
                listContainerHeight: MediaQuery.of(context).size.height / 4,
                queryBuilder: (String query, List<LeaderBoard> list) {
                  return list.where((LeaderBoard item) => item.username.toLowerCase().contains(query.toLowerCase())).toList();
                },
                popupListItemBuilder: (LeaderBoard item) {
                  return PopupListItemWidget(item);
                },
                selectedItemBuilder: (LeaderBoard selectedItem, VoidCallback deleteSelectedItem) {
                  return SelectedItemWidget(selectedItem, deleteSelectedItem);
                },
                // widget customization
                noItemsFoundWidget: NoItemsFound(),
                textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                  return MyTextField(controller, focusNode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderBoard {
  final String username;
  final double score;

  LeaderBoard(this.username, this.score);
}
