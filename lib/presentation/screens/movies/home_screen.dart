import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationbar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);

    if( initialLoading ) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(popularMoviesProvider); 
    final upcomingMovies = ref.watch(upcomingMoviesProvider); 
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    if (slideShowMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [

        SliverPersistentHeader(
          delegate: CustomAppbar(minExtents: 80, maxExtents: 100),
          pinned: true,
          floating: true,
        ), 

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                
                MoviesSlideshow(movies: slideShowMovies),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subtitle: 'Lunes 20',
                  onNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  subtitle: 'Este mes',
                  onNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),

                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Proximamente',
                  onNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor valoradas',
                  subtitle: 'Desde 1980',
                  onNextPage: () {
                    ref.read(topRatedMoviesProvider .notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 20),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
