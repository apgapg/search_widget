library search_widget;
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:async';

// https://github.com/apgapg/search_widget/issues/15

typedef QueryListItemBuilder<T> = Widget Function(T item);
typedef OnItemSelected<T> = void Function(T item);
typedef SelectedItemBuilder<T> = Widget Function(
  T item,
  VoidCallback deleteSelectedItem,
);
typedef QueryBuilder<T> = List<T> Function(
  String query,
  List<T> list,
);
typedef TextFieldBuilder = Widget Function(
  TextEditingController controller,
  FocusNode focus,
);

class SearchWidget<T> extends StatefulWidget {
  const SearchWidget({
    @required this.dataList,
    @required this.popupListItemBuilder,
    @required this.selectedItemBuilder,
    @required this.queryBuilder,
    Key key,
    this.onItemSelected,
    this.hideSearchBoxWhenItemSelected = false,
    this.listContainerHeight,
    this.noItemsFoundWidget,
    this.textFieldBuilder,
  }) : super(key: key);

  final List<T> dataList;
  final QueryListItemBuilder<T> popupListItemBuilder;
  final SelectedItemBuilder<T> selectedItemBuilder;
  final bool hideSearchBoxWhenItemSelected;
  final double listContainerHeight;
  final QueryBuilder<T> queryBuilder;
  final TextFieldBuilder textFieldBuilder;
  final Widget noItemsFoundWidget;

  final OnItemSelected<T> onItemSelected;

  @override
  MySingleChoiceSearchState<T> createState() => MySingleChoiceSearchState<T>();
}

class MySingleChoiceSearchState<T> extends State<SearchWidget<T>> {
  final _controller = TextEditingController();
  List<T> _list;
  List<T> _tempList;
  bool isFocused;
  FocusNode _focusNode;
  ValueNotifier<T> notifier;
  bool isRequiredCheckFailed;
  Widget textField;
  OverlayEntry overlayEntry;
  bool showTextBox = false;
  double listContainerHeight;
  final LayerLink _layerLink = LayerLink();
  final double textBoxHeight = 48;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _tempList = <T>[];
    notifier = ValueNotifier(null);
    _focusNode = FocusNode();
    isFocused = false;
    _list = List<T>.from(widget.dataList);
    _tempList.addAll(_list);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.clear();
        if (overlayEntry != null) {
          overlayEntry.remove();
        }
        overlayEntry = null;
      } else {
        _tempList
          ..clear()
          ..addAll(_list);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry.markNeedsBuild();
        }
      }
    });
    _controller.addListener(() {
      final text = _controller.text;
      if (text.trim().isNotEmpty) {
        _tempList.clear();
        final filterList = widget.queryBuilder(text, widget.dataList);
        if (filterList == null) {
          throw Exception(
            "Filtered List cannot be null. Pass empty list instead",
          );
        }
        _tempList.addAll(filterList);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry.markNeedsBuild();
        }
      } else {
        _tempList
          ..clear()
          ..addAll(_list);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry.markNeedsBuild();
        }
      }
    });
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        if (!visible) {
          _focusNode.unfocus();
        }
      },
    );
  }

  @override
  void didUpdateWidget(SearchWidget oldWidget) {
    if (oldWidget.dataList != widget.dataList) {
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    listContainerHeight =
        widget.listContainerHeight ?? MediaQuery.of(context).size.height / 4;
    textField = widget.textFieldBuilder != null
        ? widget.textFieldBuilder(_controller, _focusNode)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x4437474F),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: "Search here...",
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
              ),
            ),
          );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.hideSearchBoxWhenItemSelected && notifier.value != null)
          const SizedBox(height: 0)
        else
          CompositedTransformTarget(
            link: _layerLink,
            child: textField,
          ),
        if (notifier.value != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: widget.selectedItemBuilder(
              notifier.value,
              onDeleteSelectedItem,
            ),
          ),
      ],
    );
    return column;
  }

  void onDropDownItemTap(T item) {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    overlayEntry = null;
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      notifier.value = item;
      isFocused = false;
      isRequiredCheckFailed = false;
    });
    if (widget.onItemSelected != null) {
      widget.onItemSelected(item);
    }
  }

  void onTap() {
    final RenderBox textFieldRenderBox = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final width = textFieldRenderBox.size.width;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        textFieldRenderBox.localToGlobal(
          textFieldRenderBox.size.topLeft(Offset.zero),
          ancestor: overlay,
        ),
        textFieldRenderBox.localToGlobal(
          textFieldRenderBox.size.topRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    overlayEntry = OverlayEntry(
      builder: (context) {
        final height = MediaQuery.of(context).size.height;
        return Stack(
          children: <Widget>[
            Positioned.fill(
                child: GestureDetector(
              onTap: dismissMenu,
              child: Container(
                color: Colors.transparent,
              ),
            )),
            Positioned(
              left: position.left,
              width: width,
              child: CompositedTransformFollower(
                offset: Offset(
                  0,
                  height - position.bottom < listContainerHeight
                      ? (textBoxHeight + 6.0)
                      : -(listContainerHeight - 8.0),
                ),
                showWhenUnlinked: false,
                link: _layerLink,
                child: Container(
                  height: listContainerHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: _tempList.isNotEmpty
                        ? Scrollbar(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 1,
                              ),
                              itemBuilder: (context, index) => Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () =>
                                      onDropDownItemTap(_tempList[index]),
                                  child: widget.popupListItemBuilder(
                                    _tempList.elementAt(index),
                                  ),
                                ),
                              ),
                              itemCount: _tempList.length,
                            ),
                          )
                        : widget.noItemsFoundWidget != null
                            ? Center(
                                child: widget.noItemsFoundWidget,
                              )
                            : const NoItemFound(),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void onDeleteSelectedItem() {
    setState(() => notifier.value = null);
    if (widget.onItemSelected != null) {
      widget.onItemSelected(null);
    }
  }

  void dismissMenu() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    overlayEntry = null;
    super.dispose();
  }
}

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
          Icon(icon, size: 24, color: Colors.grey[900].withOpacity(0.7)),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[900].withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}


/// A base class to handle the subscribing events
class KeyboardVisibilitySubscriber {
  /// Called when a keyboard visibility event occurs
  /// Is only called when the state changes
  /// The [visible] parameter reflects the new visibility
  final Function(bool visible) onChange;

  /// Called when the keyboard appears
  final Function onShow;

  /// Called when the keyboard closes
  final Function onHide;

  /// Constructs a new [KeyboardVisibilitySubscriber]
  KeyboardVisibilitySubscriber({this.onChange, this.onShow, this.onHide});
}

/// The notification class that handles all information
class KeyboardVisibilityNotification {
  static const EventChannel _keyboardVisibilityStream =
      const EventChannel('flutter_keyboard_visibility');
  static Map<int, KeyboardVisibilitySubscriber> _list =
      Map<int, KeyboardVisibilitySubscriber>();
  static StreamSubscription _keyboardVisibilitySubscription;
  static int _currentIndex = 0;

  /// The current state of the keyboard visibility. Can be used without subscribing
  bool isKeyboardVisible = false;

  /// Constructs a new [KeyboardVisibilityNotification]
  KeyboardVisibilityNotification() {
    _keyboardVisibilitySubscription ??= _keyboardVisibilityStream
        .receiveBroadcastStream()
        .listen(onKeyboardEvent);
  }

  /// Internal function to handle native code channel communication
  void onKeyboardEvent(dynamic arg) {
    isKeyboardVisible = (arg as int) == 1;

    // send a message to all subscribers notifying them about the new state
    _list.forEach((subscriber, s) {
      try {
        if (s.onChange != null) {
          s.onChange(isKeyboardVisible);
        }
        if ((s.onShow != null) && isKeyboardVisible) {
          s.onShow();
        }
        if ((s.onHide != null) && !isKeyboardVisible) {
          s.onHide();
        }
      } catch (_) {}
    });
  }

  /// Subscribe to a keyboard visibility event
  /// [onChange] is called when a change of the visibility occurs
  /// [onShow] is called when the keyboard appears
  /// [onHide] is called when the keyboard disappears
  /// Returns a subscribing id that can be used to unsubscribe
  int addNewListener(
      {Function(bool) onChange, Function onShow, Function onHide}) {
    _list[_currentIndex] = KeyboardVisibilitySubscriber(
        onChange: onChange, onShow: onShow, onHide: onHide);
    return _currentIndex++;
  }

  /// Subscribe to a keyboard visibility event using a subscribing class [subscriber]
  /// Returns a subscribing id that can be used to unsubscribe
  int addNewSubscriber(KeyboardVisibilitySubscriber subscriber) {
    _list[_currentIndex] = subscriber;
    return _currentIndex++;
  }

  /// Unsubscribe from the keyboard visibility events
  /// [subscribingId] has to contain an id previously returned on add
  void removeListener(int subscribingId) {
    _list.remove(subscribingId);
  }

  /// Internal function to clear class on dispose
  dispose() {
    if (_list.length == 0) {
      _keyboardVisibilitySubscription?.cancel()?.catchError((e) {});
      _keyboardVisibilitySubscription = null;
    }
  }
}

