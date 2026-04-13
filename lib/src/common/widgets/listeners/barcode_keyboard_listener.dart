import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Un widget que escucha eventos de teclado globalmente para interceptar
/// las lecturas de los escáneres físicos de códigos de barras (los cuales
/// se comportan como un teclado rapido seguido de un Enter).
class BarcodeKeyboardListener extends StatefulWidget {
  const BarcodeKeyboardListener({
    required this.child,
    required this.onBarcodeScanned,
    this.bufferDuration = const Duration(milliseconds: 50),
    this.useKeyDownEvent = false,
    super.key,
  });

  /// El widget que será envuelto por el listener. Usualmente la pantalla
  /// completa del POS o el panel del catálogo.
  final Widget child;

  /// Se ejecuta cuando se detecta un escaneo completo (caracteres + Enter).
  final ValueChanged<String> onBarcodeScanned;

  /// La duración máxima entre pulsaciones de tecla para considerarlo un
  /// escáner. Un escáner típico inyecta teclas muy rápido (<50ms).
  final Duration bufferDuration;

  /// Si es true, escucha el evento `KeyDownEvent` en lugar de `KeyUpEvent`.
  final bool useKeyDownEvent;

  @override
  State<BarcodeKeyboardListener> createState() =>
      _BarcodeKeyboardListenerState();
}

class _BarcodeKeyboardListenerState extends State<BarcodeKeyboardListener> {
  String _barcodeBuffer = '';
  DateTime? _lastKeyPress;
  Timer? _throttleTimer;

  bool _handleKeyEvent(KeyEvent event) {
    if ((widget.useKeyDownEvent && event is KeyDownEvent) ||
        (!widget.useKeyDownEvent && event is KeyUpEvent)) {
      final now = DateTime.now();
      if (_lastKeyPress != null &&
          now.difference(_lastKeyPress!) > widget.bufferDuration) {
        // Excedió el tiempo permitido entre teclas, no es un scanner.
        _barcodeBuffer = '';
      }
      _lastKeyPress = now;

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_barcodeBuffer.isNotEmpty) {
          final scannedCode = _barcodeBuffer;
          _barcodeBuffer = '';

          // Entregamos el código escaneado
          widget.onBarcodeScanned(scannedCode);

          // Tratar de consumir el evento de "Enter"
          return true;
        }
      } else {
        if (event.character != null && event.character!.isNotEmpty) {
          _barcodeBuffer += event.character!;
          // Para un escáner rápido, no queremos consumir cada tecla en caso
          // de que el usuario en verdad esté tecleando manual muy rápido.
          // Pero si queremos evitar que aparezca en el TextField, idealmente
          // deberíamos usar un FocusNode con onKeyEvent, lo cual es complejo
          // a nivel global. El HardwareKeyboard listener es pasivo.
        }
      }
    }
    return false; // No consumed
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
