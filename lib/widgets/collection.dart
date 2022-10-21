import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  final Future<void> Function(
    VoidCallback finishFetching,
    VoidCallback reachEnd,
  )? onReachingEnd;

  final Future<void> Function()? onRefresh;

  final double spacing;

  @override
  State<AsyncCollection<T>> createState() => _AsyncCollectionState<T>();
}

class _AsyncCollectionState<T> extends State<AsyncCollection<T>> {
  static const int _extentAfterEndTrigger = 120;

  final ScrollController _controller = ScrollController();

  bool _fetching = false;

  bool _reachedEnd = false;

  @override
  void initState() {
    super.initState();
    if (widget.onReachingEnd != null) {
      _controller.addListener(_onControllerChange);
    }
  }

  void _onControllerChange() {
    if (_controller.hasClients &&
        _controller.position.extentAfter <= _extentAfterEndTrigger &&
        !_fetching &&
        !_reachedEnd) {
      setState(() => _fetching = true);
      widget.onReachingEnd?.call(_finishFetching, _reachEnd);
    }
  }

  void _finishFetching() => setState(() => _fetching = false);

  void _reachEnd() => _reachedEnd = true;

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() {
      _fetching = false;
      _reachedEnd = false;
      return widget.onRefresh!.call();
    }

    return widget.asyncCollection.when(
      data: (data) {
        final Widget child = data.isNotEmpty
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
              );
        return widget.onRefresh != null
            ? RefreshIndicator(onRefresh: refresh, child: child)
            : child;
      },
      error: (error, _) {
        final Widget child = SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [widget.errorWidget(error)]),
        );
        return widget.onRefresh != null
            ? RefreshIndicator(onRefresh: refresh, child: child)
            : child;
      },
      loading: () => widget.loadingWidget,
    );
  }
}
