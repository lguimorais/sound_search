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
  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      trackId: json['trackId'] ?? json['collectionId'] ?? 0,
      trackName: json['trackName'] ?? json['collectionName'] ?? 'Desconhecido',
      artistName: json['artistName'] ?? 'Artista Desconhecido',
      collectionName: json['collectionName'] ?? '',

      artworkUrl: (json['artworkUrl100'] as String? ?? '').replaceAll(
        '100x100',
        '300x300',
      ),

      previewUrl: json['previewUrl'] as String?,
      genre: json['primaryGenreName'] ?? 'Desconhecido',
      trackTimeMillis: json['trackTimeMillis'] ?? 0,
      trackPrice: (json['trackPrice'] ?? 0.0).toDouble(),
      isExplicit: json['trackExplicitness'] == 'explicit',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'trackName': trackName,
      'artistName': artistName,
      'collectionName': collectionName,
      'artworkUrl': artworkUrl,
      'previewUrl': previewUrl ?? '',
      'genre': genre,
      'trackTimeMillis': trackTimeMillis,
      'trackPrice': trackPrice,
      'isExplicit': isExplicit ? 1 : 0, // SQLite não tem bool, usa 0/1
      'suggestToRadio': suggestToRadio ? 1 : 0,
    };
  }
  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      trackId: map['trackId'] as int,
      trackName: map['trackName'] as String,
      artistName: map['artistName'] as String,
      collectionName: map['collectionName'] as String,
      artworkUrl: map['artworkUrl'] as String,
      previewUrl: map['previewUrl'] as String?,
      genre: map['genre'] as String,
      trackTimeMillis: map['trackTimeMillis'] as int,
      trackPrice: map['trackPrice'] as double,
      isExplicit: map['isExplicit'] == 1,
      suggestToRadio: map['suggestToRadio'] == 1,
    );
  }

  TrackModel copyWith({bool? suggestToRadio}) {
    return TrackModel(
      trackId: trackId,
      trackName: trackName,
      artistName: artistName,
      collectionName: collectionName,
      artworkUrl: artworkUrl,
      previewUrl: previewUrl,
      genre: genre,
      trackTimeMillis: trackTimeMillis,
      trackPrice: trackPrice,
      isExplicit: isExplicit,
      suggestToRadio: suggestToRadio ?? this.suggestToRadio,
    );
  }
}
