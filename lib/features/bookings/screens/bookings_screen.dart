import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/resort_card.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../view_models/booking_view_model.dart';
import '../../chalets/view_models/chalet_view_model.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentNavIndex = 2; // Bookings tab in bottom nav

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingViewModel>().fetchBookings();
      // Ensure chalets are loaded to map chaletId to name
      context.read<ChaletViewModel>().fetchChalets();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthViewModel>().currentUser;
    final userName = currentUser != null && currentUser.fullName.isNotEmpty
        ? currentUser.fullName
        : 'زائر كريم';
    final userEmail = currentUser != null && currentUser.email.isNotEmpty
        ? currentUser.email
        : 'سجل الدخول الآن';

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App Bar: User pill + Logo ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Profile Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3D0E8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.primaryColor,
                            child: Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.primaryColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Logo
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 50,
                          height: 50,
                          errorBuilder: (c, e, s) => Column(
                            children: const [
                              Icon(Icons.beach_access, color: AppTheme.primaryColor, size: 28),
                              Text('ResortHub', style: TextStyle(fontSize: 9, color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Title ──────────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  'حجوزاتي',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),

              // ── Tabs ───────────────────────────────────────────────────
              TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Tajawal',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'Tajawal',
                ),
                tabs: const [
                  Tab(text: 'حجوزاتي الحالية'),
                  Tab(text: 'حجوزاتي السابقة'),
                ],
              ),

              // ── Tab Content ────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingsList(context, isCurrent: true),
                    _buildBookingsList(context, isCurrent: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, {required bool isCurrent}) {
    return Consumer2<BookingViewModel, ChaletViewModel>(
      builder: (context, bookingViewModel, chaletViewModel, child) {
        if (bookingViewModel.isLoading || chaletViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
        }

        final now = DateTime.now();
        final bookings = bookingViewModel.bookings.where((b) {
          return isCurrent
              ? b.checkInDate.isAfter(now) || (b.checkInDate.isBefore(now) && b.checkOutDate.isAfter(now))
              : b.checkOutDate.isBefore(now);
        }).toList();

        if (bookings.isEmpty) {
          return Center(
            child: Text(
              isCurrent ? 'لا توجد حجوزات حالية' : 'لا توجد حجوزات سابقة',
              style: const TextStyle(fontFamily: 'Tajawal', color: AppTheme.primaryColor),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final chalet = chaletViewModel.chalets.where((c) => c.chaletId == booking.chaletId).firstOrNull;
            
            return ResortCard(
              title: chalet?.chaletName ?? 'منتجع #${booking.chaletId}',
              location: chalet?.location ?? 'غير محدد',
              price: booking.totalPrice,
              rating: 4.8, // Mocked rating
              imageUrl: 'assets/images/chalet_${(booking.chaletId % 6) + 1}.${((booking.chaletId % 6) + 1) > 3 ? 'jpg' : 'png'}',
              onTap: () => context.push('/chalets/${booking.chaletId}'),
            );
          },
        );
      },
    );
  }
}
