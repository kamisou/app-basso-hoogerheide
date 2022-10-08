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

class AsyncCollection<T> extends StatefulWidget {
  const AsyncCollection({
    super.key,
    required this.asyncCollection,
    required this.itemBuilder,
    required this.errorWidget,
    required this.loadingWidget,
    required this.emptyWidget,
    this.onReachingEnd,
    this.onRefresh,
    this.spacing = 20,
  });

  final AsyncValue<List<T>> asyncCollection;

  final Widget Function(BuildContext, T) itemBuilder;

  final Widget Function(Object) errorWidget;

  final Widget loadingWidget;

  final Widget emptyWidget;

  final Future<void> Function(VoidCallback finishFetching)? onReachingEnd;

  final Future<void> Function()? onRefresh;

  final double spacing;

  @override
  State<AsyncCollection<T>> createState() => _AsyncCollectionState<T>();
}

class _AsyncCollectionState<T> extends State<AsyncCollection<T>> {
  static const int _extentAfterEndTrigger = 120;

  final ScrollController _controller = ScrollController();

  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (_controller.hasClients &&
        _controller.position.extentAfter <= _extentAfterEndTrigger &&
        !_fetching) {
      setState(() => _fetching = true);
      widget.onReachingEnd?.call(_finishFetching);
    }
  }

  void _finishFetching() => setState(() => _fetching = false);

  @override
  Widget build(BuildContext context) {
    final refresh = widget.onRefresh ?? () async {};
    return widget.asyncCollection.when(
      data: (data) => RefreshIndicator(
        onRefresh: refresh,
        child: data.isNotEmpty
            ? ListView.separated(
                controller: _controller,
                itemCount: _fetching ? data.length + 1 : data.length,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: widget.spacing,
                ),
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator(),
                    );
                  }
                  return widget.itemBuilder(context, data[index]);
                },
                separatorBuilder: (_, index) =>
                    SizedBox(height: widget.spacing),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [widget.emptyWidget]),
                ),
              ),
      ),
      error: (error, _) => RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [widget.errorWidget(error)]),
        ),
      ),
      loading: () => widget.loadingWidget,
    );
  }
}
