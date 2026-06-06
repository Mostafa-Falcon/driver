import 'package:driver/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({
    super.key,
    this.size = 96,
    this.assetPath,
    this.icon = Icons.delivery_dining_rounded,
    this.iconColor = AppColors.primary,
    this.backgroundColor = Colors.white,
    this.borderRadius,
    this.elevationColor = Colors.black26,
  });

  final double size;
  final String? assetPath;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double? borderRadius;
  final Color elevationColor;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size.r;
    final resolvedRadius = borderRadius?.r ?? resolvedSize * 0.24;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(resolvedRadius),
        boxShadow: [
          BoxShadow(
            color: elevationColor.withValues(alpha: 0.18),
            blurRadius: resolvedSize * 0.2,
            offset: Offset(0, resolvedSize * 0.08),
          ),
        ],
      ),
      child: SizedBox.square(
        dimension: resolvedSize,
        child: assetPath == null
            ? Icon(
                icon,
                size: resolvedSize * 0.56,
                color: iconColor,
              )
            : Padding(
                padding: EdgeInsets.all(resolvedSize * 0.16),
                child: Image.asset(assetPath!, fit: BoxFit.contain),
              ),
      ),
    );
  }
}
