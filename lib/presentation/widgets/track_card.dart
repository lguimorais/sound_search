import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/track.dart';
import '../screens/detail_screen.dart';

class TrackCard extends StatelessWidget {
  final Track track;

  const TrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final artworkSize = Responsive.artworkSize(context);
    final fontSize = Responsive.cardFontSize(context);
    final hPadding = Responsive.horizontalPadding(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(track: track)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: hPadding, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Capa
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
            // Textos
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
                  const SizedBox(height: 4),
                  Text(
                    track.artistName,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: fontSize - 2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.collectionName,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: fontSize - 3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Duração + play
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.play_circle_outline,
                    color: AppColors.primary, size: 28),
                const SizedBox(height: 4),
                Text(
                  track.formattedDuration,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}