import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class AsyncCollection<T> extends StatelessWidget {
  const AsyncCollection({
    super.key,
    required this.asyncCollection,
    required this.itemBuilder,
    required this.errorWidget,
    required this.loadingWidget,
    required this.emptyWidget,
    this.onRefresh,
    this.spacing = 20,
  });

  final AsyncValue<List<T>> asyncCollection;

  final Widget Function(BuildContext, T) itemBuilder;

  final Widget Function(Object) errorWidget;

  final Widget loadingWidget;

  final Widget emptyWidget;

  final Future<void> Function()? onRefresh;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final refresh = onRefresh ?? () async {};
    return asyncCollection.when(
      data: (data) => RefreshIndicator(
        onRefresh: refresh,
        child: data.isNotEmpty
            ? ListView.separated(
                itemCount: data.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) =>
                    itemBuilder(context, data[index]),
                separatorBuilder: (_, index) => SizedBox(height: spacing),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: emptyWidget,
                ),
              ),
      ),
      error: (error, _) => RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: errorWidget(error),
        ),
      ),
      loading: () => loadingWidget,
    );
  }
}
