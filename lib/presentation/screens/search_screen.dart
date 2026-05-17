import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../providers/search_provider.dart';
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
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textSecondary),
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

          // chips de tipo + switch explíc nao to conseguindo enxergar o teclado pra apagar e arrumarso sei as teclas decorardas, nao sei o apagar aaaa

            const SearchBarWidget(),

          // Resultados
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                switch (provider.state) {
                  case SearchState.initial:
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note_outlined,
                              size: 80, color: AppColors.primary),
                          SizedBox(height: 16),
                          Text(
                            'Busque por uma música ou artista',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );

                  case SearchState.loading:
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );

                  case SearchState.error:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 60, color: AppColors.error),
                          const SizedBox(height: 16),
                          Text(
                            provider.errorMessage,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );

                  case SearchState.success:
                    if (provider.results.isEmpty) {
                      return const Center(
                        child: Text(
                          AppStrings.noResults,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.results.length,
                      itemBuilder: (context, index) {
                        return TrackCard(
                            track: provider.results[index]);
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
}