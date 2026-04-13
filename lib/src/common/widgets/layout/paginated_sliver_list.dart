import 'package:flutter/material.dart';

/// A SliverList that includes a loading indicator when more items are
/// available.
///
/// Use this widget inside a CustomScrollView when you need pagination with
/// slivers (e.g., for grid layouts or complex scrolling scenarios).
///
/// Note: This widget does NOT handle scroll detection. Handle scroll detection
/// in the parent widget or use a scroll listener wrapper.
///
/// Usage:
/// ```dart
/// CustomScrollView(
///   controller: scrollController,
///   slivers: [
///     SliverPadding(
///       padding: EdgeInsets.all(16),
///       sliver: SliverGrid(
///         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(...),
///         delegate: SliverChildBuilderDelegate(
///           (context, index) => ItemWidget(item: items[index]),
///           childCount: items.length,
///         ),
///       ),
///     ),
///     PaginatedSliverFooter(
///       hasMore: hasMore,
///       isLoadingMore: isLoadingMore,
///     ),
///   ],
/// )
/// ```
class PaginatedSliverList<T> extends StatelessWidget {
  /// Creates a paginated sliver list.
  const PaginatedSliverList({
    required this.items,
    required this.itemBuilder,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.loadingWidget,
    super.key,
  });

  /// The list of items to display.
  final List<T> items;

  /// Builder function for each item.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Whether a load more operation is currently in progress.
  final bool isLoadingMore;

  /// Custom widget to show while loading more items.
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= items.length) {
          return loadingWidget ??
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
        }
        return itemBuilder(context, items[index], index);
      }, childCount: items.length + (hasMore ? 1 : 0)),
    );
  }
}

/// A simple sliver footer that shows a loading indicator when more items
/// are available.
///
/// Use this after your main sliver content (SliverList, SliverGrid, etc.)
/// to show a pagination loading indicator.
///
/// Usage:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverGrid(...),
///     PaginatedSliverFooter(
///       hasMore: hasMore,
///       isLoadingMore: isLoadingMore,
///     ),
///   ],
/// )
/// ```
class PaginatedSliverFooter extends StatelessWidget {
  /// Creates a paginated sliver footer.
  const PaginatedSliverFooter({
    this.hasMore = true,
    this.isLoadingMore = false,
    this.loadingWidget,
    this.padding = const EdgeInsets.symmetric(vertical: 32),
    super.key,
  });

  /// Whether there are more items to load.
  final bool hasMore;

  /// Whether a load more operation is currently in progress.
  final bool isLoadingMore;

  /// Custom widget to show while loading more items.
  final Widget? loadingWidget;

  /// Padding around the loading indicator.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (!hasMore && !isLoadingMore) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        child: isLoadingMore
            ? (loadingWidget ?? const CircularProgressIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }
}
