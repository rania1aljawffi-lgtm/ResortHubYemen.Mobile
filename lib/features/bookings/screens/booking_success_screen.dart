import 'package:flutter/material.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bookingNumber;

  const BookingSuccessScreen({
    super.key,
    this.bookingNumber = '#1256',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // ── Concentric Ripple Rings with Checkmark (Matching Screenshot) ──
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2E8F4).withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA5D1E8).withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3886A9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Success Text (تم الدفع بنجاح) ──────────────────
                const Text(
                  'تم الدفع بنجاح',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3886A9),
                    fontFamily: 'Tajawal',
                  ),
                ),

                const SizedBox(height: 12),

                // ── Booking Reference Number (#1256) ────────────────
                Text(
                  bookingNumber,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2B4C),
                    fontFamily: 'Tajawal',
                    letterSpacing: 1.5,
                  ),
                ),

                const Spacer(flex: 4),

                // ── Action Buttons ──────────────────────────────────
                CustomButton(
                  text: 'عرض الحجوزات',
                  onPressed: () => context.go(RouteConstants.bookings),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(RouteConstants.home),
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2B4C),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
