import 'package:flutter/material.dart';

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
      title: 'SoundSearch',
      debugShowCheckedModeBanner: false, // Remove o banner vermelho "DEBUG"
      theme: ThemeData(
        // useMaterial3: visual moderno do Material Design 3
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(
            0xFF6C63FF,
          ), // Roxo vibrante — do AppColors do documento
          secondary: const Color(0xFFFF6584), // Rosa coral
          surface: const Color(0xFF1E1E2E), // Superfície dos cards
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A), // Fundo escuro
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
          '🎵 SoundSearch',
          style: TextStyle(
            color: Color(0xFF6C63FF), // primary
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
            Icon(Icons.music_note_outlined, size: 80, color: Color(0xFF6C63FF)),
            SizedBox(height: 16), // Espaçador — equivale a margin
            Text(
              'Descubra novas músicas',
              style: TextStyle(
                color: Color(0xFF9E9E9E), // textSecondary
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A busca vem na próxima fase 🚀',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
