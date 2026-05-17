import '../entities/track.dart';
import '../repositories/music_repository.dart';

class GetPlaylistUseCase {
  final MusicRepository repository;

  GetPlaylistUseCase({required this.repository});

  Future<List<Track>> call() async {
    return await repository.getPlaylist();
  }
}