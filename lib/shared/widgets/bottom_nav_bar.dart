import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/route_constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _navigate(BuildContext context, int index) {
    onTap(index);
    switch (index) {
      case 0:
        context.go(RouteConstants.home);
        break;
      case 1:
        context.go(RouteConstants.chalets);
        break;
      case 2:
        context.go(RouteConstants.bookings);
        break;
      case 3:
        context.go(RouteConstants.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2B4C),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.home),
          _buildNavItem(context, 1, Icons.search),
          _buildNavItem(context, 2, Icons.calendar_month),
          _buildNavItem(context, 3, Icons.person),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => _navigate(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFBED7EA),
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF1E2B4C),
          size: 26,
        ),
      ),
    );
  }
}
