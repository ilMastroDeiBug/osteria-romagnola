import '../entities/game_state.dart';
import '../entities/leaderboard_entry.dart';

abstract class GameStateRepository {
  Future<GameState> loadGameState();
  Future<void> saveGameState(GameState state);
  Future<void> syncLeaderboard(LeaderboardEntry entry);
}

