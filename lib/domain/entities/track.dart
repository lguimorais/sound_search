
class Track {
  final int trackId;
  final String trackName;
  final String artistName;
  final String collectionName;
  final String artworkUrl;
  final String? previewUrl; // Pode ser nulo — nem toda faixa tem preview
  final String genre;
  final int trackTimeMillis; // Duração em milissegundos
  final double trackPrice;
  final bool isExplicit;
  final bool suggestToRadio;

  const Track({
    required this.trackId,
    required this.trackName,
    required this.artistName,
    required this.collectionName,
    required this.artworkUrl,
    this.previewUrl,
    required this.genre,
    required this.trackTimeMillis,
    required this.trackPrice,
    required this.isExplicit,
    this.suggestToRadio = false, // Valor padrão
  });

  String get formattedDuration {
    final duration = Duration(milliseconds: trackTimeMillis);
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedPrice {
    if (trackPrice <= 0) return 'Grátis';
    return 'R\$ ${trackPrice.toStringAsFixed(2)}';
  }
}
