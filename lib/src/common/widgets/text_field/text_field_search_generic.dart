import 'dart:async';
import 'package:dashboard/src/common/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class TextFieldSearchGeneric extends StatefulWidget {
  const TextFieldSearchGeneric({
    this.focusNode,
    this.callback,
    this.hintText = 'Buscar',
    this.initialText,
    this.voiceActive = true,
    this.debounceTime = 1200,
    this.controller,
    this.hintStyle,
    this.minCharsForSearch = 0, // Nuevo parámetro
    super.key,
  });

  final FocusNode? focusNode;
  final String hintText;
  final String? initialText;
  final void Function(String)? callback;
  final bool voiceActive;
  final int debounceTime;
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final int minCharsForSearch; // Mínimo de caracteres para disparar la búsqueda

  @override
  State<TextFieldSearchGeneric> createState() => _TextFieldSearchGenericState();
}

class _TextFieldSearchGenericState extends State<TextFieldSearchGeneric> {
  late TextEditingController searchController;
  late FocusNode focusNode;
  Timer? debounce;
  bool _isProgrammaticChange = false;
  bool _hasManualInput = false; // Nuevo flag para controlar input manual

  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();

    if (widget.initialText != null) {
      searchController.text = widget.initialText!;
    }

    focusNode.addListener(_onFocusChanged); // Listener para cambios de foco
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    focusNode.removeListener(_onFocusChanged);
    debounce?.cancel();
    if (widget.controller == null) {
      searchController.dispose();
    }
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    // Solo marca como input manual cuando el campo gana foco y el usuario
    // escribe
    if (focusNode.hasFocus) {
      _hasManualInput = false;
    }
  }

  void clearSearchController() {
    _isProgrammaticChange = true;
    searchController.clear();
    _hasManualInput = false;
    setState(() {});
    widget.callback?.call('');
    _isProgrammaticChange = false;
  }

  void _onSearchChanged() {
    if (_isProgrammaticChange) return;

    // Marca que hubo input manual cuando se detecta un cambio con el foco
    // activo
    if (focusNode.hasFocus && searchController.text.isNotEmpty) {
      _hasManualInput = true;
    }

    setState(() {}); // Actualiza la UI para el icono de limpiar

    // Cancela el timer anterior si existe
    debounce?.cancel();

    // Solo dispara la búsqueda si:
    // 1. Hay texto y se alcanzó el mínimo de caracteres, o se borró todo el
    // texto
    // 2. Fue un input manual (no solo el foco)
    final text = searchController.text;
    final shouldSearch =
        _hasManualInput &&
        (text.isEmpty || text.length >= widget.minCharsForSearch);

    if (shouldSearch) {
      debounce = Timer(Duration(milliseconds: widget.debounceTime), () {
        widget.callback?.call(text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      focusNode: focusNode,

      controller: searchController,
      onTapOutSide: (_) => FocusScope.of(context).unfocus(),
      hintText: widget.hintText,
      prefixIcon: const Icon(Icons.search, size: 20),
      suffixIcon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: searchController.text.isNotEmpty
            ? IconButton(
                key: const ValueKey('clear_icon'),
                onPressed: clearSearchController,
                icon: const Icon(Icons.close),
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}
