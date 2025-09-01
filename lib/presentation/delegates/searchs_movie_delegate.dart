import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/helpers/human_formats.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchsMovieDelegate extends SearchDelegate<Movie?> {
  
  final SearchMoviesCallback searchMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  
  Timer? _debounceTimer;
  List<Movie> initialMovies;


  SearchsMovieDelegate({
    required this.initialMovies, 
    required this.searchMovies
  });

  void clearStreams(){
    debouncedMovies.close();
  }

  void _onQueryChanged(String query){
    //Dispara true para indicar que estan cargando la consulta y esto hace que aparezca el icono de carga
    isLoadingStream.add(true);

    if( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

    _debounceTimer = Timer( const Duration( milliseconds:  800 ), () async{
      
      //* Retorna un arreglo vacio si la consulta esta vacia.
      // if(query.isEmpty){
      //   debouncedMovies.add([]);
      //   return;
      // }

      //* Buscamos las peliculas.
      final movies = await searchMovies( query );
      initialMovies = movies; 
      debouncedMovies.add(movies);

      //Cuando obtengo las peliculas detengo mi proceso de carga y cambio a la x
      isLoadingStream.add(false);

    });
  }

  Widget buildResultAndSuggestions(){

    return StreamBuilder(
      //future: StreamBuilder(query),
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie){
                clearStreams();
                close(context, movie);
              } ,
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream, 
        builder: (context, snapshot) {

          if(snapshot.data ?? false){
            return SpinPerfect(
              duration: Duration(seconds: 20 ),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '', 
                icon: Icon(Icons.refresh_rounded)
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '', 
              icon: Icon(Icons.clear)
            ),
          );
          
        },
      ),

      

      
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        //* Limpiamos los streams una vez cerramos el buscador
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.chevron_left, size: 30),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return buildResultAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final void Function(BuildContext context, Movie movie) onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                  movie.posterPath,
                ),
              ),
            ),
      
            SizedBox(width: 10,),
      
            //Descripción
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium,),
                  
                  movie.overview.length >= 100
                   ? Text('${movie.overview.substring(0, 100)}....')
                   : Text(movie.overview),
      
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow[700],),
                      SizedBox(width: 5,),
                      Text(HumanFormats.number(movie.voteAverage, 1), style: textStyle.bodyMedium!.copyWith(color: Colors.yellow[900]) )
      
                    ],
                  )
                ],
              ),
      
      
            )
          ],
        ),
      ),
    );
  }
}
