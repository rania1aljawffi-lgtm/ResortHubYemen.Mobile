import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../chalets/view_models/chalet_view_model.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../../data/models/booking_model.dart';

class BookingCheckoutScreen extends StatefulWidget {
  final int chaletId;

  const BookingCheckoutScreen({super.key, required this.chaletId});

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
  int adultCount = 1;
  int childCount = 1;
  int _currentNavIndex = 2;

  int checkInDay = 4;
  String checkInMonth = 'مايو';
  int checkOutDay = 7;
  String checkOutMonth = 'مايو';

  final List<String> months = ['اكتوبر', 'اغسطس', 'مايو', 'يونيو', 'ابريل', 'نوفمبر'];
  final List<int> checkInDays = [1, 3, 4, 5, 6, 7];
  final List<int> checkOutDays = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChaletViewModel, AuthViewModel>(
      builder: (context, chaletViewModel, authViewModel, child) {
        final chalet = chaletViewModel.chalets.where((c) => c.chaletId == widget.chaletId).firstOrNull;

        if (chalet == null) {
          return const Scaffold(body: Center(child: Text('المنتجع غير موجود')));
        }

        int nights = (checkOutDay - checkInDay).abs();
        if (nights == 0) nights = 1;
        
        double subtotal = chalet.pricePerNight * nights;
        double serviceFee = 45.00;
        double tax = 15.00;
        double discount = 20.00;
        double total = subtotal + serviceFee + tax - discount;

        return Scaffold(
          backgroundColor: const Color(0xFFE8F1F7),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE8F1F7),
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 65,
            titleSpacing: 0,
            title: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 55,
                      height: 55,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.beach_access, color: AppTheme.primaryColor, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStepper()),
                  ],
                ),
              ),
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chalet.chaletName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2B4C), fontFamily: 'Tajawal'),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الموقع: ${chalet.location}',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF1E2B4C), fontFamily: 'Tajawal'),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  Icon(Icons.star, color: Color(0xFFFFB800), size: 20),
                                  SizedBox(width: 4),
                                  Text('4.9', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2B4C), fontSize: 14, fontFamily: 'Tajawal')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/chalet_1.png',
                              height: 105,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(height: 105, color: Colors.grey[300], child: const Icon(Icons.image, color: Colors.grey, size: 40)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.calendar_month_outlined, color: Color(0xFF1E2B4C), size: 22),
                            Text(chalet.chaletName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2B4C), fontFamily: 'Tajawal')),
                          ],
                        ),
                        const SizedBox(height: 14),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildDateTable(
                                title: 'تسجيل الوصول',
                                days: checkInDays,
                                selectedDay: checkInDay,
                                selectedMonth: checkInMonth,
                                onSelect: (d, m) => setState(() { checkInDay = d; checkInMonth = m; }),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateTable(
                                title: 'تسجيل المغادرة',
                                days: checkOutDays,
                                selectedDay: checkOutDay,
                                selectedMonth: checkOutMonth,
                                onSelect: (d, m) => setState(() { checkOutDay = d; checkOutMonth = m; }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          'إقامة لمدة $nights ليالي يتم تطبيق سياسة الإلغاء المرنة لهذا الحجز',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF327A9E), fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0xFFE5E9F0)),
                        const SizedBox(height: 12),

                        _buildGuestCounter(
                          title: 'بالغين',
                          subtitle: 'من عمر 13 فما فوق',
                          count: adultCount,
                          onChanged: (val) => setState(() => adultCount = val),
                        ),
                        const Divider(height: 1, color: Color(0xFFE5E9F0)),
                        _buildGuestCounter(
                          title: 'أطفال',
                          subtitle: 'أعمار 2_12 سنة',
                          count: childCount,
                          onChanged: (val) => setState(() => childCount = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('تفاصيل السعر', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF327A9E), fontFamily: 'Tajawal')),
                        ),
                        const SizedBox(height: 14),
                        _buildPriceRow('\$${chalet.pricePerNight} x ليالي $nights', '\$$subtotal', false),
                        const SizedBox(height: 10),
                        _buildPriceRow('رسوم الخدمة', '\$$serviceFee', false),
                        const SizedBox(height: 10),
                        _buildPriceRow('الضرائب السياحية', '\$$tax', false),
                        const SizedBox(height: 10),
                        _buildPriceRow('خصم الحجز المبكر', '\$$discount-', true),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3581A7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$$total',
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                                  ),
                                  const Text('يشمل جميع الرسوم', style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Tajawal')),
                                ],
                              ),
                              const Text('المجموع الكلي', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              final bookingData = BookingModel(
                                bookingId: 0,
                                userId: authViewModel.currentUser?.userId ?? 0,
                                chaletId: chalet.chaletId,
                                checkInDate: DateTime.now(), // Fake date for now
                                checkOutDate: DateTime.now().add(Duration(days: nights)),
                                guests: adultCount + childCount,
                                totalPrice: total,
                                status: 'Pending',
                              );
                              context.push(RouteConstants.paymentMethod, extra: bookingData);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2B4C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text('تأكيد الحجز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: (i) => setState(() => _currentNavIndex = i),
          ),
        );
      }
    );
  }

  // ── Helper: Stepper ────────────────────────────────────────────────────
  Widget _buildStepper() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Step 1: التفاصيل (active teal)
          _buildStepCircle('1', 'التفاصيل', isActive: true),
          Expanded(
            child: Container(
              height: 2,
              color: const Color(0xFF1E7A9E),
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          // Step 2: الحجز (active teal)
          _buildStepCircle('2', 'الحجز', isActive: true),
          Expanded(
            child: Container(
              height: 2,
              color: const Color(0xFFA5C5D8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          // Step 3: الدفع (inactive)
          _buildStepCircle('3', 'الدفع', isActive: false),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String number, String label, {required bool isActive}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E7A9E) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? const Color(0xFF1E7A9E) : const Color(0xFF1E2B4C),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF1E2B4C),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF1E2B4C),
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  // ── Helper: Date Table Grid ───────────────────────────────────────────
  Widget _buildDateTable({
    required String title,
    required List<int> days,
    required int selectedDay,
    required String selectedMonth,
    required Function(int, String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF1E2B4C),
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 6),
        // Header Bar
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF3581A7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_downward, color: Colors.white, size: 12),
                    SizedBox(width: 2),
                    Text('اليوم', style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
              Container(width: 1, height: 16, color: Colors.white30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_downward, color: Colors.white, size: 12),
                    SizedBox(width: 2),
                    Text('الشهر', style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Table body
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1E2B4C), width: 1),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Column(
            children: List.generate(6, (index) {
              final d = days[index % days.length];
              final m = months[index % months.length];
              final isSel = (d == selectedDay && m == selectedMonth);
              return GestureDetector(
                onTap: () => onSelect(d, m),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFE2F0F9) : Colors.white,
                    border: index < 5
                        ? const Border(bottom: BorderSide(color: Color(0xFF1E2B4C), width: 0.8))
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '$d',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E2B4C),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                      Container(width: 0.8, height: 18, color: const Color(0xFF1E2B4C)),
                      Expanded(
                        child: Center(
                          child: Text(
                            m,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E2B4C),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ── Helper: Guest Counter ──────────────────────────────────────────────
  Widget _buildGuestCounter({
    required String title,
    required String subtitle,
    required int count,
    required Function(int) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular +/- buttons (Matching Image 5)
          Row(
            children: [
              GestureDetector(
                onTap: () => onChanged(count + 1),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3581A7), width: 1.5),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Color(0xFF3581A7)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2B4C),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onChanged(count > 0 ? count - 1 : 0),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3581A7), width: 1.5),
                  ),
                  child: const Icon(Icons.remove, size: 16, color: Color(0xFF3581A7)),
                ),
              ),
            ],
          ),
          // Title + Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1E2B4C),
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helper: Price Row ──────────────────────────────────────────────────
  Widget _buildPriceRow(String title, String amount, bool isDiscount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDiscount ? const Color(0xFF3581A7) : const Color(0xFF1E2B4C),
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isDiscount ? const Color(0xFF3581A7) : Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
}
