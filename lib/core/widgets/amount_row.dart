import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AmountRow extends StatelessWidget {
  const AmountRow({
    super.key,
    required this.label,
    required this.amount,
    this.isHighlighted = false,
  });

  final String label;
  final double amount;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final style = isHighlighted
        ? AppTextStyles.bodySemiBold(color: AppColors.primary)
        : AppTextStyles.body(color: AppColors.grey600);

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(
          '${amount.toStringAsFixed(2)} ${AppStrings.currencySuffix}',
          style: style,
        ),
      ],
    );
  }
}
