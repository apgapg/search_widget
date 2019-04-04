import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:search_widget/search_widget.dart';
import 'package:search_widget/widget/no_item_found.dart';

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
              Container(
                height: 200.0,
                child: Text("Random space"),
                alignment: Alignment.center,
                color: Colors.grey[200],
                padding: EdgeInsets.all(16.0),
              ),
              SearchWidget<LeaderBoard>(
                dataList: list,
                hideSearchBoxWhenItemSelected: false,
                listContainerHeight: MediaQuery.of(context).size.height / 4,
                queryBuilder: (String query, List<LeaderBoard> list) {
                  return list
                      .where(
                        (LeaderBoard item) => item.username
                            .toLowerCase()
                            .contains(query.toLowerCase()),
                      )
                      .toList();
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
                noFoundWidget: NoItemFound(
                  title: 'No items found',
                  icon: Icons.cancel,
                ),
                padding: EdgeInsets.all(8),
                contentPadding: EdgeInsets.all(16),
                textStyle: TextStyle(fontSize: 20),
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.list),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x4437474F)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                height: 600.0,
                child: Text("Random space"),
                alignment: Alignment.center,
                color: Colors.grey[200],
                padding: EdgeInsets.all(16.0),
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
