import '../entities/game_state.dart';
import '../repositories/game_state_repository.dart';

class PersistGameStateUseCase {
  final GameStateRepository repository;

  PersistGameStateUseCase(this.repository);

  Future<void> call(GameState state) => repository.saveGameState(state);
}

