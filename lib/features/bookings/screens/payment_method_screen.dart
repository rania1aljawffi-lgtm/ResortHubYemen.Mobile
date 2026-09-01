import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../data/models/booking_model.dart';
import '../view_models/booking_view_model.dart';

class PaymentMethodScreen extends StatefulWidget {
  final dynamic bookingDetails;

  const PaymentMethodScreen({super.key, this.bookingDetails});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedMethod = 'Google Pay';

  void _confirmPayment() async {
    if (widget.bookingDetails != null && widget.bookingDetails is BookingModel) {
      final booking = widget.bookingDetails as BookingModel;
      final viewModel = context.read<BookingViewModel>();
      
      final success = await viewModel.createBooking(booking);
      if (success) {
        if (mounted) context.go(RouteConstants.bookingSuccess);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.error?.message ?? 'فشل الحجز')),
          );
        }
      }
    } else {
      context.go(RouteConstants.bookingSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = (widget.bookingDetails is BookingModel) ? widget.bookingDetails as BookingModel : null;
    final total = booking?.totalPrice ?? 200.5;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4FA),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'طريقة الدفع',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // ── Payment Options ────────────────────────────────────────
              _buildPaymentOption(
                'Cash',
                'assets/images/cash_icon.png',
                Icons.monetization_on,
                const Color(0xFFF5C842),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                'Kuraimi',
                'assets/images/kuraimi_icon.png',
                Icons.account_balance_wallet,
                const Color(0xFF9C7CDB),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                'Google Pay',
                'assets/images/google_logo.png',
                Icons.g_mobiledata,
                Colors.blue,
              ),

              const SizedBox(height: 48),

              // ── Price Summary ──────────────────────────────────────────
              _buildSummaryRow('المبلغ', '\$${total - (booking != null ? 60 : 0)}'),
              const SizedBox(height: 14),
              _buildSummaryRow('الضرائب والرسوم', '\$60.00'),
              const SizedBox(height: 14),
              const Divider(thickness: 1, color: Color(0xFFCDD5E0)),
              const SizedBox(height: 14),
              _buildSummaryRow('الاجمالي', '\$$total', isBold: true),

              const Spacer(),

              // ── Confirm Button ─────────────────────────────────────────
              Consumer<BookingViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomButton(
                    text: 'تأكيد الدفع',
                    onPressed: _confirmPayment,
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      String title, String assetPath, IconData fallbackIcon, Color iconColor) {
    final bool isSelected = selectedMethod == title;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              textDirection: TextDirection.ltr,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) =>
                          Icon(fallbackIcon, size: 30, color: iconColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 32, color: Colors.grey[300]),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppTheme.primaryColor : Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppTheme.primaryColor : Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
}
