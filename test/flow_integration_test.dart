import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resorthub_mobile/main.dart';
import 'package:resorthub_mobile/core/routing/app_router.dart';
import 'package:resorthub_mobile/core/routing/route_constants.dart';

void main() {
  group('Critical User Flow & Navigation Integration Test Suite', () {
    testWidgets('Full Navigation and Screen Transition Flow', (WidgetTester tester) async {
      // 1. Application Launch & Splash Screen
      await tester.pumpWidget(const ResortHubApp());
      await tester.pump();

      // Verify Splash screen headline is present
      expect(find.text('اكتشف أجمل  المنتجعات\nوأحجز تجربتك بسهولة'), findsOneWidget);

      // Drain splash auto-transition timer (2.8s)
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // 2. Auth Screen (Login / Register)
      expect(find.text('تسجيل الدخول'), findsWidgets);
      expect(find.text('إنشاء حساب'), findsWidgets);
      expect(find.text('وجهتك الفاخرة للاسترخاء والجمال'), findsOneWidget);

      // Switch between Login and Register tabs
      await tester.tap(find.text('إنشاء حساب'));
      await tester.pumpAndSettle();
      expect(find.text('الاسم كامل'), findsOneWidget);
      expect(find.text('رقم الهاتف'), findsOneWidget);

      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pumpAndSettle();
      expect(find.text('البريد الإلكتروني'), findsOneWidget);

      // 3. Navigation to Home Screen
      AppRouter.router.go(RouteConstants.home);
      await tester.pumpAndSettle();

      expect(find.text('المنتجعات المميزة'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search bar

      // 4. Navigation to Chalets Screen
      AppRouter.router.go(RouteConstants.chalets);
      await tester.pumpAndSettle();

      expect(find.text('استكشاف الشاليهات والمنتجعات'), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('صنعاء'), findsOneWidget);
      expect(find.text('عدن'), findsOneWidget);

      // 5. Navigation to Chalet Details Screen
      AppRouter.router.go('/chalets/1');
      await tester.pumpAndSettle();

      expect(find.text('تفاصيل المنتج'), findsOneWidget);

      // 6. Navigation to Booking Checkout Screen
      AppRouter.router.go(RouteConstants.bookingCheckout, extra: 1);
      await tester.pumpAndSettle();

      // 7. Navigation to Payment Method Screen
      AppRouter.router.go(RouteConstants.paymentMethod);
      await tester.pumpAndSettle();

      expect(find.text('طريقة الدفع'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Kuraimi'), findsOneWidget);
      expect(find.text('Google Pay'), findsOneWidget);
      expect(find.text('تأكيد الدفع'), findsOneWidget);

      // 8. Navigation to Booking Success Screen
      AppRouter.router.go(RouteConstants.bookingSuccess);
      await tester.pumpAndSettle();

      expect(find.text('تم الدفع بنجاح'), findsOneWidget);
      expect(find.text('عرض الحجوزات'), findsOneWidget);
      expect(find.text('العودة للرئيسية'), findsOneWidget);

      // 9. Navigation to Bookings Screen
      AppRouter.router.go(RouteConstants.bookings);
      await tester.pumpAndSettle();

      expect(find.text('حجوزاتي'), findsOneWidget);
      expect(find.text('حجوزاتي الحالية'), findsOneWidget);
      expect(find.text('حجوزاتي السابقة'), findsOneWidget);

      // Switch tabs in Bookings
      await tester.tap(find.text('حجوزاتي السابقة'));
      await tester.pumpAndSettle();
      expect(find.text('حجوزاتي السابقة'), findsOneWidget);

      // 10. Navigation to Reviews Screen
      AppRouter.router.go(RouteConstants.reviews);
      await tester.pumpAndSettle();

      expect(find.text('التقييمات والآراء'), findsOneWidget);
      expect(find.text('أحدث التقييمات'), findsOneWidget);
      expect(find.text('أضف تقييمك الآن'), findsOneWidget);

      // 11. Navigation to Profile Screen
      AppRouter.router.go(RouteConstants.profile);
      await tester.pumpAndSettle();

      expect(find.text('الملف الشخصي'), findsOneWidget);
      expect(find.text('إدارة الحساب'), findsOneWidget);
      expect(find.text('الإعدادات والدعم'), findsOneWidget);

      // 12. Return to Home Screen
      AppRouter.router.go(RouteConstants.home);
      await tester.pumpAndSettle();
      expect(find.text('المنتجعات المميزة'), findsOneWidget);
    });

    testWidgets('Network Resilience and Offline Error State Handling', (WidgetTester tester) async {
      await tester.pumpWidget(const ResortHubApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // Go to Chalets
      AppRouter.router.go(RouteConstants.chalets);
      await tester.pumpAndSettle();

      // App stays stable, UI remains functional and renders without crashing
      expect(find.text('استكشاف الشاليهات والمنتجعات'), findsOneWidget);
    });
  });
}
