import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onEditingComplete,
    this.autofocus = false,
  });

  final TextEditingController? controller;

  final String? hintText;

  final void Function(String)? onChanged;

  final VoidCallback? onEditingComplete;

  final bool autofocus;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final FocusNode _focusNode = FocusNode();

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autofocus,
      controller: _controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        hintText: widget.hintText,
        suffixIcon: const Icon(Icons.search),
      ),
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onEditingComplete: _onEditingComplete,
    );
  }

  void _onEditingComplete() {
    _focusNode.unfocus();
    widget.onEditingComplete?.call();
  }
}
