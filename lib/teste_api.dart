import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/itunes_remote_datasource.dart';
import 'data/models/Track_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== TESTE DA ITUNES API ===');
  print('Buscando "Beatles"...\n');

  final datasource = ItunesRemoteDatasourceImpl(client: http.Client());

  try {
    final List<TrackModel> tracks = await datasource.searchTracks(
      query: 'Gustavo Mioto',
      type: SearchType.song, // busca por músicas
      explicitFilter: null, // sem filtro de explícito
    );

    print('✅ ${tracks.length} músicas encontradas!\n');

    for (int i = 0; i < tracks.length && i < 3; i++) {
      final track = tracks[i];
      print('--- Música ${i + 1} ---');
      print('Nome:    ${track.trackName}');
      print('Artista: ${track.artistName}');
      print('Álbum:   ${track.collectionName}');
      print('Gênero:  ${track.genre}');
      print('Duração: ${track.formattedDuration}');
      print('Preço:   ${track.formattedPrice}');
      print('Preview: ${track.previewUrl ?? "sem preview"}');
      print('');
    }
  } catch (e) {
    print('❌ Erro: $e');
  }

  runApp(const _TesteApp());
}

class _TesteApp extends StatelessWidget {
  const _TesteApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Veja o terminal!\nOs dados da API estão lá 👆',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
