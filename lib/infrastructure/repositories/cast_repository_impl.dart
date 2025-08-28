

import 'package:cinemapedia/domain/datasources/cast_datasource.dart';
import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/domain/repositories/cast_repository.dart';

class CastRepositoryImpl extends CastRepository{

  final CastDatasource datasource;

  CastRepositoryImpl({
    required this.datasource
  });


  @override
  Future<List<Cast>> getCastByMovie(String movieId) async{


    return datasource.getCastByMovie(movieId);
  }


}