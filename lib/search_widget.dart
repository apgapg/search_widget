library search_widget;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

import 'widget/no_item_found.dart';

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
  FocusNode? focus,
);

class SearchWidget<T> extends StatefulWidget {
  const SearchWidget({
    required this.dataList,
    required this.popupListItemBuilder,
    required this.selectedItemBuilder,
    required this.queryBuilder,
    Key? key,
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
  final double? listContainerHeight;
  final QueryBuilder<T> queryBuilder;
  final TextFieldBuilder? textFieldBuilder;
  final Widget? noItemsFoundWidget;

  final OnItemSelected<T?>? onItemSelected;

  @override
  MySingleChoiceSearchState<T> createState() => MySingleChoiceSearchState<T>();
}

class MySingleChoiceSearchState<T> extends State<SearchWidget<T>> {
  final _controller = TextEditingController();
  late List<T> _list;
  late List<T> _tempList;
  bool? isFocused;
  FocusNode? _focusNode;
  late ValueNotifier<T?> notifier;
  bool? isRequiredCheckFailed;
  Widget? textField;
  OverlayEntry? overlayEntry;
  bool showTextBox = false;
  double? listContainerHeight;
  final LayerLink _layerLink = LayerLink();
  final double textBoxHeight = 48;
  final TextEditingController textController = TextEditingController();

  late StreamSubscription<bool> keyboardSubscription;

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
    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus) {
        _controller.clear();
        if (overlayEntry != null) {
          overlayEntry!.remove();
        }
        overlayEntry = null;
      } else {
        _tempList
          ..clear()
          ..addAll(_list);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry!.markNeedsBuild();
        }
      }
    });
    _controller.addListener(() {
      final text = _controller.text;
      if (text.trim().isNotEmpty) {
        _tempList.clear();
        final filterList = widget.queryBuilder(text, widget.dataList);
        _tempList.addAll(filterList);
        if (overlayEntry == null) {
          if (_focusNode!.hasFocus) {
            onTap();
          }
        } else {
          overlayEntry!.markNeedsBuild();
        }
      } else {
        _tempList
          ..clear()
          ..addAll(_list);
        if (overlayEntry == null) {
          onTap();
        } else {
          overlayEntry!.markNeedsBuild();
        }
      }
    });
    final keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        _focusNode?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayEntry = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchWidget oldWidget) {
    if (oldWidget.dataList != widget.dataList) {
      init();
    }
    super.didUpdateWidget(oldWidget as SearchWidget<T>);
  }

  @override
  Widget build(BuildContext context) {
    listContainerHeight =
        widget.listContainerHeight ?? MediaQuery.of(context).size.height / 4;
    textField = widget.textFieldBuilder != null
        ? widget.textFieldBuilder!(_controller, _focusNode)
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
                suffixIcon: const Icon(Icons.search),
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

    return Column(
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
              notifier.value!,
              onDeleteSelectedItem,
            ),
          ),
      ],
    );
  }

  void onDropDownItemTap(T item) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayEntry = null;
    _controller.clear();
    _focusNode!.unfocus();
    setState(() {
      notifier.value = item;
      isFocused = false;
      isRequiredCheckFailed = false;
    });
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

  void onTap() {
    final textFieldRenderBox = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
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
                  height - position.bottom < listContainerHeight!
                      ? (textBoxHeight + 6.0)
                      : -(listContainerHeight! - 8.0),
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
    Overlay.of(context)!.insert(overlayEntry!);
  }

  void onDeleteSelectedItem() {
    setState(() => notifier.value = null);
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(null);
    }
  }

  void dismissMenu() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      _controller.clear();
      _focusNode!.unfocus();
    }
  }
}
