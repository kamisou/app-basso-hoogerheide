import 'dart:math';

import 'package:flutter/material.dart';

class SearchBar<T> extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.options,
    this.initialValue,
    this.label,
    this.onChanged,
    this.icon,
    this.validator,
    this.textInputAction,
    this.maxChoices = 5,
  });

  final IconData? icon;

  final int maxChoices;

  final T? initialValue;

  final List<T> options;

  final String? label;

  final void Function(T?)? onChanged;

  final String? Function(T?)? validator;

  final TextInputAction? textInputAction;

  @override
  State<SearchBar<T>> createState() => _SearchBarState<T>();
}

class _SearchBarState<T> extends State<SearchBar<T>> {
  final LayerLink _layerLink = LayerLink();

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  late OverlayState _overlayState;

  bool
      //
      _focused = false,
      _hasText = false,
      _hasOverlay = false;

  T? _selected;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    if (widget.initialValue != null) {
      _textEditingController.text = widget.initialValue.toString();
    }
    _focusNode.addListener(_focusNodeListener);
    _textEditingController.addListener(_textEditingControllerListener);
    _overlayState = Overlay.of(context)!;
  }

  void _focusNodeListener() {
    if (_focused != _focusNode.hasPrimaryFocus) {
      setState(() => _focused = _focusNode.hasPrimaryFocus);
    }
    if (!_focused) {
      _updateSelection();
    }
    _setOverlay();
  }

  void _textEditingControllerListener() {
    if (_hasText != _textEditingController.text.isNotEmpty) {
      setState(() => _hasText = _textEditingController.text.isNotEmpty);
    }
    if (_hasOverlay) {
      _overlayEntry!.markNeedsBuild();
    }
    _setOverlay();
  }

  void _setOverlay() {
    if (_focused) {
      _insertOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _insertOverlay() {
    if (!_hasOverlay) {
      final renderBox = context.findRenderObject()! as RenderBox;
      final Size size = renderBox.size;

      _overlayEntry ??= OverlayEntry(
        builder: (context) {
          Iterable<T> options = widget.options;

          if (_hasText) {
            options = options
                .where((option) => option
                    .toString()
                    .toUpperCase()
                    .startsWith(_textEditingController.text.toUpperCase()))
                .take(widget.maxChoices);
          }

          return Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 8),
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              child: Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Container(
                  height: 40.0 * min(widget.maxChoices, max(1, options.length)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: options.isNotEmpty
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemExtent: 40,
                          children: options
                              .map((option) => GestureDetector(
                                    onTap: () {
                                      _textEditingController.text =
                                          option.toString();
                                      _focusNode.unfocus();
                                      widget.onChanged?.call(option);
                                      _removeOverlay();
                                      _selected = option;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        option.toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          );
        },
      );
      _overlayState.insert(_overlayEntry!);
      _hasOverlay = true;
    }
  }

  void _removeOverlay() {
    if (_hasOverlay) {
      _overlayEntry?.remove();
      _hasOverlay = false;
      _focusNode.unfocus();
    }
  }

  void _updateSelection() {
    _selected = widget.options.cast<T?>().firstWhere(
          (option) =>
              option.toString().toUpperCase() ==
              _textEditingController.text.toUpperCase(),
          orElse: () => null,
        );
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _layerLink,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: widget.label,
                  prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
                ),
                keyboardType: TextInputType.text,
                enabled: widget.options.isNotEmpty,
                focusNode: _focusNode,
                validator: widget.validator != null
                    ? (_) => widget.validator!.call(_selected)
                    : null,
                onChanged: (_) => _updateSelection(),
                onEditingComplete: () {
                  _updateSelection();
                  _decideAction();
                },
                textInputAction: widget.textInputAction,
              ),
            ),
          ],
        ),
      );

  void _decideAction() {
    switch (widget.textInputAction) {
      case null:
      case TextInputAction.none:
      case TextInputAction.unspecified:
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.search:
      case TextInputAction.send:
      case TextInputAction.continueAction:
      case TextInputAction.join:
      case TextInputAction.route:
      case TextInputAction.emergencyCall:
        _focusNode.unfocus();
        break;
      case TextInputAction.next:
        _focusNode.nextFocus();
        break;
      case TextInputAction.previous:
        _focusNode.previousFocus();
        break;
      case TextInputAction.newline:
        break;
    }
  }
}
