import '../entities/track.dart';
import '../repositories/music_repository.dart';

class SaveTrackUseCase {
  final MusicRepository repository;

  SaveTrackUseCase({required this.repository});

  Future<void> call(Track track, {bool suggestToRadio = false}) async {
    await repository.saveTrack(track, suggestToRadio: suggestToRadio);
  }
}