import 'package:dashboard/src/common/widgets/containers/custom_card_container.dart';
import 'package:dashboard/src/common/widgets/modal/custom_modal_header.dart';
import 'package:dashboard/src/common/widgets/text_field/text_field_search_generic.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Modal genérico reutilizable para listas de selección (rol, estado,
/// empresa, sucursal). Unifica layout adaptativo en diálogo y sheet.
///
/// - [title]: título del modal.
/// - [searchHint]: hint del campo de búsqueda.
/// - [useDialogLayout]: true = diálogo centrado; false = bottom sheet.
/// - [onSearch]: callback al cambiar el texto de búsqueda.
/// - [listBuilder]: construye la lista (recibe scrollController y shrinkWrap).
/// - [buildActions]: construye la fila de botones (Cancelar / Confirmar).
/// - [sheetInitialChildSize], [sheetMinChildSize], [sheetMaxChildSize]:
///   parámetros del [DraggableScrollableSheet] cuando [useDialogLayout]
/// es false.
class AdaptiveSelectionModal extends StatefulWidget {
  const AdaptiveSelectionModal({
    required this.title,
    required this.searchHint,
    required this.useDialogLayout,
    required this.onSearch,
    required this.listBuilder,
    required this.buildActions,
    this.headerAction,
    this.sheetInitialChildSize = 0.85,
    this.sheetMinChildSize = 0.4,
    this.sheetMaxChildSize = 0.95,
    super.key,
  });

  final String title;
  final String searchHint;
  final bool useDialogLayout;
  final ValueChanged<String> onSearch;
  final Widget Function(
    ScrollController scrollController, {
    required bool shrinkWrap,
  })
  listBuilder;
  final Widget Function(BuildContext context) buildActions;

  /// Widget opcional que se muestra entre el título y el botón de cerrar.
  /// Útil para agregar botones como "Crear nuevo".
  final Widget? headerAction;
  final double sheetInitialChildSize;
  final double sheetMinChildSize;
  final double sheetMaxChildSize;

  @override
  State<AdaptiveSelectionModal> createState() => _AdaptiveSelectionModalState();
}

class _AdaptiveSelectionModalState extends State<AdaptiveSelectionModal> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context) {
    return CustomModalHeader(
      title: widget.title,
      headerAction: widget.headerAction,
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextFieldSearchGeneric(
            hintText: widget.searchHint,
            callback: widget.onSearch,
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: widget.listBuilder(scrollController, shrinkWrap: true),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, color: AppColors.gray200),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: widget.buildActions(context),
        ),
      ],
    );

    if (widget.useDialogLayout) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: column,
      );
    }
    return column;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useDialogLayout) {
      return _buildContent(_scrollController);
    }
    return DraggableScrollableSheet(
      initialChildSize: widget.sheetInitialChildSize,
      minChildSize: widget.sheetMinChildSize,
      maxChildSize: widget.sheetMaxChildSize,
      builder: (context, scrollController) {
        return CustomCardContainer(
          margin: const EdgeInsets.all(12),
          padding: EdgeInsets.zero,
          child: _buildContent(scrollController),
        );
      },
    );
  }
}
