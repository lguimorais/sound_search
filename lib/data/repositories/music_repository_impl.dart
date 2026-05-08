import 'package:sound_search/data/datasources/itunes_remote_datasource.dart';
import 'package:sound_search/data/datasources/playlist_local_datasource.dart';
import 'package:sound_search/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final IItunesRemoteDatasource remoteDatasource;
  final DatabaseHelper localDataSource;
}
