import 'dart:developer';

import 'package:dashboard/src/common/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers =
    void Function(List<TextEditingController?> controllers);

class CustomOtpTextField extends StatefulWidget {
  CustomOtpTextField({
    super.key,
    this.showCursor = true,
    this.numberOfFields = 4,
    this.fieldWidth = 40.0,
    this.fieldHeight,
    this.alignment,
    this.margin = const EdgeInsets.only(right: 8),
    this.textStyle,
    this.clearText = false,
    this.styles = const [],
    this.keyboardType = TextInputType.number,
    this.borderWidth = 2.0,
    this.cursorColor,
    this.disabledBorderColor,
    this.enabledBorderColor,
    this.borderColor,
    this.focusedBorderColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.handleControllers,
    this.onSubmit,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.autoFocus = false,
    this.hasCustomInputDecoration = false,
    this.filled,
    this.fillColor,
    this.readOnly = false,
    this.decoration,
    this.onCodeChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15),
  }) : assert(
         numberOfFields > 0,
         'El número de campos (numberOfFields) debe ser mayor a 0',
       ),
       assert(
         styles.isEmpty || styles.length == numberOfFields,
         'La lista de estilos debe tener la misma longitud que numberOfFields',
       );

  /// allows to show or disable cursor
  final bool showCursor;

  /// specify number of fields, defaults to 4
  final int numberOfFields;

  /// width of each text field
  final double fieldWidth;

  /// height of each text field
  final double? fieldHeight;

  /// border width of each text field
  final double borderWidth;

  /// aligns text fields in container
  final Alignment? alignment;

  /// color of enabled border
  final Color? enabledBorderColor;

  /// color of focused border
  final Color? focusedBorderColor;

  /// color of disabled border
  final Color? disabledBorderColor;

  /// handles color of border
  final Color? borderColor;

  /// handles color of cursor
  final Color? cursorColor;

  /// handles margin in between text fields
  final EdgeInsetsGeometry margin;

  /// controls keyboard type
  final TextInputType keyboardType;

  /// handles textStyle of digit in textField
  final TextStyle? textStyle;

  /// handles mainAxisAlignment of textFields in Row
  final MainAxisAlignment mainAxisAlignment;

  /// handles crossAxisAlignment of textFields in Row
  final CrossAxisAlignment crossAxisAlignment;

  /// callBack called when last textField is filled
  final OnCodeEnteredCompletion? onSubmit;

  /// callBack called when code in textField changes
  final OnCodeEnteredCompletion? onCodeChanged;

  /// textEditing controller handler
  final HandleControllers? handleControllers;

  /// handles visibility of text in textField
  final bool obscureText;

  /// if true, uses outlineBorder, if false underlineBorder
  final bool showFieldAsBox;

  /// if true, sets textFields to enabled
  final bool enabled;

  /// If true the decoration's container is filled with [fillColor].
  final bool? filled;

  /// handles autoFocus
  final bool autoFocus;

  /// if true, sets content of textField to be readOnly
  final bool readOnly;

  /// clears text
  final bool clearText;

  /// if true, custom Input decoration that is passed in takes effect
  final bool hasCustomInputDecoration;

  /// sets fill color of textField
  final Color? fillColor;

  /// sets borderRadius of textField
  final BorderRadius borderRadius;

  /// sets InputDecoration
  final InputDecoration? decoration;

  /// sets custom styles for textFields
  final List<TextStyle?> styles;

  /// sets inputFormatters for textFields
  final List<TextInputFormatter>? inputFormatters;

  /// handles contentPadding for each textField
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<CustomOtpTextField> createState() => _CustomOtpTextFieldState();
}

class _CustomOtpTextFieldState extends State<CustomOtpTextField> {
  late List<String?> _verificationCode;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  @override
  void initState() {
    super.initState();

    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);
    _textControllers = List<TextEditingController?>.filled(
      widget.numberOfFields,
      null,
    );
  }

  @override
  void didUpdateWidget(covariant CustomOtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clearText != widget.clearText && widget.clearText == true) {
      for (final controller in _textControllers) {
        controller?.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final controller in _textControllers) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _generateTextFields(context);
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
    TextStyle? style,
  }) {
    return Container(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      alignment: widget.alignment,
      margin: widget.margin,
      child: CustomTextField(
        // showCursor: widget.showCursor,
        contentPadding: EdgeInsets.zero,
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        maxLength: widget.numberOfFields,
        readOnly: widget.readOnly,
        style: style ?? widget.textStyle,

        // autofocus: widget.autoFocus,
        // cursorColor: widget.cursorColor,
        controller: _textControllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        decoration: widget.hasCustomInputDecoration
            ? widget.decoration
            : InputDecoration(
                counterText: '',
                filled: widget.filled,
                fillColor: widget.fillColor,
                contentPadding: widget.contentPadding,
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
        obscureText: widget.obscureText,
        onChanged: (String value) {
          if (value.length <= 1) {
            _verificationCode[index] = value;
            _onDigitEntered(value, index);
          } else {
            _handlePaste(value, index);
          }
        },
      ),
    );
  }

  // OutlineInputBorder _outlineBorder(Color color) {
  //   return OutlineInputBorder(
  //     borderSide: BorderSide(
  //       width: widget.borderWidth,
  //       color: color,
  //     ),
  //     borderRadius: widget.borderRadius,
  //   );
  // }

  // UnderlineInputBorder _underlineInputBorder(Color color) {
  //   return UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: color,
  //       width: widget.borderWidth,
  //     ),
  //   );
  // }

  Widget _generateTextFields(BuildContext context) {
    final textFields = List<Widget>.generate(widget.numberOfFields, (int i) {
      _addFocusNodeToEachTextField(index: i);
      _addTextEditingControllerToEachTextField(index: i);

      if (widget.styles.isNotEmpty) {
        return _buildTextField(
          context: context,
          index: i,
          style: widget.styles[i],
        );
      }
      widget.handleControllers?.call(_textControllers);
      return _buildTextField(context: context, index: i);
    });

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: textFields,
    );
  }

  void _addFocusNodeToEachTextField({required int index}) {
    if (_focusNodes[index] == null) {
      _focusNodes[index] = FocusNode();
    }
  }

  void _addTextEditingControllerToEachTextField({required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();

      _textControllers[index]!.addListener(() {
        final text = _textControllers[index]!.text;
        if (text.isEmpty) {
          // Handle backspace by moving focus to the previous field
          _changeFocusToPreviousNode(index);
        }
      });
    }
  }

  void _changeFocusToPreviousNode(int index) {
    try {
      if (index > 0 && index < widget.numberOfFields) {
        _focusNodes[index - 1]?.requestFocus();
      }
    } on Exception catch (_) {
      // Log an error if focus cannot be moved
      log('Cannot focus on the previous field');
    }
  }

  void _changeFocusToNextNodeWhenValueIsEntered({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the next textField if the value entered has a length
    //greater than one
    if (value.isNotEmpty) {
      //if the textField in focus is not the last textField,
      // change focus to the next textField
      if (indexOfTextField + 1 != widget.numberOfFields) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
      } else {
        //if the textField in focus is the last textField, unFocus after text
        //changed
        _focusNodes[indexOfTextField]?.unfocus();
      }
    }
  }

  void _onSubmit({required List<String?> verificationCode}) {
    if (verificationCode.every((String? code) => code != null && code != '')) {
      widget.onSubmit?.call(verificationCode.join());
    }
  }

  void _onCodeChanged({required String verificationCode}) {
    widget.onCodeChanged?.call(verificationCode);
  }

  void _onDigitEntered(String digit, int index) {
    _onCodeChanged(verificationCode: digit);
    _changeFocusToNextNodeWhenValueIsEntered(
      value: digit,
      indexOfTextField: index,
    );
    setState(() {
      _onSubmit(verificationCode: _verificationCode);
    });
  }

  /// this is called when a particular text field has more than one character
  /// this will normally happen in 2 instances
  /// 1. when a user pastes a string in the text field
  /// 2. when a user types more than one character in a field
  void _handlePaste(String str, int index) {
    // 1. SOLUCIÓN AL ERROR: Usamos una variable local
    // En lugar de modificar 'str', creamos 'pastedText'
    var pastedText = str;

    if (pastedText.length > widget.numberOfFields) {
      pastedText = pastedText.substring(0, widget.numberOfFields);
    }

    var textFieldIndex = index;

    // 2. Iteramos sobre la nueva variable 'pastedText'
    for (var i = 0; i < pastedText.length; i++) {
      if (textFieldIndex >= widget.numberOfFields) break;

      // Extraer el caracter actual
      final digit = pastedText.substring(i, i + 1);

      // Actualizar el controlador
      _textControllers[textFieldIndex]!.text = digit;

      // Nota: No necesitas establecer .value manualmente si ya estableciste
      // .text

      // Actualizar el array de código
      _verificationCode[textFieldIndex] = digit;

      _onDigitEntered(digit, textFieldIndex);
      textFieldIndex += 1;
    }

    // 3. OPTIMIZACIÓN: El setState va FUERA del loop
    // Así solo redibujamos la pantalla una vez al terminar de pegar
    setState(() {});
  }
}
