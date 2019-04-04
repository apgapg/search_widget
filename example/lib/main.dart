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
    print(list.runtimeType);
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
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      item.username,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  );
                },
                selectedItemBuilder: (
                  LeaderBoard selectedItem,
                  deleteSelectedItem,
                ) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 4.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              selectedItem.username,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 22),
                          color: Colors.grey[700],
                          onPressed: deleteSelectedItem,
                        ),
                      ],
                    ),
                  );
                },
                // widget customization
                noItemsFoundWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.folder_open,
                      size: 24,
                      color: Colors.grey[900].withOpacity(0.7),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "No Items Found",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[900].withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: new TextStyle(fontSize: 16, color: Colors.grey[600]),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x4437474F)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: "Search here...",
                        contentPadding: EdgeInsets.only(
                          left: 16,
                          right: 20,
                          top: 14,
                          bottom: 14,
                        ),
                      ),
                    ),
                  );
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
