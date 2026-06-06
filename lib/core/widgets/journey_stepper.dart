import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JourneyStepper extends StatelessWidget {
  const JourneyStepper({
    super.key,
    required this.status,
  });

  final String? status;

  static const List<_JourneyStep> _steps = [
    _JourneyStep('قبول الطلب', AppConstants.statusDriverAccepted),
    _JourneyStep('استلام الطلب', AppConstants.statusOrderShipped),
    _JourneyStep('في الطريق', AppConstants.statusInTransit),
    _JourneyStep('تم التسليم', AppConstants.statusOrderCompleted),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeIndex;

    return Column(
      children: List.generate(_steps.length, (index) {
        final isActive = index <= activeIndex;
        final isLast = index == _steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.grey200,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 18.r,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.r,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.w,
                    height: 28.h,
                    color: isActive ? AppColors.primary : AppColors.grey200,
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Text(
                  _steps[index].label,
                  style: isActive
                      ? AppTextStyles.bodySemiBold(color: AppColors.grey900)
                      : AppTextStyles.body(color: AppColors.grey500),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  int get _activeIndex {
    final index = _steps.indexWhere((step) => step.status == status);
    if (status == AppConstants.statusInTransit) return 2;
    if (status == AppConstants.statusOrderCompleted) return 3;
    return index < 0 ? 0 : index;
  }
}

class _JourneyStep {
  const _JourneyStep(this.label, this.status);

  final String label;
  final String status;
}
