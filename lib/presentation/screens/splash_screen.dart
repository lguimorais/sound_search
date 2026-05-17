import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sound_search/main.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

// SplashScreen usa pushReplacement para ir para MainNavigation
// sem rotas nomeadas — encaixa no seu main atual sem mudar nada
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // pushReplacement com MaterialPageRoute — sem precisar de rotas nomeadas
    // Remove a splash da pilha e coloca o MainNavigation no lugar
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        // Duração da transição entre splash e home
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) {
          // Importa o MainNavigation do seu main.dart
          // Como está no mesmo arquivo, só referencia a classe
          return const _HomeWrapper();
        },
        // Transição de fade entre splash e home
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone animado
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(scale: _scaleAnimation, child: child),
              ),
              child: _buildLogo(),
            ),

            const SizedBox(height: 32),

            // Nome e subtítulo
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descubra novas músicas',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),

            // Spinner sutil no rodapé
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surface,
            child: Icon(
              Icons.music_note_rounded,
              size: 64,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// Wrapper para o MainNavigation
// Separado aqui para não criar dependência circular com o main.dart
class _HomeWrapper extends StatelessWidget {
  const _HomeWrapper();

  @override
  Widget build(BuildContext context) {
    // Importa o MainNavigation que já existe no seu main.dart
    // Como SplashScreen está dentro da árvore do MultiProvider,
    // os providers já estão disponíveis aqui
    return const MainNavigation(); // ← classe que já existe no seu main.dart
  }
}
