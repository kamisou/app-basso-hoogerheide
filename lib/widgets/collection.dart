import 'package:flutter/material.dart';

class Collection<T> extends StatelessWidget {
  const Collection({
    super.key,
    required this.collection,
    required this.itemBuilder,
    required this.emptyWidget,
    this.spacing = 20,
  });

  final List<T> collection;

  final Widget Function(BuildContext, T) itemBuilder;

  final Widget emptyWidget;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return collection.isNotEmpty
        ? ListView.separated(
            itemCount: collection.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) =>
                itemBuilder(context, collection[index]),
            separatorBuilder: (_, index) => SizedBox(height: spacing),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: emptyWidget,
          );
  }
}
