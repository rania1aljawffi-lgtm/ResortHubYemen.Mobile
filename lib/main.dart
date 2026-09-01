import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/booking_repository.dart';
import 'data/repositories/chalet_repository.dart';
import 'data/repositories/image_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/services/booking_service.dart';
import 'data/services/chalet_service.dart';
import 'data/services/image_service.dart';
import 'data/services/review_service.dart';
import 'data/services/user_service.dart';
import 'features/auth/view_models/auth_view_model.dart';
import 'features/bookings/view_models/booking_view_model.dart';
import 'features/chalets/view_models/chalet_view_model.dart';
import 'features/home/view_models/home_view_model.dart';
import 'features/profile/view_models/profile_view_model.dart';
import 'features/reviews/view_models/review_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ResortHubApp());
}

class ResortHubApp extends StatelessWidget {
  const ResortHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Network / Client
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),

        // Services
        ProxyProvider<ApiClient, IChaletService>(
          update: (_, client, __) => ChaletService(apiClient: client),
        ),
        ProxyProvider<ApiClient, IBookingService>(
          update: (_, client, __) => BookingService(apiClient: client),
        ),
        ProxyProvider<ApiClient, IUserService>(
          update: (_, client, __) => UserService(apiClient: client),
        ),
        ProxyProvider<ApiClient, IReviewService>(
          update: (_, client, __) => ReviewService(apiClient: client),
        ),
        ProxyProvider<ApiClient, IImageService>(
          update: (_, client, __) => ImageService(apiClient: client),
        ),

        // Repositories
        ProxyProvider<IChaletService, IChaletRepository>(
          update: (_, service, __) => ChaletRepository(chaletService: service),
        ),
        ProxyProvider<IBookingService, IBookingRepository>(
          update: (_, service, __) => BookingRepository(bookingService: service),
        ),
        ProxyProvider<IUserService, IUserRepository>(
          update: (_, service, __) => UserRepository(userService: service),
        ),
        ProxyProvider<IReviewService, IReviewRepository>(
          update: (_, service, __) => ReviewRepository(reviewService: service),
        ),
        ProxyProvider<IImageService, IImageRepository>(
          update: (_, service, __) => ImageRepository(imageService: service),
        ),

        // ViewModels
        ChangeNotifierProxyProvider<IChaletRepository, ChaletViewModel>(
          create: (ctx) => ChaletViewModel(
            chaletRepository: ctx.read<IChaletRepository>(),
          ),
          update: (_, repo, vm) => vm ?? ChaletViewModel(chaletRepository: repo),
        ),
        ChangeNotifierProxyProvider<IBookingRepository, BookingViewModel>(
          create: (ctx) => BookingViewModel(
            bookingRepository: ctx.read<IBookingRepository>(),
          ),
          update: (_, repo, vm) => vm ?? BookingViewModel(bookingRepository: repo),
        ),
        ChangeNotifierProxyProvider<IUserRepository, AuthViewModel>(
          create: (ctx) => AuthViewModel(
            userRepository: ctx.read<IUserRepository>(),
          ),
          update: (_, repo, vm) => vm ?? AuthViewModel(userRepository: repo),
        ),
        ChangeNotifierProxyProvider<IUserRepository, ProfileViewModel>(
          create: (ctx) => ProfileViewModel(
            userRepository: ctx.read<IUserRepository>(),
          ),
          update: (_, repo, vm) => vm ?? ProfileViewModel(userRepository: repo),
        ),
        ChangeNotifierProxyProvider<IReviewRepository, ReviewViewModel>(
          create: (ctx) => ReviewViewModel(
            reviewRepository: ctx.read<IReviewRepository>(),
          ),
          update: (_, repo, vm) => vm ?? ReviewViewModel(reviewRepository: repo),
        ),
        ChangeNotifierProxyProvider<IChaletRepository, HomeViewModel>(
          create: (ctx) => HomeViewModel(
            chaletRepository: ctx.read<IChaletRepository>(),
          ),
          update: (_, repo, vm) => vm ?? HomeViewModel(chaletRepository: repo),
        ),
      ],
      child: MaterialApp.router(
        title: 'ResortHub Yemen',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
