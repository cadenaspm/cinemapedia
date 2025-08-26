
import 'package:cinemapedia/domain/entities/cast.dart';

abstract class CastDatasource {

  Future<List<Cast>> getCastByMovie( String movieId ); 
}