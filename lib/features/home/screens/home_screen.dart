import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/resort_card.dart';
import '../../../core/theme/app_theme.dart';
import '../view_models/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHomeData();
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              // Logo
              GestureDetector(
                onTap: () => context.go(RouteConstants.home),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.beach_access, color: AppTheme.primaryColor, size: 24),
                      Text('ResortHub', style: TextStyle(fontSize: 8, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Search field
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن وجهتك القادمة',
                      hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
                      suffixIcon: const Icon(Icons.search, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Login button
              GestureDetector(
                onTap: () => context.go(RouteConstants.auth),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'دخول',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          children: [
            // Section title
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'المنتجعات المميزة',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            Consumer<HomeViewModel>(
              builder: (context, homeViewModel, child) {
                if (homeViewModel.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                  );
                }
                
                if (homeViewModel.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        'خطأ: ${homeViewModel.errorMessage}',
                        style: const TextStyle(color: Colors.red, fontFamily: 'Tajawal'),
                      ),
                    ),
                  );
                }
                
                final chalets = homeViewModel.featuredChalets;
                if (chalets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        'لا توجد منتجعات متوفرة حالياً.',
                        style: TextStyle(fontFamily: 'Tajawal', color: AppTheme.primaryColor),
                      ),
                    ),
                  );
                }

                return Column(
                  children: chalets.take(3).map((chalet) {
                    return ResortCard(
                      title: chalet.chaletName,
                      location: chalet.location,
                      price: chalet.pricePerNight,
                      rating: 4.8, // Mocked rating as API doesn't provide rating per chalet yet
                      imageUrl: 'assets/images/chalet_${(chalet.chaletId % 6) + 1}.${((chalet.chaletId % 6) + 1) > 3 ? 'jpg' : 'png'}',
                      onTap: () => context.push('/chalets/${chalet.chaletId}'),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
