import '../entities/track.dart';
import '../../data/datasources/itunes_remote_datasource.dart';

abstract class MusicRepository {
  Future<List<Track>> searchTracks({
    required String query,
    required SearchType type,
    bool? explicitFilter,
  });

  Future<void> saveTrack(Track track, {bool suggestToRadio});
  Future<List<Track>> getPlaylist();
  Future<void> deleteTrack(int trackId);
  Future<bool> isTrackSaved(int trackId);
}
