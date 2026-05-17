import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/itunes_remote_datasource.dart';
import '../../domain/entities/track.dart';
import '../../domain/usecases/search_tracks_usecase.dart';

enum SearchState { initial, loading, success, error }

class SearchProvider extends ChangeNotifier {
  final SearchTracksUseCase _searchTracksUseCase;

  SearchProvider({required SearchTracksUseCase searchTracksUseCase})
      : _searchTracksUseCase = searchTracksUseCase {
    _loadPreferences(); // carrega preferências salvas ao criar o provider
  }

  SearchState _state = SearchState.initial;
  List<Track> _results = [];
  String _errorMessage = '';
  SearchType _searchType = SearchType.song;
  bool? _explicitFilter;

  // Chave usada no SharedPreferences
  static const String _keySearchType = 'searchType';

  SearchState get state => _state;
  List<Track> get results => _results;
  String get errorMessage => _errorMessage;
  SearchType get searchType => _searchType;
  bool? get explicitFilter => _explicitFilter;

  // Carrega o tipo de busca salvo anteriormente
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_keySearchType);
    if (saved != null) {
      _searchType = SearchType.values.firstWhere(
        (t) => t.name == saved,
        orElse: () => SearchType.song,
      );
      notifyListeners();
    }
  }

  // Salva o tipo de busca atual
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySearchType, _searchType.name);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    _state = SearchState.loading;
    _results = [];
    notifyListeners();

    try {
      _results = await _searchTracksUseCase.call(
        query: query,
        type: _searchType,
        explicitFilter: _explicitFilter,
      );
      _state = SearchState.success;
    } catch (e) {
      _errorMessage = e.toString().contains('SocketException') ||
              e.toString().contains('TimeoutException')
          ? 'Sem conexão com a internet.'
          : 'Erro ao buscar músicas. Tente novamente.';
      _state = SearchState.error;
    }

    notifyListeners();
  }

  void setSearchType(SearchType type) {
    _searchType = type;
    _savePreferences(); // persiste ao trocar o tipo
    notifyListeners();
  }

  void setExplicitFilter(bool? value) {
    _explicitFilter = value;
    notifyListeners();
  }
}