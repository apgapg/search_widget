# Search Widget [![GitHub stars](https://img.shields.io/github/stars/apgapg/search_widget.svg?style=social)](https://github.com/apgapg/search_widget) [![Twitter Follow](https://img.shields.io/twitter/url/https/@ayushpgupta.svg?style=social)](https://twitter.com/ayushpgupta) ![GitHub last commit](https://img.shields.io/github/last-commit/apgapg/search_widget.svg) [![Website shields.io](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://play.google.com/store/apps/details?id=com.coddu.flutterprofile)[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/apgapg/search_widget)


This Flutter package provides a Search Widget for selection an option from a data list. Provides filtering of items based on the search text.

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
   return PopupListItem(item);
 },
 selectedItemBuilder: (LeaderBoard selectedItem, deleteSelectedItem) {
   return SelectedItem(selectedItem,deleteSelectedItem);
 },
)
```
### Key Highlights
- Adaptive Popup Position to prevent popup getting hidden behind keyboard
<img src="https://raw.githubusercontent.com/apgapg/search_widget/master/src/s2.gif"  height = "400" alt="PieChart">

- Popup to scroll if this widget is used inside ScrollView so as to prevent popup getting hidden behind the soft keyboard
<img src="https://raw.githubusercontent.com/apgapg/search_widget/master/src/s3.gif"  height = "400" alt="PieChart">


# ⭐ Other Flutter Packages
- [pie_chart](https://pub.dartlang.org/packages/pie_chart)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/pie_chart.svg?style=social)](https://github.com/apgapg/pie_chart)  Flutter Pie Chart with cool animation.
- [avatar_glow](https://pub.dartlang.org/packages/avatar_glow)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/avatar_glow.svg?style=social)](https://github.com/apgapg/avatar_glow)  Flutter Avatar Glow Widget with glowing animation.

# 👍 Contribution
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -m 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
