

import 'package:cinemapedia/infrastructure/models/moviedb/cast_response.dart';

import '../../domain/entities/cast.dart';

class CastMapper {

  static Cast castToEntity( Casting casting ) => Cast(
    id: casting.id, 
    name: casting.name, 
    profilePath: casting.profilePath != null
      ? 'https://image.tmdb.org/t/p/w500${ casting.profilePath }'
      : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', 
    character: casting.character
  );
}

