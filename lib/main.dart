import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sound_search/core/constants/app_colors.dart';
import 'package:sound_search/core/constants/app_strings.dart';
import 'package:sound_search/data/datasources/itunes_remote_datasource.dart';
import 'package:sound_search/data/datasources/playlist_local_datasource.dart';
import 'package:sound_search/data/repositories/music_repository_impl.dart';
import 'package:sound_search/domain/usecases/search_tracks_usecase.dart';
import 'package:sound_search/presentation/providers/search_provider.dart';
import 'package:sound_search/presentation/screens/search_screen.dart';

void main() {
  runApp(const SoundSearchApp());
}

class SoundSearchApp extends StatelessWidget {
  const SoundSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MusicRepositoryImpl(
      remoteDataSource: ItunesRemoteDatasourceImpl(client: http.Client()),
      localDataSource: DatabaseHelper.instance,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(
            searchTracksUseCase: SearchTracksUseCase(repository: repository),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.onSurface,
          ),
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: const SearchScreen(),
      ),
    );
  }
}