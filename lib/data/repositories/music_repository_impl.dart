import 'package:sound_search/data/datasources/itunes_remote_datasource.dart';
import 'package:sound_search/data/datasources/playlist_local_datasource.dart';
import 'package:sound_search/data/models/Track_model.dart';
import 'package:sound_search/domain/entities/track.dart';
import 'package:sound_search/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final IItunesRemoteDatasource remoteDataSource;
  final DatabaseHelper localDataSource;

  MusicRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<List<Track>> searchTracks({
    required String query,
    required SearchType type,
    bool? explicitFilter,
  }) async {
    return await remoteDataSource.searchTracks(
      query: query,
      type: type,
      explicitFilter: explicitFilter,
    );
  }

  @override
  Future<void> saveTrack(Track track, {bool suggestToRadio = false}) async {
    final model = TrackModel(
      trackId: track.trackId,
      trackName: track.trackName,
      artistName: track.artistName,
      collectionName: track.collectionName,
      previewUrl: track.previewUrl,
      artworkUrl: track.artworkUrl,
      genre: track.genre,
      trackTimeMillis: track.trackTimeMillis,
      trackPrice: track.trackPrice,
      isExplicit: track.isExplicit,
      suggestToRadio: track.suggestToRadio,
    );
    await localDataSource.insertTrack(model);
  }

  @override
  Future<List<Track>> getPlaylist() async {
    return await localDataSource.getAllTracks();
  }

  @override
  Future<void> deleteTrack(int trackId) async {
    await localDataSource.deleteTrack(trackId);
  }

  @override
  Future<bool> isTrackSaved(int trackId) async {
    return await localDataSource.isTrackSaved(trackId);
  }
}
