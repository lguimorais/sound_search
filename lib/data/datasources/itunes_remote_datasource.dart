import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Track_model.dart';
import '../../core/constants/api_constants.dart';

enum SearchType { song, album, artist }

abstract class IItunesRemoteDatasource {
  Future<List<TrackModel>> searchTracks({
    required String query,
    required SearchType type,
    bool? explicitFilter,
  });
}

class ItunesRemoteDatasourceImpl implements IItunesRemoteDatasource {
  final http.Client client;
  ItunesRemoteDatasourceImpl({required this.client});

  @override
  Future<List<TrackModel>> searchTracks({
    required String query,
    required SearchType type,
    bool? explicitFilter,
  }) async {
    final String mediaType = switch (type) {
      SearchType.song => 'music',
      SearchType.album => 'music',
      SearchType.artist => 'music',
    };
    final String entity = switch (type) {
      SearchType.song => 'song',
      SearchType.album => 'album',
      SearchType.artist => 'musicArtist',
    };

    final uri = Uri.https('itunes.apple.com', '/search', {
      'term': query,
      'media': mediaType,
      'entity': entity,
      'country': ApiConstants.defaultCountry,
      'limit': ApiConstants.defaultLimit.toString(),
      if (explicitFilter != null) 'explicit': explicitFilter ? 'Yes' : 'No',
    });
    final response = await client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      final List<dynamic> results = data['results'] as List<dynamic>;
      return results
          .whereType<Map<String, dynamic>>()
          .map((json) => TrackModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }
}
