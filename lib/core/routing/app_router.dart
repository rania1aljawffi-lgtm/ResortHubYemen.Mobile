import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_constants.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/chalets/screens/chalets_screen.dart';
import '../../features/chalets/screens/chalet_details_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/bookings/screens/booking_checkout_screen.dart';
import '../../features/bookings/screens/payment_method_screen.dart';
import '../../features/bookings/screens/booking_success_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/reviews/screens/reviews_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

/// Central GoRouter configuration.
class AppRouter {
  AppRouter._();

  /// Tracks whether the splash has been shown in this session.
  static bool _splashShown = false;

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    redirect: (context, state) {
      final isSplash = state.matchedLocation == RouteConstants.splash;

      // Always allow the splash to show on first launch
      if (isSplash && !_splashShown) {
        _splashShown = true;
        return null; // allow splash
      }

      // If somehow navigating to splash after it was shown, go home instead
      if (isSplash && _splashShown) {
        return RouteConstants.home;
      }

      return null; // allow all other routes
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteConstants.chalets,
        builder: (context, state) => const ChaletsScreen(),
      ),
      GoRoute(
        path: RouteConstants.chaletDetails,
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idStr) ?? 0;
          return ChaletDetailsScreen(chaletId: id);
        },
      ),
      GoRoute(
        path: RouteConstants.bookings,
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: RouteConstants.bookingCheckout,
        builder: (context, state) {
          final chaletId = state.extra is int ? state.extra as int : 1;
          return BookingCheckoutScreen(chaletId: chaletId);
        },
      ),
      GoRoute(
        path: RouteConstants.paymentMethod,
        builder: (context, state) {
          final extra = state.extra;
          return PaymentMethodScreen(bookingDetails: extra);
        }
      ),
      GoRoute(
        path: RouteConstants.bookingSuccess,
        builder: (context, state) => const BookingSuccessScreen(),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteConstants.reviews,
        builder: (context, state) => const ReviewsScreen(),
      ),
      GoRoute(
        path: RouteConstants.auth,
        builder: (context, state) => const AuthScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('No route defined for ${state.uri}'),
      ),
    ),
  );
}
