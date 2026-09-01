import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/custom_button.dart';

import 'package:provider/provider.dart';
import '../view_models/chalet_view_model.dart';

class ChaletDetailsScreen extends StatefulWidget {
  final int chaletId;

  const ChaletDetailsScreen({super.key, required this.chaletId});

  @override
  State<ChaletDetailsScreen> createState() => _ChaletDetailsScreenState();
}

class _ChaletDetailsScreenState extends State<ChaletDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChaletViewModel>().fetchChaletById(widget.chaletId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'تفاصيل المنتج',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.beach_access, color: AppTheme.primaryColor),
                const Text('ResortHub', style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Consumer<ChaletViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }
          
          final chalet = viewModel.selectedChalet;
          if (chalet == null) {
            return const Center(child: Text('المنتجع غير موجود', style: TextStyle(fontFamily: 'Tajawal')));
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Image.asset(
                              'assets/images/chalet_${(chalet.chaletId % 6) + 1}.${((chalet.chaletId % 6) + 1) > 3 ? 'jpg' : 'png'}', 
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Title, Rating and Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chalet.chaletName,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontFamily: 'Tajawal'),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'الموقع: ${chalet.location}',
                                  style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor, fontFamily: 'Tajawal'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppTheme.accentColor, size: 24),
                                const SizedBox(width: 4),
                                const Text('4.9', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontFamily: 'Tajawal')),
                                const SizedBox(width: 4),
                                const Text('الليلة', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'Tajawal')),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          chalet.description.isNotEmpty ? chalet.description : 'وصف غير متوفر',
                          style: const TextStyle(fontSize: 16, color: AppTheme.primaryColor, height: 1.6, fontWeight: FontWeight.w600, fontFamily: 'Tajawal'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Amenities
                        const Text(
                          'المرافق والخدمات',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildAmenityIcon(Icons.pool, 'مسبح خاص'),
                            _buildAmenityIcon(Icons.king_bed, 'غرف ملكية'),
                            _buildAmenityIcon(Icons.wifi, 'واي فاي سريع'),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Reviews (Mocked until Review integration if applicable, but per plan Review integration is in ReviewsScreen)
                        const Text(
                          'تقييمات الزوار',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 16),
                        _buildReviewCard('رانيا الجوفي', 'المنتجع تم تجربته وصرررراحه في قمة الفخامه', 5),
                        const SizedBox(height: 12),
                        _buildReviewCard('روان عامر', 'منتجع المثالي هو فعلاً مثالي', 4),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  decoration: const BoxDecoration(
                    color: AppTheme.secondaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          text: 'احجز الآن',
                          onPressed: () => context.push(RouteConstants.bookingCheckout, extra: chalet.chaletId),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${chalet.pricePerNight}\$',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontFamily: 'Tajawal'),
                          ),
                          const SizedBox(width: 4),
                          const Text('الليلة', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmenityIcon(IconData icon, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 28),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String comment, int rating) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    radius: 16,
                    child: Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Tajawal')),
                  ),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontFamily: 'Tajawal')),
                ],
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 16,
                    color: index < rating ? AppTheme.accentColor : Colors.grey[400],
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(comment, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }
}
