import '../repositories/music_repository.dart';

class DeleteTrackUseCase {
  final MusicRepository repository;

  DeleteTrackUseCase({required this.repository});

  Future<void> call(int trackId) async {
    await repository.deleteTrack(trackId);
  }
}