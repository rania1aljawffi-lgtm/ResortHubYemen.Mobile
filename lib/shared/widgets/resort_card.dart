import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ResortCard extends StatelessWidget {
  final String title;
  final String location;
  final double price;
  final double rating;
  final String imageUrl; // For now a placeholder or asset path
  final VoidCallback onTap;

  const ResortCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.star, color: AppTheme.accentColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Tajawal'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[300],
                child: Image.asset(
                  imageUrl, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'الليلة',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
