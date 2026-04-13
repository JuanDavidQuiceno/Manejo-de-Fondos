import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Botón moderno con animación de escala al presionar.
class CustomButtonV2 extends StatefulWidget {
  const CustomButtonV2({
    required this.text,
    super.key,
    this.tooltip,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isOutlined = false,
    this.isExpanded = false,
    this.isLoading = false,
    this.isText = false,
  });

  final String text;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isOutlined;
  final bool isExpanded;
  final bool isLoading;
  final bool isText;

  @override
  State<CustomButtonV2> createState() => _CustomButtonV2State();
}

class _CustomButtonV2State extends State<CustomButtonV2>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (_isEnabled) _controller.forward();
  }

  void _onTapUp(TapUpDetails _) => _controller.reverse();

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppColors.primary;
    final fgColor = widget.foregroundColor ?? AppColors.white;

    final button = GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: widget.isText
              ? null
              : BoxDecoration(
                  color: widget.isOutlined
                      ? Colors.transparent
                      : (_isEnabled ? bgColor : AppColors.gray300),
                  borderRadius: BorderRadius.circular(10),
                  border: widget.isOutlined
                      ? Border.all(
                          color: _isEnabled ? bgColor : AppColors.gray300,
                          width: 1.5,
                        )
                      : null,
                  boxShadow: widget.isOutlined || !_isEnabled
                      ? null
                      : [
                          BoxShadow(
                            color: bgColor.withAlpha(40),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isEnabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: _buildContent(fgColor, bgColor),
              ),
            ),
          ),
        ),
      ),
    );

    Widget result = button;

    final tooltipText = widget.tooltip ?? widget.text;
    if (tooltipText.isNotEmpty) {
      result = Tooltip(
        message: tooltipText,
        waitDuration: const Duration(milliseconds: 500),
        child: button,
      );
    }

    if (widget.isExpanded) {
      return Row(children: [Expanded(child: result)]);
    }

    return result;
  }

  Widget _buildContent(Color fgColor, Color bgColor) {
    final color = widget.isOutlined
        ? (_isEnabled ? bgColor : AppColors.gray400)
        : (_isEnabled ? fgColor : AppColors.gray500);

    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(color: color, size: 20),
            child: widget.icon!,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.text,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
