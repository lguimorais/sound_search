import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/track.dart';
import '../providers/playlist_provider.dart';
import '../screens/detail_screen.dart';

class PlaylistCard extends StatelessWidget {
  final Track track;

  const PlaylistCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final artworkSize = Responsive.artworkSize(context);
    final fontSize = Responsive.cardFontSize(context);
    final hPadding = Responsive.horizontalPadding(context);

    return Dismissible(
      key: Key('playlist_${track.trackId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: hPadding, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline,
            color: AppColors.textPrimary, size: 28),
      ),
      onDismissed: (_) {
        context.read<PlaylistProvider>().deleteTrack(track.trackId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.removedSuccess),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(track: track)),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: hPadding, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  track.artworkUrl,
                  width: artworkSize,
                  height: artworkSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: artworkSize,
                    height: artworkSize,
                    color: AppColors.background,
                    child: const Icon(Icons.music_note,
                        color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.trackName,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      track.artistName,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: fontSize - 2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (track.suggestToRadio) ...[
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary, width: 0.8),
                        ),
                        child: const Text(
                          '🎙 Para a rádio',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    track.formattedDuration,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  const Icon(Icons.swipe_left_outlined,
                      color: AppColors.textSecondary, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}