import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.bottomNavigationBar,
    this.extendBody = false,
    this.useSafeArea = true,
    this.padding,
    this.backgroundColor = AppColors.backgroundLight,
  });

  final Widget body;
  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: body,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: extendBody,
      appBar: title == null
          ? null
          : AppBar(
              titleSpacing: 16.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title!, style: AppTextStyles.h3()),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption(color: AppColors.grey500),
                    ),
                  ],
                ],
              ),
              actions: actions,
            ),
      bottomNavigationBar: bottomNavigationBar,
      body: useSafeArea ? SafeArea(child: content) : content,
    );
  }
}
