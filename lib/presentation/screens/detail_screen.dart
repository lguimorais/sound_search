import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/track.dart';
import '../providers/playlist_provider.dart';
import '../widgets/audio_player_widget.dart';

class DetailScreen extends StatefulWidget {
  final Track track;

  const DetailScreen({super.key, required this.track});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _suggestToRadio;

  @override
  void initState() {
    super.initState();
    _suggestToRadio = widget.track.suggestToRadio;
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Capa grande com gradiente ──
            Stack(
              children: [
                Image.network(
                  track.artworkUrl,
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 320,
                    color: AppColors.surface,
                    child: const Icon(Icons.music_note,
                        size: 80, color: AppColors.primary),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withOpacity(0.7),
                          AppColors.background,
                        ],
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.trackName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.artistName,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoGrid(track: track),

                  const SizedBox(height: 16),
              
                  //  Player de preview] naisadfjsd faaaaaaaaaa
                  if (track.previewUrl != null)
                    AudioPlayerWidget(previewUrl: track.previewUrl!),

                  const SizedBox(height: 20),

                  // ── Checkbox suggestToRadio ──
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      title: const Text(
                        AppStrings.suggestRadio,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        'Marque para sugerir esta música à rádio',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      value: _suggestToRadio,
                      activeColor: AppColors.primary,
                      checkColor: AppColors.textPrimary,
                      onChanged: (value) {
                        setState(() {
                          _suggestToRadio = value ?? false;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Botão Salvar conectado ao PlaylistProvider ──
                  Consumer<PlaylistProvider>(
                    builder: (context, playlist, _) {
                      final isSaved = playlist.isTrackSaved(track.trackId);
                      return FutureBuilder<bool>(
                        future: isSaved,
                        builder: (context, snapshot) {
                          final saved = snapshot.data ?? false;
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: saved
                                  ? null
                                  : () async {
                                      await playlist.saveTrack(
                                        track,
                                        suggestToRadio: _suggestToRadio,
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                AppStrings.savedSuccess),
                                            backgroundColor:
                                                AppColors.success,
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                              icon: Icon(saved
                                  ? Icons.check
                                  : Icons.playlist_add),
                              label: Text(
                                saved
                                    ? 'Já está na Playlist'
                                    : 'Salvar na Playlist',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: saved
                                    ? AppColors.surface
                                    : AppColors.primary,
                                foregroundColor: saved
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final Track track;

  const _InfoGrid({required this.track});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Álbum', track.collectionName),
      ('Gênero', track.genre),
      ('Duração', track.formattedDuration),
      ('Preço', track.formattedPrice),
      ('Explícito', track.isExplicit ? 'Sim' : 'Não'),
      ('Preview', track.previewUrl != null ? 'Disponível' : 'Indisponível'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: items.map((item) {
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.$1,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11)),
              const SizedBox(height: 2),
              Text(
                item.$2,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}