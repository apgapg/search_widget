# Search Widget [![GitHub stars](https://img.shields.io/github/stars/apgapg/search_widget.svg?style=social)](https://github.com/apgapg/search_widget) [![Twitter Follow](https://img.shields.io/twitter/url/https/@ayushpgupta.svg?style=social)](https://twitter.com/ayushpgupta) ![GitHub last commit](https://img.shields.io/github/last-commit/apgapg/search_widget.svg) [![Website shields.io](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://play.google.com/store/apps/details?id=com.coddu.flutterprofile)[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/apgapg/search_widget)


This Flutter package provides a Search Widget for selecting an option from a data list. Provides filtering of items based on the search text.

<img src="https://raw.githubusercontent.com/apgapg/search_widget/master/src/s1.gif"  height = "400" alt="PieChart">

# 💻 Installation
In the `dependencies:` section of your `pubspec.yaml`, add the following line:

[![Version](https://img.shields.io/pub/v/search_widget.svg)](https://pub.dartlang.org/packages/search_widget)

```yaml
dependencies:
  search_widget: <latest version>
```

# ❔ Usage

### Import this class

```dart
import 'package:search_widget/search_widget.dart';
```

### Add Search Widget
- Accepts data list as input
- Option for pop list item builder. This basically returns a widget to show as list item in popup
```dart
popupListItemBuilder: (LeaderBoard item) {
   return PopupListItem(item);
 }
```
- Option for filtering data list based on search query
```dart
queryBuilder: (String query, List<LeaderBoard> list) {
   return list.where((LeaderBoard item) => item.username.toLowerCase().contains(query.toLowerCase())).toList();
 }
```
- Option provided for selected list item builder which enables when a user selects an item from pop up list
```dart
selectedItemBuilder: (LeaderBoard selectedItem, deleteSelectedItem) {
   return SelectedItem(selectedItem,deleteSelectedItem);
 }
```
- Option for providing custom TextField. Accepts TextEditingController and FocusNode as parameter
```dart
textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        //... Other customizations here
       );
  },
```
### Full Implementation
```dart
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
)
```
### Key Highlights
- Adaptive Popup Position to prevent popup getting hidden behind keyboard   

<img src="https://raw.githubusercontent.com/apgapg/search_widget/master/src/s2.gif"  height = "400" alt="PieChart"> <img src="https://raw.githubusercontent.com/apgapg/search_widget/master/src/s1.gif" style="margin: 0px 4px"  height = "400" alt="PieChart">

  
- Popup to scroll with scroll gesture if this widget is used inside ScrollView  

<img src="https://raw.githubusercontent.com/apgapg/search_widget/master/src/s3.gif"  height = "400" alt="PieChart">

## TODO

- [ ] Add support for selecting multiple items
- [ ] Add visibility bool to show selected item widget
- [ ] Give support for onSelectedItem method to return selected item(s) directly

# ⭐ My Flutter Packages
- [pie_chart](https://pub.dartlang.org/packages/pie_chart)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/pie_chart.svg?style=social)](https://github.com/apgapg/pie_chart)  Flutter Pie Chart with cool animation.
- [avatar_glow](https://pub.dartlang.org/packages/avatar_glow)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/avatar_glow.svg?style=social)](https://github.com/apgapg/avatar_glow)  Flutter Avatar Glow Widget with glowing animation.

# ⭐ My Flutter Apps
- [flutter_profile](https://github.com/apgapg/flutter_profile)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/flutter_profile.svg?style=social)](https://github.com/apgapg/flutter_profile)  Showcase My Portfolio: Ayush P Gupta on Playstore.
- [flutter_sankalan](https://github.com/apgapg/flutter_sankalan)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/flutter_sankalan.svg?style=social)](https://github.com/apgapg/flutter_sankalan)  Flutter App which allows reading/uploading short stories.


# 👍 Contribution
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -m 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
