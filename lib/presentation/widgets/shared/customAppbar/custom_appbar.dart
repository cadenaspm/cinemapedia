
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/searchs_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends SliverPersistentHeaderDelegate {

  final double minExtents;
  final double maxExtents;

  CustomAppbar({
    required this.minExtents, 
    required this.maxExtents
  });
  
  @override
  double get maxExtent => maxExtents;
  
  @override
  double get minExtent => minExtents;
  
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final color = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    final isCollapsed = shrinkOffset > (maxExtents - minExtents - 10) ;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) { 
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                if(!isCollapsed)
                  FadeIn(child: Text('La mejor información de cine', style: titleStyle,)),
                Row(
                  children: [
                    Icon(Icons.movie_creation_outlined, color: color.primary),
                    const SizedBox(width: 5),
                    Text('Cinemapedia', style: titleStyle),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {

                        final searchedMovies = ref.read( searchedMoviesProvider );
                        final searchQuery = ref.read(searchQueryProvider);

                        final movie = await showSearch<Movie?>(
                          query: searchQuery,
                          context: context, 
                          delegate: SearchsMovieDelegate(
                            initialMovies: searchedMovies,
                            searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery
                          ),
                        );

                        if(!context.mounted) return;

                        if(movie == null) return;

                        context.push('/movie/${movie.id}');
                      },
                      icon: Icon(Icons.search, color: color.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

}

  
  