

import 'package:cinemapedia/config/dio/dio_connect.dart';
import 'package:cinemapedia/domain/datasources/cast_datasource.dart';
import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/infrastructure/mappers/cast_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/cast_response.dart';


class CastMoviedbDatasource extends CastDatasource{

  @override
  Future<List<Cast>> getCastByMovie(String movieId) async {

    final response = await DioConnect.get(
      '/movie/$movieId/credits',
    );

    final castResponse = CastResponse.fromJson(response.data);

    final List<Cast> castings = castResponse.cast.map(
      (cast) => CastMapper.castToEntity(cast)
    ).toList();

    return castings ;
    
  }
}