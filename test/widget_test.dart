import 'package:driver/core/constants/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('orderStatus maps known order states to Arabic labels', () {
    expect(AppStrings.orderStatus('Order Placed'), 'جديد');
    expect(AppStrings.orderStatus('Driver Accepted'), 'مقبول');
    expect(AppStrings.orderStatus('Order Completed'), 'تم التسليم');
  });
}
