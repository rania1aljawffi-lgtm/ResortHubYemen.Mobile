import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../view_models/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 3;

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final user = profileVm.user ?? authVm.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 40,
                width: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.beach_access,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppTheme.primaryColor,
                          child: const Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user != null ? user.fullName : 'زائر كريم',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user != null ? user.email : 'سجل الدخول للاستمتاع بكافة المزايا',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (user == null)
                      ElevatedButton.icon(
                        onPressed: () => context.push(RouteConstants.auth),
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text(
                          'تسجيل الدخول / حساب جديد',
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu Sections
              _buildMenuSection(
                title: 'إدارة الحساب',
                items: [
                  _buildMenuItem(
                    icon: Icons.calendar_month_outlined,
                    title: 'حجوزاتي',
                    subtitle: 'عرض وتتبع حجوزاتك الحالية والسابقة',
                    onTap: () => context.go(RouteConstants.bookings),
                  ),
                  _buildMenuItem(
                    icon: Icons.star_rate_outlined,
                    title: 'تقييماتي',
                    subtitle: 'التقييمات والآراء التي شاركتها',
                    onTap: () => context.push(RouteConstants.reviews),
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_border,
                    title: 'المفضلة',
                    subtitle: 'المنتجعات والشاليهات المحفوظة',
                    onTap: () => context.go(RouteConstants.chalets),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildMenuSection(
                title: 'الإعدادات والدعم',
                items: [
                  _buildMenuItem(
                    icon: Icons.language,
                    title: 'اللغة',
                    subtitle: 'العربية',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('إعدادات اللغة قيد التطوير')),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'مركز المساعدة وخدمة العملاء',
                    subtitle: 'تواصل معنا 24/7 لأي استفسار',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('مركز المساعدة قيد التطوير')),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'سياسة الخصوصية والشروط',
                    subtitle: 'تعرف على حقوقك وسياسة الاستخدام',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('سياسة الخصوصية قيد التطوير')),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (user != null)
                OutlinedButton.icon(
                  onPressed: () => authVm.logout(),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              const SizedBox(height: 20),
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

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 18, top: 14, bottom: 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppTheme.primaryColor,
          fontFamily: 'Tajawal',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontFamily: 'Tajawal',
        ),
      ),
      trailing: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
