// import 'package:dashboard/src/common/services/responsive_content.dart';
// import 'package:flutter/material.dart';

// /// Configuración de un diálogo de alerta customizable.
// ///
// /// Permite control total sobre el diseño y comportamiento del diálogo.
// /// Usa [CustomAlertDialog] para construir el widget o [showCustomAlertDialog]
// /// para mostrarlo directamente.
// @immutable
// class CustomAlertDialogConfig {
//   const CustomAlertDialogConfig({
//     this.title,
//     this.content,
//     this.child,
//     this.icon,
//     this.actions,
//     this.showCloseButton = true,
//     this.barrierDismissible = false,
//     this.maxWidthMobile,
//     this.maxWidthDesktop = 600,
//     this.maxHeight,
//     this.contentPadding,
//     this.actionsPadding,
//     this.iconPadding,
//     this.actionsAlignment = MainAxisAlignment.end,
//     this.shape,
//     this.backgroundColor,
//     this.scrollable = true,
//     this.insetPadding,
//   });

//   /// Título del diálogo (widget). Si es [String], se muestra como [Text].
//   final Widget? title;

//   /// Contenido principal. Si [child] no es null, tiene prioridad.
//   final Widget? content;

//   /// Contenido completo del diálogo. Si se usa, [title] y [content] se ignoran
//   /// y este widget ocupa todo el espacio del content del [AlertDialog].
//   final Widget? child;

//   /// Ícono o widget en la esquina superior.
//   final Widget? icon;

//   /// Botones de acción en la parte inferior.
//   final List<Widget>? actions;

//   /// Si mostrar botón de cerrar (X).
//   final bool showCloseButton;

//   /// Si se puede cerrar tocando fuera del diálogo.
//   final bool barrierDismissible;

//   /// Ancho máximo en móvil.
//   final double? maxWidthMobile;

//   /// Ancho máximo en desktop.
//   final double? maxWidthDesktop;

//   /// Alto máximo.
//   final double? maxHeight;

//   /// Padding del contenido.
//   final EdgeInsets? contentPadding;

//   /// Padding del área de acciones.
//   final EdgeInsets? actionsPadding;

//   /// Padding del ícono.
//   final EdgeInsets? iconPadding;

//   /// Alineación de los botones de acción.
//   final MainAxisAlignment actionsAlignment;

//   /// Forma/borde del diálogo.
//   final ShapeBorder? shape;

//   /// Color de fondo.
//   final Color? backgroundColor;

//   /// Si el contenido debe ser scrolleable.
//   final bool scrollable;

//   /// Padding del inset del diálogo respecto a la pantalla.
//   final EdgeInsets? insetPadding;

//   CustomAlertDialogConfig copyWith({
//     Widget? title,
//     Widget? content,
//     Widget? child,
//     Widget? icon,
//     List<Widget>? actions,
//     bool? showCloseButton,
//     bool? barrierDismissible,
//     double? maxWidthMobile,
//     double? maxWidthDesktop,
//     double? maxHeight,
//     EdgeInsets? contentPadding,
//     EdgeInsets? actionsPadding,
//     EdgeInsets? iconPadding,
//     MainAxisAlignment? actionsAlignment,
//     ShapeBorder? shape,
//     Color? backgroundColor,
//     bool? scrollable,
//     EdgeInsets? insetPadding,
//   }) {
//     return CustomAlertDialogConfig(
//       title: title ?? this.title,
//       content: content ?? this.content,
//       child: child ?? this.child,
//       icon: icon ?? this.icon,
//       actions: actions ?? this.actions,
//       showCloseButton: showCloseButton ?? this.showCloseButton,
//       barrierDismissible: barrierDismissible ?? this.barrierDismissible,
//       maxWidthMobile: maxWidthMobile ?? this.maxWidthMobile,
//       maxWidthDesktop: maxWidthDesktop ?? this.maxWidthDesktop,
//       maxHeight: maxHeight ?? this.maxHeight,
//       contentPadding: contentPadding ?? this.contentPadding,
//       actionsPadding: actionsPadding ?? this.actionsPadding,
//       iconPadding: iconPadding ?? this.iconPadding,
//       actionsAlignment: actionsAlignment ?? this.actionsAlignment,
//       shape: shape ?? this.shape,
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       scrollable: scrollable ?? this.scrollable,
//       insetPadding: insetPadding ?? this.insetPadding,
//     );
//   }
// }

// /// Diálogo de alerta altamente customizable.
// ///
// /// Usa [CustomAlertDialogConfig] o los parámetros directos para personalizar
// /// título, contenido, acciones, estilos y dimensiones.
// class CustomAlertDialog extends StatelessWidget {
//   const CustomAlertDialog({
//     super.key,
//     this.config = const CustomAlertDialogConfig(),
//     this.title,
//     this.content,
//     this.child,
//     this.icon,
//     this.actions,
//     this.showCloseButton,
//     this.maxWidthMobile,
//     this.maxWidthDesktop,
//     this.maxHeight,
//     this.contentPadding,
//     this.actionsPadding,
//     this.iconPadding,
//     this.actionsAlignment,
//     this.shape,
//     this.backgroundColor,
//     this.scrollable,
//     this.insetPadding,
//   });

//   /// Configuración base. Los parámetros directos tienen prioridad.
//   final CustomAlertDialogConfig config;

//   final Widget? title;
//   final Widget? content;
//   final Widget? child;
//   final Widget? icon;
//   final List<Widget>? actions;
//   final bool? showCloseButton;
//   final double? maxWidthMobile;
//   final double? maxWidthDesktop;
//   final double? maxHeight;
//   final EdgeInsets? contentPadding;
//   final EdgeInsets? actionsPadding;
//   final EdgeInsets? iconPadding;
//   final MainAxisAlignment? actionsAlignment;
//   final ShapeBorder? shape;
//   final Color? backgroundColor;
//   final bool? scrollable;
//   final EdgeInsets? insetPadding;

//   double? get _maxWidthMobile => maxWidthMobile ?? config.maxWidthMobile;
//   double? get _maxWidthDesktop => maxWidthDesktop ?? config.maxWidthDesktop;
//   double? get _maxHeight => maxHeight ?? config.maxHeight;
//   EdgeInsets get _contentPadding =>
//       contentPadding ?? config.contentPadding ?? EdgeInsets.zero;
//   EdgeInsets get _actionsPadding =>
//       actionsPadding ??
//       config.actionsPadding ??
//       const EdgeInsets.symmetric(vertical: 10, horizontal: 10);
//   EdgeInsets get _iconPadding =>
//       iconPadding ??
//       config.iconPadding ??
//       const EdgeInsets.only(top: 10, right: 4);
//   MainAxisAlignment get _actionsAlignment =>
//       actionsAlignment ?? config.actionsAlignment;
//   ShapeBorder? get _shape => shape ?? config.shape;
//   Color? get _backgroundColor => backgroundColor ?? config.backgroundColor;
//   EdgeInsets? get _insetPadding => insetPadding ?? config.insetPadding;

//   Widget? get _effectiveTitle => title ?? config.title;
//   Widget? get _effectiveIcon => icon ?? config.icon;
//   List<Widget>? get _effectiveActions => actions ?? config.actions;

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = Responsive.isMobile(context);
//     final screenHeight = MediaQuery.sizeOf(context).height;
//     final maxW = isMobile
//         ? (_maxWidthMobile ?? double.infinity)
//         : (_maxWidthDesktop ?? 600);
//     final maxH = _maxHeight ?? screenHeight;

//     // minWidth fuerza al diálogo a ocupar el ancho en desktop (el contenido
//     // usa mainAxisSize.min y no expande por sí solo)
//     final constraints = isMobile
//         ? BoxConstraints(maxWidth: maxW, maxHeight: maxH)
//         : BoxConstraints(minWidth: maxW, maxWidth: maxW, maxHeight: maxH);

//     return AlertDialog(
//       backgroundColor: _backgroundColor,
//       shape: _shape,
//       insetPadding: _insetPadding,
//       constraints: constraints,
//       iconPadding: _iconPadding,
//       actionsPadding: _actionsPadding,
//       actionsAlignment: _actionsAlignment,
//       icon: _effectiveIcon,
//       title: _effectiveTitle,
//       content: content ?? config.content,
//       actions: _effectiveActions,
//     );
//   }
// }

// /// Muestra un diálogo de alerta customizable.
// ///
// /// [content]: contenido del diálogo (ej. formularios, modales de selección).
// /// Ocupa todo el contenido del diálogo.
// ///
// /// [barrierDismissible]: si false, no se cierra al tocar fuera (default false).
// /// [maxWidthMobile]: ancho máximo en móvil; null = sin límite.
// /// [maxWidthDesktop]: ancho máximo en desktop; null = 600.
// /// [maxHeight]: alto máximo; null = alto de la pantalla.
// ///
// /// Para más control, usa [CustomAlertDialog] con [CustomAlertDialogConfig].
// Future<T?> showCustomAlertDialog<T>(
//   BuildContext context, {
//   required Widget content,
//   Widget? title,
//   Widget? icon,
//   List<Widget>? actions,
//   bool showCloseButton = true,
//   bool barrierDismissible = false,
//   double? maxWidthMobile,
//   double? maxWidthDesktop = 600,
//   double? maxHeight,
//   EdgeInsets? contentPadding,
//   EdgeInsets? actionsPadding,
//   EdgeInsets? iconPadding,
//   MainAxisAlignment actionsAlignment = MainAxisAlignment.end,
//   ShapeBorder? shape,
//   Color? backgroundColor,
//   bool scrollable = true,
//   EdgeInsets? insetPadding,
// }) {
//   return showDialog<T>(
//     context: context,
//     barrierDismissible: barrierDismissible,
//     builder: (dialogContext) {
//       return CustomAlertDialog(
//         config: CustomAlertDialogConfig(
//           barrierDismissible: barrierDismissible,
//           maxWidthMobile: maxWidthMobile,
//           maxWidthDesktop: maxWidthDesktop,
//           maxHeight: maxHeight,
//         ),
//         title: title,
//         content: content,
//         icon: icon,
//         actions: actions,
//         showCloseButton: showCloseButton,
//         contentPadding: contentPadding,
//         actionsPadding: actionsPadding,
//         iconPadding: iconPadding,
//         actionsAlignment: actionsAlignment,
//         shape: shape,
//         backgroundColor: backgroundColor,
//         scrollable: scrollable,
//         insetPadding: insetPadding,
//       );
//     },
//   );
// }
