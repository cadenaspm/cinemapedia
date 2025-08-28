

import 'package:cinemapedia/domain/datasources/cast_datasource.dart';
import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/infrastructure/mappers/cast_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/cast_response.dart';
import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';

class CastMoviedbDatasource extends CastDatasource{

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<Cast>> getCastByMovie(String movieId) async{

    final response = await dio.get(
       '/movie/$movieId/credits',
    );

    final castResponse = CastResponse.fromJson(response.data);

    final List<Cast> castings = castResponse.cast.map(
      (cast) => CastMapper.castToEntity(cast)
    ).toList();

    return castings ;
    
  }
}