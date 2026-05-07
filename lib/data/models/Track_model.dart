import '../../domain/entities/track.dart';

class TrackModel extends Track {
  TrackModel({
    required super.trackId,
    required super.trackName,
    required super.artistName,
    required super.collectionName,
    required super.previewUrl,
    required super.artworkUrl,
    required super.genre,
    required super.trackTimeMillis,
    required super.trackPrice,
    required super.isExplicit,
    super.suggestToRadio,
  });
}
