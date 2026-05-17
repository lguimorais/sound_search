import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../../domain/usecases/save_track_usecase.dart';
import '../../domain/usecases/get_playlist_usecase.dart';
import '../../domain/usecases/delete_track_usecase.dart';

class PlaylistProvider extends ChangeNotifier {
  final SaveTrackUseCase _saveTrackUseCase;
  final GetPlaylistUseCase _getPlaylistUseCase;
  final DeleteTrackUseCase _deleteTrackUseCase;

  PlaylistProvider({
    required SaveTrackUseCase saveTrackUseCase,
    required GetPlaylistUseCase getPlaylistUseCase,
    required DeleteTrackUseCase deleteTrackUseCase,
  })  : _saveTrackUseCase = saveTrackUseCase,
        _getPlaylistUseCase = getPlaylistUseCase,
        _deleteTrackUseCase = deleteTrackUseCase;

  List<Track> _playlist = [];
  bool _isLoading = false;

  List<Track> get playlist => _playlist;
  bool get isLoading => _isLoading;

  Future<void> loadPlaylist() async {
    _isLoading = true;
    notifyListeners();

    _playlist = await _getPlaylistUseCase.call();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveTrack(Track track, {bool suggestToRadio = false}) async {
    await _saveTrackUseCase.call(track, suggestToRadio: suggestToRadio);
    await loadPlaylist();
  }

  Future<void> deleteTrack(int trackId) async {
    await _deleteTrackUseCase.call(trackId);
    await loadPlaylist();
  }

  Future<bool> isTrackSaved(int trackId) async {
    return _playlist.any((t) => t.trackId == trackId);
  }
}