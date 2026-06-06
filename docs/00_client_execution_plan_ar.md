# خطة تنفيذ مشروع تطبيق السائق

## الهدف

بناء النسخة الجديدة من تطبيق `driver` بشكل احترافي ومتقدم اعتمادا على:

- متطلبات العميل الموجودة في `driver-old/docs`.
- الأصول المرئية الموجودة في `driver-old/assets`.
- سلوك النسخة القديمة `driver-old` كمرجع وظيفي فقط، وليس كمصدر نسخ مباشر.

المطلوب هو إنتاج تطبيق مندوب توصيل واضح، سريع، جميل، آمن في العمليات الحساسة، وقابل للتطوير.

## مصادر العمل

- المشروع القديم: `../driver-old`
- وثائق العميل: `../driver-old/docs`
- فيديو شرح العميل: `../driver-old/docs/WhatsApp Video 2026-06-05 at 5.25.32 PM.mp4`
- أصول العميل: `../driver-old/assets`
- المشروع الجديد المطلوب تطويره: `./`

## نطاق MVP

التركيز الحالي على تطبيق السائق فقط:

- تسجيل دخول وحفظ جلسة.
- حالة السائق: متصل / غير متصل.
- تبويبات الطلبات: الجديدة، النشطة، السابقة.
- قبول الطلب أو إخفاؤه.
- منع قبول نفس الطلب من أكثر من سائق.
- تفاصيل الطلب: السعر، العمولة، من/إلى، الملاحظات، المرفقات، حالة الرحلة.
- تحديث حالة الطلب خطوة بخطوة حتى التسليم.
- تسجيل `order_events` لكل تغيير مهم.
- محفظة وسجل معاملات.
- دعم فني بأسباب جاهزة.
- مركز إشعارات داخل التطبيق.
- حساب السائق وإحصائيات التشغيل الأساسية.

## مبادئ التنفيذ

### لا ننسخ القديم كما هو

النسخة القديمة مرجع لفهم المطلوب فقط. عند النقل من `driver-old`:

- نأخذ الفكرة أو الأصل البصري المفيد.
- نعيد كتابة الكود داخل معمارية المشروع الجديد.
- لا ننقل ملفات كبيرة أو منطق مختلط بدون تنظيف.
- لا نكرر أخطاء القديم مثل business logic داخل الـ UI.

### Clean Code

- `Views`: عرض فقط.
- `Controllers`: إدارة state والتفاعل مع repositories/services.
- `Repositories`: Firestore queries وtransactions.
- `Services`: خدمات عامة طويلة العمر مثل auth/settings/theme/notifications.
- `Models`: parsing واضح وآمن للبيانات.
- `Widgets`: قطع صغيرة قابلة لإعادة الاستخدام.
- `Constants`: مسارات assets، أسماء collections، statuses، event types.

### Reusable Widgets

يجب بناء مكتبة UI داخل `lib/core/widgets` تدريجيا:

- `AppScaffold`
- `AppHeader`
- `AppCard`
- `AppBrandMark`
- `AppLoadingIndicator`
- `EmptyStateWidget`
- `StatusChip`
- `AddressRow`
- `AmountRow`
- `OrderCard`
- `SectionTitle`
- `AppTabBar`
- `ActionBottomBar`

أي widget يتكرر مرتين أو أكثر يتحول إلى reusable widget.

### Responsive UI

- كل شاشة يجب أن تعمل على شاشات Android صغيرة وكبيرة.
- استخدام `LayoutBuilder`, `MediaQuery`, و`flutter_screenutil` عند الحاجة.
- تجنب الأحجام hard-coded الثقيلة.
- النصوص لا تتداخل ولا تخرج من الحاويات.
- دعم RTL بشكل افتراضي.
- الشاشات التي تحتاج full-screen مثل splash تستخدم edge-to-edge وتدير safe areas بنفسها.

### Animation خفيف

نستخدم `flutter_animate` فقط للحركات الخفيفة:

- fade in
- slide بسيط
- scale بسيط للعناصر المهمة
- stagger للقوائم عند الحاجة

القواعد:

- مدة الحركة غالبا بين 180ms و450ms.
- لا نستخدم حركات كثيرة داخل شاشات التشغيل اليومية.
- الأنيميشن يخدم الوضوح ولا يعطل الاستخدام.
- لا نعتمد على animation لإخفاء مشاكل layout.

## استخدام assets من المشروع القديم

الأصول المرشحة من `../driver-old/assets`:

- `images/driver_logo.png`
- `images/ic_logo.png`
- `images/wallet.png`
- `images/pickup.png`
- `images/dropoff.png`
- `images/empty_parcel.svg`
- `images/user_placeholder.png`
- `audio/mixkit-happy-bells-notification-937.mp3`
- أي icons مرتبطة بالطلبات، المحفظة، الدعم، الإشعارات بعد مراجعتها.

قواعد استخدام assets:

- لا ننقل مجلد assets بالكامل.
- ننقل فقط الملفات المستخدمة فعليا.
- نضع مساراتها في ملف مركزي مثل `lib/core/constants/app_assets.dart`.
- نضيفها في `pubspec.yaml` بشكل منظم.
- نحافظ على أسماء واضحة ومفهومة.

## خطة العمل

### المرحلة 1: Foundation

الهدف:
تثبيت أساس UI ومعمارية المشروع الجديد.

المطلوب:

- تنظيف `README.md` وربطه بخطة التنفيذ.
- إنشاء `AppAssets`.
- إنشاء reusable widgets الأساسية.
- تثبيت نظام full-screen للشاشات التي تحتاج ذلك.
- تنظيف النصوص العربية التي ظهرت بترميز خاطئ في الملفات المهمة.
- تثبيت animation package واستخدامه بحذر.

معايير القبول:

- `flutter analyze` بدون مشاكل.
- `flutter build apk --debug` ينجح.
- Splash screen full-screen وresponsive.

### المرحلة 2: Navigation & App Shell

الهدف:
تسجيل المسارات المطلوبة وبناء تجربة تنقل واضحة.

المطلوب:

- تسجيل routes الناقصة:
  - `orderDetails`
  - `wallet`
  - `support`
  - `notifications`
  - `editProfile`
- بناء app shell أو dashboard مناسب للسائق.
- منع أي controller من التنقل إلى route غير مسجل.

معايير القبول:

- كل route مستخدم في الكود مسجل في `AppPages.routes`.
- الضغط على أي card أو action لا يسبب unknown route.

### المرحلة 3: Home & Orders

الهدف:
شاشة تشغيل يومية واضحة للسائق.

المطلوب:

- تبويبات: الطلبات الجديدة، النشطة، السابقة.
- `OrderCard` reusable.
- `StatusChip` reusable.
- `AddressRow` reusable.
- `AmountRow` reusable.
- قبول الطلب داخل Firestore transaction.
- إخفاء الطلب من قائمة السائق بدون تغيير حالة الطلب عالميا.
- رسائل نجاح وفشل واضحة.

قواعد العميل:

- السائق غير المتصل لا تصله طلبات جديدة.
- الطلب لا يقبل إلا إذا كان ما زال متاحا.
- لا يمكن لسائق آخر قبول نفس الطلب بعد ربطه بسائق.

معايير القبول:

- قبول الطلب يحدث مرة واحدة فقط.
- الطلب ينتقل من الجديدة إلى النشطة بعد القبول.
- إخفاء الطلب لا يؤثر على باقي السائقين.

### المرحلة 4: Order Details & Journey

الهدف:
تقديم تفاصيل الطلب بشكل كامل وعملي.

المطلوب:

- شاشة تفاصيل طلب responsive.
- عرض السعر، رسوم التوصيل، العمولة، الإجمالي.
- عرض عنوان الاستلام والتسليم.
- عرض الملاحظات والمرفقات إن وجدت.
- `JourneyStepper` reusable لخطوات الرحلة.
- أزرار تحديث الحالة حسب المرحلة الحالية فقط.
- تسجيل event لكل تغيير حالة.

معايير القبول:

- لا يمكن تحديث طلب غير مخصص للسائق الحالي.
- لا يمكن القفز بين الحالات بشكل غير مسموح.
- كل تغيير حالة يسجل في `order_events`.

### المرحلة 5: Wallet

الهدف:
محفظة واضحة وآمنة.

المطلوب:

- balance card.
- قائمة transactions.
- فلترة بسيطة حسب النوع.
- طلب سحب.
- منع تعديل الرصيد مباشرة من UI.

قواعد العميل:

- أي خصم أو إضافة للمحفظة يجب أن يكون له transaction مستقل.
- العمولة تخصم مرة واحدة فقط بعد اكتمال الطلب.
- transaction مرتبط برقم الطلب إن وجد.

معايير القبول:

- لا توجد عملية مالية حساسة من client فقط بدون transaction.
- منع تكرار خصم العمولة لنفس الطلب.

### المرحلة 6: Support

الهدف:
دعم فني بسيط وواضح للسائق.

المطلوب:

- أسباب دعم جاهزة.
- حقل رسالة اختيارية.
- إنشاء ticket في `support_tickets`.
- عرض تذاكر السائق.

معايير القبول:

- يمكن إرسال سبب ورسالة.
- التذكرة تحفظ في Firestore.
- تظهر حالة الإرسال للمستخدم بوضوح.

### المرحلة 7: Notifications

الهدف:
مركز إشعارات داخل التطبيق.

المطلوب:

- قائمة إشعارات بالأحدث أولا.
- ربط الإشعارات بأحداث الطلب.
- reusable `NotificationTile`.
- حالة فارغة واضحة.

معايير القبول:

- إشعار طلب جديد يظهر للسائق.
- إشعار اكتمال الطلب يظهر داخل التطبيق.
- القائمة تعرض الأحدث أولا.

### المرحلة 8: Profile & Stats

الهدف:
حساب سائق احترافي يعرض بيانات التشغيل.

المطلوب:

- صورة واسم السائق.
- حالة التفعيل.
- إجمالي الرحلات.
- معدل القبول.
- معدل الإلغاء.
- زر تسجيل الخروج.

معايير القبول:

- البيانات لا تكسر الشاشة إذا كانت ناقصة.
- كل الإحصائيات لها fallback واضح.

## أولويات الفجوات الحالية

تم رصد فجوات مباشرة في المشروع الجديد:

- `HomeController` يستخدم `AppRoutes.orderDetails` لكن route غير مسجل حاليا.
- المشروع الجديد لا يحتوي بعد على شاشات:
  - Order Details
  - Wallet
  - Support
  - Notifications
  - Profile
- يوجد نصوص عربية في بعض الملفات ظهرت بترميز خاطئ وتحتاج تنظيف تدريجي.
- يجب إضافة `AppAssets` قبل نقل أي assets من القديم.

## Definition of Done

أي مهمة تعتبر مكتملة فقط إذا:

- الكود مرتب حسب المعمارية المتفق عليها.
- لا توجد business logic داخل view.
- widgets المتكررة تحولت إلى reusable widgets.
- الشاشة responsive ولا يوجد overlap.
- الأنيميشن خفيف ولا يبطئ الاستخدام.
- `flutter analyze` ينجح.
- `flutter build apk --debug` ينجح عند تغييرات Flutter/Android.
- تم اختبار المسار أو الشاشة يدويا قدر الإمكان.

## أوامر التحقق

```powershell
flutter analyze
flutter build apk --debug
```

عند تغييرات assets أو dependencies:

```powershell
flutter pub get
flutter clean
flutter build apk --debug
```

## ترتيب التنفيذ المقترح الآن

1. إنشاء `AppAssets` ونقل assets المطلوبة فقط من `driver-old/assets`.
2. إنشاء `AppScaffold`, `AppCard`, `StatusChip`, `OrderCard`.
3. تسجيل routes الناقصة في `AppPages`.
4. بناء skeleton لشاشات `orderDetails`, `wallet`, `support`, `notifications`.
5. تحسين Home UI باستخدام reusable widgets.
6. تنفيذ Order Details وJourneyStepper.
7. تنفيذ Wallet.
8. تنفيذ Support.
9. تنفيذ Notifications.
10. مراجعة عامة للكود والنصوص والتجربة على جهاز حقيقي.
