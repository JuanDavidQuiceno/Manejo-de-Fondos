import 'package:flutter/material.dart';

/// A widget that wraps a scrollable and adds pagination scroll detection.
///
/// Use this when you need to add pagination to an existing scrollable widget
/// or when you need to control the ScrollController externally (e.g., for
/// CustomScrollView with complex slivers).
///
/// Usage:
/// ```dart
/// final scrollController = ScrollController();
///
/// ScrollPaginationListener(
///   scrollController: scrollController,
///   hasMore: state.hasMore,
///   isLoadingMore: state is LoadingMore,
///   onLoadMore: () => cubit.loadMore(),
///   child: CustomScrollView(
///     controller: scrollController,
///     slivers: [
///       SliverGrid(...),
///       PaginatedSliverFooter(hasMore: hasMore, isLoadingMore: isLoadingMore),
///     ],
///   ),
/// )
/// ```
class ScrollPaginationListener extends StatefulWidget {
  /// Creates a scroll pagination listener.
  const ScrollPaginationListener({
    required this.scrollController,
    required this.onLoadMore,
    required this.child,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.threshold = 200.0,
    super.key,
  });

  /// The scroll controller to monitor.
  final ScrollController scrollController;

  /// Callback triggered when more items should be loaded.
  final VoidCallback onLoadMore;

  /// The child widget (typically a scrollable).
  final Widget child;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Whether a load more operation is currently in progress.
  final bool isLoadingMore;

  /// Distance from the bottom at which to trigger load more.
  /// Defaults to 200 pixels.
  final double threshold;

  @override
  State<ScrollPaginationListener> createState() =>
      _ScrollPaginationListenerState();
}

class _ScrollPaginationListenerState extends State<ScrollPaginationListener> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ScrollPaginationListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    if (!widget.hasMore || widget.isLoadingMore) return;

    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    if (currentScroll >= maxScroll - widget.threshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
