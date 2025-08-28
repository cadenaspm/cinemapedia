

//Este repositorio es inmutable
import 'package:cinemapedia/infrastructure/datasources/cast_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/cast_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref){
  return CastRepositoryImpl(datasource: CastMoviedbDatasource());
});