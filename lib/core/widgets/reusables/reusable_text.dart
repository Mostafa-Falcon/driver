import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum TextVariant {
  display,
  h1,
  h2,
  h3,
  bodyLarge,
  body,
  bodyMedium,
  bodySemiBold,
  caption,
  captionMedium,
  button,
}

class ReusableText extends StatelessWidget {
  const ReusableText({
    super.key,
    required this.text,
    this.variant = TextVariant.body,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  });

  // Factory constructors for convenient access to typography styles

  const ReusableText.display({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.display;

  const ReusableText.h1({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.h1;

  const ReusableText.h2({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.h2;

  const ReusableText.h3({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.h3;

  const ReusableText.bodyLarge({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.bodyLarge;

  const ReusableText.body({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.body;

  const ReusableText.bodyMedium({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.bodyMedium;

  const ReusableText.bodySemiBold({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.bodySemiBold;

  const ReusableText.caption({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.caption;

  const ReusableText.captionMedium({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.isDark = false,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  }) : variant = TextVariant.captionMedium;

  const ReusableText.button({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.fontFamily,
  })  : variant = TextVariant.button,
        isDark = false;

  final String text;
  final TextVariant variant;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isDark;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? height;
  final double? letterSpacing;
  final TextStyle? style;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    final bool effectiveIsDark =
        isDark || (Theme.of(context).brightness == Brightness.dark);
    TextStyle baseStyle;
    switch (variant) {
      case TextVariant.display:
        baseStyle =
            AppTextStyles.display(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.h1:
        baseStyle = AppTextStyles.h1(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.h2:
        baseStyle = AppTextStyles.h2(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.h3:
        baseStyle = AppTextStyles.h3(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.bodyLarge:
        baseStyle =
            AppTextStyles.bodyLarge(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.body:
        baseStyle = AppTextStyles.body(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.bodyMedium:
        baseStyle =
            AppTextStyles.bodyMedium(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.bodySemiBold:
        baseStyle =
            AppTextStyles.bodySemiBold(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.caption:
        baseStyle =
            AppTextStyles.caption(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.captionMedium:
        baseStyle =
            AppTextStyles.captionMedium(color: color, isDark: effectiveIsDark);
        break;
      case TextVariant.button:
        baseStyle = AppTextStyles.button(color: color);
        break;
    }

    final TextStyle finalStyle = (style ?? baseStyle).copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      letterSpacing: letterSpacing,
      fontFamily: fontFamily,
    );

    return Text(
      text,
      style: finalStyle,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
