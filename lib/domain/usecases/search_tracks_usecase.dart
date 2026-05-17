import '../entities/track.dart';
import '../repositories/music_repository.dart';
import '../../data/datasources/itunes_remote_datasource.dart';

class SearchTracksUseCase {
  final MusicRepository repository;

  SearchTracksUseCase({required this.repository});

  Future<List<Track>> call({
    required String query,
    required SearchType type,
    bool? explicitFilter,
  }) async {
    return await repository.searchTracks(
      query: query,
      type: type,
      explicitFilter: explicitFilter,
    );
  }
}