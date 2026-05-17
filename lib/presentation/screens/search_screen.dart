import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../providers/search_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/track_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                hintStyle:
                    const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: () {
                    context
                        .read<SearchProvider>()
                        .search(_controller.text);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              onSubmitted: (value) {
                context.read<SearchProvider>().search(value);
                FocusScope.of(context).unfocus();
              },
            ),
          ),

          // Chips de tipo + switch explícito
          const SearchBarWidget(),

          // Estados da busca
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                switch (provider.state) {
                  // ── Estado inicial ──
                  case SearchState.initial:
                    return _buildInitialState();

                  // ── Loading com widget animado (Fase 16) ──
                  case SearchState.loading:
                    return const LoadingWidget();

                  // ── Erro com mensagem específica (Fase 16) ──
                  case SearchState.error:
                    return _buildErrorState(provider.errorMessage);

                  // ── Sucesso ──
                  case SearchState.success:
                    if (provider.results.isEmpty) {
                      return _buildEmptyResults();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: provider.results.length,
                      itemBuilder: (context, index) {
                        return TrackCard(track: provider.results[index]);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Estado inicial: convite para buscar =[[[]]] <- preciso nem dizer ne?
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note_outlined,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Descubra músicas',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Busque por músicas, artistas ou álbuns',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Estado de erro: ícone + mensagem específica + botão retry
  Widget _buildErrorState(String message) {
    // Detecta se é erro de conexão ou outro tipo
    final isConnectionError = message.contains('internet') ||
        message.contains('conexão');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnectionError ? Icons.wifi_off : Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              isConnectionError
                  ? AppStrings.noConnection
                  : 'Algo deu errado',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Botão de tentar novamente
            OutlinedButton.icon(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context
                      .read<SearchProvider>()
                      .search(_controller.text);
                }
              },
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              label: const Text(
                'Tentar novamente',
                style: TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Nenhum resultado encontrado ──
  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.noResults,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tente outro termo ou tipo de busca',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}