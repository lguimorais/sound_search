import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/datasources/itunes_remote_datasource.dart';
import '../providers/search_provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips de tipo de busca
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: SearchType.values.map((type) {
                final isSelected = provider.searchType == type;
                final label = switch (type) {
                  SearchType.song => 'Músicas',
                  SearchType.album => 'Álbuns',
                  SearchType.artist => 'Artistas',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: (_) =>
                          context.read<SearchProvider>().setSearchType(type),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      showCheckmark: false,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Switch conteúdo explícito
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.suggestRadio,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              // Reutilizamos o campo "explicitFilter" como toggle on/off
              Row(
                children: [
                  const Text(
                    'Ocultar explícito',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: provider.explicitFilter == false,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      context
                          .read<SearchProvider>()
                          .setExplicitFilter(value ? false : null);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}