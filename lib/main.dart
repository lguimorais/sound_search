import 'package:flutter/material.dart';
import 'package:sound_search/core/constants/app_colors.dart';
import 'package:sound_search/core/constants/app_strings.dart';
import 'package:sound_search/data/datasources/itunes_remote_datasource.dart';

// main() é o ponto de entrada do app — como o int main() do C
// runApp() pega o widget raiz e coloca na tela
void main() {
  runApp(const SoundSearchApp());
  
}

// StatelessWidget: widget que nunca muda depois de construído
// A aplicação inteira começa aqui
class SoundSearchApp extends StatelessWidget {
  const SoundSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: configura rotas, tema e título do app
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false, // Remove o banner vermelho "DEBUG"
      theme: ThemeData(
        // useMaterial3: visual moderno do Material Design 3
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary:
              AppColors.primary, // Roxo vibrante — do AppColors do documento
          secondary: AppColors.accent, // Rosa coral
          surface: AppColors.onSurface, // Superfície dos cards
        ),
        scaffoldBackgroundColor: AppColors.background, // Fundo escuro
      ),
      home: const SearchScreen(),
    );
  }
}

// Por enquanto, a SearchScreen é simples — vai crescer nas próximas fases
// StatelessWidget porque ainda não tem estado para gerenciar
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: estrutura base de uma tela (AppBar + body + bottomBar etc.)
    return Scaffold(
      appBar: AppBar(
        // backgroundColor transparent + elevation 0 = AppBar limpo
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            color: AppColors.primary, // primary
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      // Center + Column: centraliza o conteúdo na tela
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_outlined, size: 80, color: AppColors.primary),
            SizedBox(height: 16), // Espaçador — equivale a margin
            Text(
              AppStrings.playlistEmpty,
              style: TextStyle(
                color: AppColors.textSecondary, // textSecondary
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A busca vem na próxima fase 🚀',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
