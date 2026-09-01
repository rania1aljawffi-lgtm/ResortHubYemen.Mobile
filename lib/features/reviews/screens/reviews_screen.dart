import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_button.dart';

import 'package:provider/provider.dart';
import '../view_models/review_view_model.dart';
import '../../chalets/view_models/chalet_view_model.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../../data/models/review_model.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewViewModel>().fetchReviews();
      context.read<ChaletViewModel>().fetchChalets();
    });
  }

  void _showAddReviewDialog() {
    int selectedRating = 5;
    final commentController = TextEditingController();
    int? selectedChaletId;
    final chalets = context.read<ChaletViewModel>().chalets;

    if (chalets.isNotEmpty) {
      selectedChaletId = chalets.first.chaletId;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (builderContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(builderContext).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Text(
                          'أضف تقييمك',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // اختيار الشاليه
                        const Text(
                          'اختر المنتجع',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: selectedChaletId,
                              isExpanded: true,
                              hint: const Text('اختر المنتجع', style: TextStyle(fontFamily: 'Tajawal')),
                              items: chalets.map((c) {
                                return DropdownMenuItem<int>(
                                  value: c.chaletId,
                                  child: Text(
                                    c.chaletName,
                                    style: const TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setModalState(() => selectedChaletId = value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // التقييم بالنجوم
                        const Text(
                          'التقييم',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setModalState(() => selectedRating = index + 1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Icon(
                                  Icons.star,
                                  size: 36,
                                  color: index < selectedRating
                                      ? AppTheme.accentColor
                                      : Colors.grey[300],
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        // التعليق
                        const Text(
                          'تعليقك',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: commentController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'اكتب تعليقك هنا...',
                            hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                          ),
                          style: const TextStyle(fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 24),

                        // زر الإرسال
                        CustomButton(
                          text: 'إرسال التقييم',
                          onPressed: () async {
                            if (selectedChaletId == null) {
                              ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء اختيار المنتجع', style: TextStyle(fontFamily: 'Tajawal')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (commentController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء كتابة تعليق', style: TextStyle(fontFamily: 'Tajawal')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final authVM = context.read<AuthViewModel>();
                            final userId = authVM.currentUser?.userId ?? 1;

                            final review = ReviewModel(
                              reviewId: 0,
                              userId: userId,
                              chaletId: selectedChaletId!,
                              rating: selectedRating,
                              comment: commentController.text.trim(),
                              reviewDate: DateTime.now(),
                            );

                            final reviewVM = context.read<ReviewViewModel>();
                            final success = await reviewVM.addReview(review);

                            if (!mounted) return;

                            Navigator.of(bottomSheetContext).pop();

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إضافة التقييم بنجاح!', style: TextStyle(fontFamily: 'Tajawal')),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // إعادة تحميل التقييمات
                              reviewVM.fetchReviews();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'فشل إضافة التقييم: ${reviewVM.error?.message ?? "خطأ غير معروف"}',
                                    style: const TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'التقييمات والآراء',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer2<ReviewViewModel, ChaletViewModel>(
          builder: (context, reviewViewModel, chaletViewModel, child) {
            if (reviewViewModel.isLoading || chaletViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final reviews = reviewViewModel.reviews;
            
            // Calculate overall rating
            double overallRating = 0;
            if (reviews.isNotEmpty) {
              overallRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              children: [
                // Overall Rating Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            overallRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star, 
                                color: i < overallRating.round() ? AppTheme.accentColor : Colors.grey[300], 
                                size: 20
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'بناءً على ${reviews.length} تقييم',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Tajawal'),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 60, color: Colors.grey[300]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRatingBar('النظافة', 0.95),
                          _buildRatingBar('الخدمة', 0.90),
                          _buildRatingBar('الموقع', 0.88),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'أحدث التقييمات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 12),

                if (reviews.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('لا توجد تقييمات حتى الآن', style: TextStyle(fontFamily: 'Tajawal')),
                    ),
                  )
                else
                  ...reviews.map((r) => _buildReviewCard(r, chaletViewModel)),

                const SizedBox(height: 20),
                CustomButton(
                  text: 'أضف تقييمك الآن',
                  onPressed: _showAddReviewDialog,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRatingBar(String title, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              title,
              style: const TextStyle(fontSize: 11, fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review, ChaletViewModel chaletVM) {
    final chaletName = chaletVM.chalets.where((c) => c.chaletId == review.chaletId).firstOrNull?.chaletName ?? 'منتجع غير محدد';
    final userName = 'مستخدم #${review.userId}';
    final dateStr = '${review.reviewDate.day}/${review.reviewDate.month}/${review.reviewDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                    radius: 18,
                    child: Text(
                      userName[0],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        chaletName,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600], fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 15,
                        color: i < review.rating ? AppTheme.accentColor : Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'Tajawal'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.primaryColor,
              height: 1.4,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}
