import '../entities/game_state.dart';
import '../repositories/game_state_repository.dart';

class LoadGameStateUseCase {
  final GameStateRepository repository;

  LoadGameStateUseCase(this.repository);

  Future<GameState> call() => repository.loadGameState();
}

