import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A mixin that provides utilities for parsing and rendering styled text
/// with inline decorators like bold, italic, colors, and links.
///
/// ## Supported Syntax:
///
/// | Decorator | Syntax | Example |
/// |-----------|--------|---------|
/// | Bold | `**text**` | `**Hello**` → **Hello** |
/// | Italic | `*text*` | `*Hello*` → *Hello* |
/// | Bold + Italic | `***text***` | `***Hello***` |
/// | Color | `{color:name}text{/color}` | `{color:primary}Hello{/color}` |
/// | Link | `{link:url}text{/link}` | `{link:https://...}Click{/link}` |
/// | Underline | `{u}text{/u}` | `{u}Hello{/u}` |
/// | Strikethrough | `{s}text{/s}` | `{s}Hello{/s}` |
/// | Line Break | `|` | `Line 1 | Line 2` |
///
/// ## Available Colors:
/// - `primary`, `secondary`, `error`, `success`, `warning`
/// - `grey`, `greyDark`, `greyLight`, `muted`
/// - `brand500`, `brand600`, `brand700`
/// - `purple500`, `purple600`, `white`, `black`
/// - Any hex color: `{color:#FF5733}text{/color}`
///
/// ## Usage Examples:
///
/// ### Example 1: Basic usage in a StatelessWidget
/// ```dart
/// class MyWidget extends StatelessWidget with StyledTextMixin {
///   @override
///   Widget build(BuildContext context) {
///     return buildStyledText(
///       'This is **bold** and *italic* text.',
///       baseStyle: Theme.of(context).textTheme.bodyMedium!,
///     );
///   }
/// }
/// ```
///
/// ### Example 2: Using with CustomSectionHeader
/// ```dart
/// CustomSectionHeader(
///   title: 'Consent to process data',
///   subtitle: 'By clicking **"Accept"**, you agree to: | '
///       '(1) Read and accept our {link:https://example.com/terms}'
///       'Terms of Service{/link}. | '
///       '(2) Grant consent to process your {color:primary}Biometric Data{/color}.',
/// )
/// ```
///
/// ### Example 3: Combining multiple styles
/// ```dart
/// buildStyledText(
///   'Welcome **{color:primary}John{/color}**! '
///   'Your subscription is {color:success}active{/color}. | '
///   'Next billing: {color:grey}January 15, 2025{/color}',
///   baseStyle: context.bodyMedium,
/// )
/// ```
///
/// ### Example 4: Using links with callbacks
/// ```dart
/// buildStyledText(
///   'Read our {link:privacy}Privacy Policy{/link} and '
///   '{link:terms}Terms of Service{/link}.',
///   baseStyle: context.bodyMedium,
///   onLinkTap: (url) {
///     if (url == 'privacy') {
///       context.push(AppRoutes.privacyPolicy);
///     } else if (url == 'terms') {
///       context.push(AppRoutes.termsOfService);
///     }
///   },
/// )
/// ```
///
/// ### Example 5: Error and warning messages
/// ```dart
/// buildStyledText(
///   '{color:error}**Error:**{/color} Your session has expired. | '
///   'Please {link:login}sign in again{/link}.',
///   baseStyle: context.bodyMedium,
///   onLinkTap: (_) => context.go(AppRoutes.login),
/// )
/// ```
///
/// ### Example 6: Legal/consent text with multiple paragraphs
/// ```dart
/// buildStyledText(
///   '**Personal Data:** If you consent, we will process: | '
///   '- Your {color:grey}biometric data{/color} | '
///   '- Your {color:grey}identification documents{/color} | '
///   '- Your {color:grey}facial scan{/color} | | '
///   'For more information, see our {link:https://example.com}Policy{/link}.',
///   baseStyle: context.bodySmall.copyWith(color: AppColors.textGrey),
/// )
/// ```
///
/// ### Example 7: Promotional text with hex colors
/// ```dart
/// buildStyledText(
///   '{color:#FFD700}**PREMIUM**{/color} members get '
///   '{color:primary}50% off{/color}! | '
///   '{s}Regular price: \$99{/s} → **\$49**',
///   baseStyle: context.bodyLarge,
/// )
/// ```
mixin StyledTextMixin {
  /// Parses a string with style decorators and returns a [TextSpan].
  ///
  /// [text] - The input string with style decorators.
  /// [baseStyle] - The default [TextStyle] to apply.
  /// [onLinkTap] - Optional callback when a link is tapped.
  TextSpan parseStyledText(
    String text, {
    required TextStyle baseStyle,
    void Function(String url)? onLinkTap,
  }) {
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    var i = 0;

    while (i < text.length) {
      // Check for bold+italic (***)
      if (_matchesAt(text, i, '***')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final endIndex = text.indexOf('***', i + 3);
        if (endIndex != -1) {
          final content = text.substring(i + 3, endIndex);
          spans.add(
            TextSpan(
              text: content,
              style: baseStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
          i = endIndex + 3;
          continue;
        }
      }

      // Check for bold (**)
      if (_matchesAt(text, i, '**')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final endIndex = _findClosingTag(text, i + 2, '**');
        if (endIndex != -1) {
          final content = text.substring(i + 2, endIndex);
          final nestedSpan = parseStyledText(
            content,
            baseStyle: baseStyle.copyWith(fontWeight: FontWeight.bold),
            onLinkTap: onLinkTap,
          );
          spans.add(nestedSpan);
          i = endIndex + 2;
          continue;
        }
      }

      // Check for italic (*)
      if (text[i] == '*' && !_matchesAt(text, i, '**')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final endIndex = _findClosingTag(text, i + 1, '*');
        if (endIndex != -1) {
          final content = text.substring(i + 1, endIndex);
          final nestedSpan = parseStyledText(
            content,
            baseStyle: baseStyle.copyWith(fontStyle: FontStyle.italic),
            onLinkTap: onLinkTap,
          );
          spans.add(nestedSpan);
          i = endIndex + 1;
          continue;
        }
      }

      // Check for color tag {color:name}...{/color}
      if (_matchesAt(text, i, '{color:')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final colorEndIndex = text.indexOf('}', i);
        if (colorEndIndex != -1) {
          final colorName = text.substring(i + 7, colorEndIndex);
          final contentStart = colorEndIndex + 1;
          final closingTag = text.indexOf('{/color}', contentStart);
          if (closingTag != -1) {
            final content = text.substring(contentStart, closingTag);
            final color = _parseColor(colorName);
            final nestedSpan = parseStyledText(
              content,
              baseStyle: baseStyle.copyWith(color: color),
              onLinkTap: onLinkTap,
            );
            spans.add(nestedSpan);
            i = closingTag + 8;
            continue;
          }
        }
      }

      // Check for link tag {link:url}...{/link}
      if (_matchesAt(text, i, '{link:')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final urlEndIndex = text.indexOf('}', i);
        if (urlEndIndex != -1) {
          final url = text.substring(i + 6, urlEndIndex);
          final contentStart = urlEndIndex + 1;
          final closingTag = text.indexOf('{/link}', contentStart);
          if (closingTag != -1) {
            final content = text.substring(contentStart, closingTag);
            spans.add(
              TextSpan(
                text: content,
                style: baseStyle.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => onLinkTap?.call(url),
              ),
            );
            i = closingTag + 7;
            continue;
          }
        }
      }

      // Check for underline {u}...{/u}
      if (_matchesAt(text, i, '{u}')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final closingTag = text.indexOf('{/u}', i + 3);
        if (closingTag != -1) {
          final content = text.substring(i + 3, closingTag);
          final nestedSpan = parseStyledText(
            content,
            baseStyle: baseStyle.copyWith(decoration: TextDecoration.underline),
            onLinkTap: onLinkTap,
          );
          spans.add(nestedSpan);
          i = closingTag + 4;
          continue;
        }
      }

      // Check for strikethrough {s}...{/s}
      if (_matchesAt(text, i, '{s}')) {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        final closingTag = text.indexOf('{/s}', i + 3);
        if (closingTag != -1) {
          final content = text.substring(i + 3, closingTag);
          final nestedSpan = parseStyledText(
            content,
            baseStyle: baseStyle.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
            onLinkTap: onLinkTap,
          );
          spans.add(nestedSpan);
          i = closingTag + 4;
          continue;
        }
      }

      // Check for pipe separator (|) as line break
      if (text[i] == '|') {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
          buffer.clear();
        }
        spans.add(const TextSpan(text: '\n'));
        i++;
        continue;
      }

      // Regular character
      buffer.write(text[i]);
      i++;
    }

    // Add remaining text
    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
    }

    return TextSpan(children: spans);
  }

  /// Builds a [RichText] widget from styled text.
  ///
  /// [text] - The input string with style decorators.
  /// [baseStyle] - The default [TextStyle] to apply.
  /// [textAlign] - Text alignment (default: [TextAlign.start]).
  /// [maxLines] - Maximum number of lines.
  /// [overflow] - How to handle text overflow.
  /// [onLinkTap] - Optional callback when a link is tapped.
  Widget buildStyledText(
    String text, {
    required TextStyle baseStyle,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
    void Function(String url)? onLinkTap,
  }) {
    return RichText(
      text: parseStyledText(text, baseStyle: baseStyle, onLinkTap: onLinkTap),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Checks if the text matches a pattern at a given index.
  bool _matchesAt(String text, int index, String pattern) {
    if (index + pattern.length > text.length) return false;
    return text.substring(index, index + pattern.length) == pattern;
  }

  /// Finds the closing tag, accounting for potential escaping.
  int _findClosingTag(String text, int startIndex, String tag) {
    var i = startIndex;
    while (i < text.length) {
      if (_matchesAt(text, i, tag)) {
        // Ensure we're not matching a longer tag (e.g., ** vs ***)
        if (tag == '*' && i + 1 < text.length && text[i + 1] == '*') {
          i++;
          continue;
        }
        return i;
      }
      i++;
    }
    return -1;
  }

  /// Parses a color name or hex code to a [Color].
  Color _parseColor(String colorName) {
    // Check for hex color
    if (colorName.startsWith('#')) {
      final hex = colorName.substring(1);
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    // Named colors mapping
    return switch (colorName.toLowerCase()) {
      'primary' => AppColors.primary,
      'secondary' => AppColors.grey,
      'error' => AppColors.error,
      'success' => AppColors.success,
      'warning' => AppColors.warning,
      'grey' || 'gray' => AppColors.grey,
      'greydark' || 'graydark' => AppColors.darkGrey,
      'greylight' || 'graylight' => AppColors.lightGrey,
      'muted' => AppColors.grey,
      'brand500' => AppColors.primary,
      'brand600' => AppColors.primary,
      'brand700' => AppColors.primary,
      'purple500' => AppColors.purple,
      'purple600' => AppColors.purple,
      'white' => AppColors.white,
      'black' => AppColors.black,
      _ => AppColors.black,
    };
  }
}
