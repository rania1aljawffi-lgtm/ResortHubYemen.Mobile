import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically transition to Auth/Home after 2.8 seconds
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        context.go(RouteConstants.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => context.go(RouteConstants.auth),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFCEECF9),
                Color(0xFFFFFFFF),
                Color(0xFFE2F4FD),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Large organic curved shapes on left edge (matching Image 1)
              Positioned(
                top: -size.height * 0.05,
                left: -size.width * 0.45,
                child: Container(
                  width: size.width * 1.1,
                  height: size.height * 0.55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBE4F7).withValues(alpha: 0.55),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.elliptical(250, 350),
                      topRight: Radius.elliptical(200, 200),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.12,
                left: -size.width * 0.35,
                child: Container(
                  width: size.width * 0.85,
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3E0F6).withValues(alpha: 0.45),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.elliptical(220, 280),
                      topRight: Radius.elliptical(180, 200),
                    ),
                  ),
                ),
              ),
              // Soft curved shape on bottom right edge
              Positioned(
                bottom: -size.height * 0.08,
                right: -size.width * 0.3,
                child: Container(
                  width: size.width * 0.75,
                  height: size.height * 0.45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBCE5F7).withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(250, 300),
                      bottomLeft: Radius.elliptical(200, 200),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Exact ResortHub Yemen Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 38),
                      // Exact Arabic Text from Screenshot
                      const Text(
                        'اكتشف أجمل  المنتجعات\nوأحجز تجربتك بسهولة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E2B4C),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
