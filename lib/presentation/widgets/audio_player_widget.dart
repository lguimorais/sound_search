import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/app_colors.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String previewUrl;

  const AudioPlayerWidget({super.key, required this.previewUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioPlayer _player;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.previewUrl);
      if (mounted) setState(() => _isReady = true);
    } catch (_) {
      // preview indisponível — não faz nada "ah mas dai é ruim pq o usuário não sabe pq não funciona" — aí é só não mostrar o player, ou mostrar um texto "preview indisponível"
    }
  }

  @override
  void dispose() {
    _player.dispose(); // libera recursos — é importante pra não lagar
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primary),
            ),
            SizedBox(width: 10),
            Text(
              'Carregando preview...',
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          const Row(
            children: [
              Icon(Icons.headphones, color: AppColors.primary, size: 16),
              SizedBox(width: 6),
              Text(
                'Preview — 30 segundos',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barra de progresso reativa
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final total = _player.duration ?? const Duration(seconds: 30);
              final progress =
                  total.inMilliseconds > 0
                      ? (position.inMilliseconds / total.inMilliseconds)
                          .clamp(0.0, 1.0)
                      : 0.0;

              return Column(
                children: [
                  // Barra de progresso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Tempo atual / total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        _formatDuration(total),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 8),

          // Botão play/pause reativo
          Center(
            child: StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final isPlaying = state?.playing ?? false;
                final processingState = state?.processingState;

                // Se terminou, volta ao início automaticamente
                if (processingState == ProcessingState.completed) {
                  _player.seek(Duration.zero);
                  _player.pause();
                }

                return GestureDetector(
                  onTap: () {
                    if (isPlaying) {
                      _player.pause();
                    } else {
                      _player.play();
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.textPrimary,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}