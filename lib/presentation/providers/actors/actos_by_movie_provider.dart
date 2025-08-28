 import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider =
    StateNotifierProvider< ActorsByMovieNofifier, Map<String, List<Cast>> >((ref) {
      final actorsRepository = ref.watch(actorsRepositoryProvider);

      return ActorsByMovieNofifier(getActors: actorsRepository.getCastByMovie);
    });

typedef GetActorsCallback = Future<List<Cast>> Function(String movieId);

class ActorsByMovieNofifier extends StateNotifier<Map<String, List<Cast>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNofifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {

    if (state[movieId] != null) return;

    final List<Cast> actors = await getActors(movieId);

    state = {...state, movieId: actors};

  }
}
