import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sound_search/core/constants/app_colors.dart';
import 'package:sound_search/core/constants/app_strings.dart';
import 'package:sound_search/data/datasources/itunes_remote_datasource.dart';
import 'package:sound_search/data/datasources/playlist_local_datasource.dart';
import 'package:sound_search/data/repositories/music_repository_impl.dart';
import 'package:sound_search/domain/usecases/delete_track_usecase.dart';
import 'package:sound_search/domain/usecases/get_playlist_usecase.dart';
import 'package:sound_search/domain/usecases/save_track_usecase.dart';
import 'package:sound_search/domain/usecases/search_tracks_usecase.dart';
import 'package:sound_search/presentation/providers/playlist_provider.dart';
import 'package:sound_search/presentation/providers/search_provider.dart';
import 'package:sound_search/presentation/screens/playlist_screen.dart';
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
        ChangeNotifierProvider(
          create: (_) => PlaylistProvider(
            saveTrackUseCase: SaveTrackUseCase(repository: repository),
            getPlaylistUseCase: GetPlaylistUseCase(repository: repository),
            deleteTrackUseCase: DeleteTrackUseCase(repository: repository),
          )..loadPlaylist(),
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
        home: const MainNavigation(),
      ),
    );
  }
}

// Navegação principal com abas — estilo YouTube Music
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // IndexedStack mantém o estado de cada aba ao trocar
  final List<Widget> _screens = const [
    SearchScreen(),
    PlaylistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.surface,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.queue_music_outlined),
              activeIcon: Icon(Icons.queue_music),
              label: 'Playlist',
            ),
          ],
        ),
      ),
    );
  }
}