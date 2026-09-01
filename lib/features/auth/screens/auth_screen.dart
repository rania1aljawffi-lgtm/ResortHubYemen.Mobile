import '../../../data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/route_constants.dart';
import '../view_models/auth_view_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login Controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Register Controllers
  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default to Login tab
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPhoneController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    final email = _loginEmailController.text.trim();
    if (email.isNotEmpty) {
      final viewModel = context.read<AuthViewModel>();
      final success = await viewModel.login(email);
      if (success) {
        if (mounted) context.go(RouteConstants.home);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.error?.message ?? 'فشل تسجيل الدخول')),
          );
        }
      }
    }
  }

  void _onRegisterPressed() async {
    final name = _regNameController.text.trim();
    final email = _regEmailController.text.trim();
    final phone = _regPhoneController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الاسم والبريد الإلكتروني')),
      );
      return;
    }

    final viewModel = context.read<AuthViewModel>();
    final user = UserModel(
      userId: 0,
      fullName: name,
      email: email,
      phoneNumber: phone,
      role: 'User'
    );
    final success = await viewModel.register(user);
    if (success) {
      if (mounted) context.go(RouteConstants.home);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.error?.message ?? 'فشل إنشاء الحساب')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF0FA),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFCEECF9),
                Color(0xFFE8F6FD),
                Color(0xFFD8EFF9),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Ambient blue circles matching screenshot
              Positioned(
                top: -80,
                left: -60,
                child: CircleAvatar(
                  radius: 140,
                  backgroundColor: const Color(0xFFBCE5F7).withValues(alpha: 0.5),
                ),
              ),
              Positioned(
                bottom: -80,
                right: -60,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: const Color(0xFFBCE5F7).withValues(alpha: 0.5),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E2B4C).withValues(alpha: 0.06),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Exact Logo
                          Image.asset(
                            'assets/images/logo.png',
                            height: 95,
                            width: 95,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'وجهتك الفاخرة للاسترخاء والجمال',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2B4C),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFF1E2B4C), thickness: 1),
                          const SizedBox(height: 12),

                          // Tabs matching exact screenshot
                          TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xFF1E2B4C),
                            unselectedLabelColor: const Color(0xFF1E2B4C),
                            indicatorColor: const Color(0xFF1E2B4C),
                            indicatorWeight: 3.5,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Tajawal',
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              fontFamily: 'Tajawal',
                            ),
                            tabs: const [
                              Tab(text: 'تسجيل الدخول'),
                              Tab(text: 'إنشاء حساب'),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Tab Content
                          AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, _) {
                              return _tabController.index == 0
                                  ? _buildLoginTab()
                                  : _buildRegisterTab();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return Column(
      key: const ValueKey('login_tab'),
      children: [
        const SizedBox(height: 8),
        _buildTextField(
          controller: _loginEmailController,
          hint: 'البريد الإلكتروني',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _loginPasswordController,
          hint: 'كلمة المرور',
          obscureText: true,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('خدمة استعادة كلمة المرور قيد التطوير')),
              );
            },
            child: const Text(
              'نسيت كلمة المرور؟',
              style: TextStyle(
                color: Color(0xFF1E2B4C),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          text: 'تسجيل الدخول',
          onPressed: _onLoginPressed,
        ),
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(child: Divider(color: Color(0xFF1E2B4C), thickness: 2)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'او',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2B4C),
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFF1E2B4C), thickness: 2)),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            context.read<AuthViewModel>().setUserData(
                  fullName: 'مستخدم Google',
                  email: 'user.google@gmail.com',
                );
            context.go(RouteConstants.home);
          },
          child: Image.asset(
            'assets/images/google_logo.png',
            height: 42,
            width: 42,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'من خلال تسجيل الدخول فإنك توافق على\nشروط الاستخدام وسياسة الخصوصية الخاصة بنا',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF1E2B4C),
            height: 1.4,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterTab() {
    return Column(
      key: const ValueKey('register_tab'),
      children: [
        const SizedBox(height: 8),
        _buildTextField(
          controller: _regNameController,
          hint: 'الاسم كامل',
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _regEmailController,
          hint: 'البريد الإلكتروني',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _regPhoneController,
          hint: 'رقم الهاتف',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _regPasswordController,
          hint: 'كلمة المرور',
          obscureText: true,
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          text: 'إنشاء حساب',
          onPressed: _onRegisterPressed,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 15,
          color: Color(0xFF1E2B4C),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF1E2B4C).withValues(alpha: 0.5),
            fontFamily: 'Tajawal',
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1E2B4C), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1E2B4C), width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E2B4C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }
}
