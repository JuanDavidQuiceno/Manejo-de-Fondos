import 'package:flutter/material.dart';

/// A ListView that handles pagination scroll detection automatically.
///
/// This widget encapsulates the common pattern of:
/// - Managing a ScrollController
/// - Detecting when the user scrolls near the bottom
/// - Triggering a load more callback
/// - Showing a loading indicator at the bottom
///
/// Usage:
/// ```dart
/// PaginatedListView<SaleModel>(
///   items: sales,
///   hasMore: state.hasMore,
///   isLoadingMore: state is SalesLoadingMore,
///   onLoadMore: () => cubit.loadMore(),
///   itemBuilder: (context, sale, index) => SaleItem(sale: sale),
///   separatorBuilder: (context, index) => const SizedBox(height: 12),
/// )
/// ```
class PaginatedListView<T> extends StatefulWidget {
  /// Creates a paginated list view.
  const PaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.scrollController,
    this.padding,
    this.separatorBuilder,
    this.loadingWidget,
    this.emptyWidget,
    this.loadMoreThreshold = 200.0,
    this.shrinkWrap = false,
    this.physics,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.key,
  });

  /// The list of items to display.
  final List<T> items;

  /// Builder function for each item.
  /// Receives the context, the item, and its index.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Callback triggered when more items should be loaded.
  final VoidCallback onLoadMore;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Whether a load more operation is currently in progress.
  final bool isLoadingMore;

  /// Optional external scroll controller.
  /// If not provided, an internal controller will be created.
  final ScrollController? scrollController;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Builder for separators between items.
  /// If provided, uses ListView.separated internally.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Custom widget to show while loading more items.
  /// Defaults to a centered CircularProgressIndicator.
  final Widget? loadingWidget;

  /// Widget to show when the list is empty.
  /// If null, an empty container is shown.
  final Widget? emptyWidget;

  /// Distance from the bottom at which to trigger load more.
  /// Defaults to 200 pixels.
  final double loadMoreThreshold;

  /// Whether the list should shrink wrap its contents.
  final bool shrinkWrap;

  /// The scroll physics to use.
  final ScrollPhysics? physics;

  /// How to dismiss the keyboard when scrolling.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
      _ownsController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PaginatedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      _scrollController.removeListener(_onScroll);
      if (_ownsController) {
        _scrollController.dispose();
      }
      if (widget.scrollController != null) {
        _scrollController = widget.scrollController!;
        _ownsController = false;
      } else {
        _scrollController = ScrollController();
        _ownsController = true;
      }
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_ownsController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom && widget.hasMore && !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Don't trigger loadMore if there's not enough content to scroll
    // This prevents false positives when list is refreshed with fewer items
    if (maxScroll <= widget.loadMoreThreshold) return false;
    return currentScroll >= maxScroll - widget.loadMoreThreshold;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    final itemCount = widget.items.length + (widget.hasMore ? 1 : 0);

    if (widget.separatorBuilder != null) {
      return ListView.separated(
        controller: _scrollController,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        padding: widget.padding,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        itemCount: itemCount,
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: _buildItem,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      padding: widget.padding,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      itemCount: itemCount,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index >= widget.items.length) {
      return widget.loadingWidget ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
    }
    return widget.itemBuilder(context, widget.items[index], index);
  }
}
