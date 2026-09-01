import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/route_constants.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/resort_card.dart';
import '../view_models/chalet_view_model.dart';

class ChaletsScreen extends StatefulWidget {
  const ChaletsScreen({super.key});

  @override
  State<ChaletsScreen> createState() => _ChaletsScreenState();
}

class _ChaletsScreenState extends State<ChaletsScreen> {
  int _currentNavIndex = 1;
  String _selectedCity = 'الكل';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _cities = ['الكل', 'صنعاء', 'عدن', 'ذمار', 'إب', 'تعز'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChaletViewModel>().fetchChalets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final chaletViewModel = context.watch<ChaletViewModel>();
    final allChalets = chaletViewModel.chalets;

    // Filter chalets
    final filteredChalets = allChalets.where((c) {
      bool matchesCity;
      if (_selectedCity == 'الكل') {
        matchesCity = true;
      } else {
        // تقسيم الموقع إلى أجزاء والتحقق من أن المدينة المختارة هي جزء رئيسي
        // وليس مجرد جزء من اسم منطقة أخرى
        final locationParts = c.location
            .split(RegExp(r'[,،\-\s]+'))
            .map((p) => p.trim())
            .where((p) => p.isNotEmpty)
            .toList();
        matchesCity = locationParts.any((part) => part == _selectedCity);
      }
      final query = _searchController.text.trim();
      final matchesQuery = query.isEmpty ||
          c.chaletName.contains(query) ||
          c.location.contains(query);
      return matchesCity && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.primaryColor, size: 20),
                onPressed: () => context.go(RouteConstants.home),
              ),
              const Expanded(
                child: Text(
                  'استكشاف الشاليهات والمنتجعات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              // Logo
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
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: SizedBox(
                height: 48,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم المنتجع أو المدينة...',
                    hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Tajawal', fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // City Filter Chips
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  final isSelected = _selectedCity == city;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        city,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCity = city);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Chalets List
            Expanded(
              child: filteredChalets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_off, size: 64, color: AppTheme.primaryColor),
                          SizedBox(height: 12),
                          Text(
                            'لا توجد منتجعات مطابقة لبحثك',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    )
                  : chaletViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: filteredChalets.length,
                          itemBuilder: (context, index) {
                            final chalet = filteredChalets[index];
                            return ResortCard(
                              title: chalet.chaletName,
                              location: chalet.location,
                              price: chalet.pricePerNight,
                              rating: 4.8, // Mocked rating
                              imageUrl: 'assets/images/chalet_${(chalet.chaletId % 6) + 1}.${((chalet.chaletId % 6) + 1) > 3 ? 'jpg' : 'png'}',
                              onTap: () => context.push('/chalets/${chalet.chaletId}'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
