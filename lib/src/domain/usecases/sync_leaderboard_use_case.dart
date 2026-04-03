import '../entities/game_state.dart';
import '../entities/leaderboard_entry.dart';
import '../repositories/game_state_repository.dart';

class SyncLeaderboardUseCase {
  final GameStateRepository repository;

  SyncLeaderboardUseCase(this.repository);

  Future<void> call(GameState state) async {
    final entries = _createEntriesFromState(state);
    for (final entry in entries) {
      await repository.syncLeaderboard(entry);
    }
  }

  List<LeaderboardEntry> _createEntriesFromState(GameState state) {
    final stamp = DateTime.now();
    return [
      LeaderboardEntry(
        playerId: 'osteria_player',
        metric: LeaderboardMetric.marafoneWins,
        value: state.marafoneWins.toDouble(),
        timestamp: stamp,
      ),
      LeaderboardEntry(
        playerId: 'osteria_player',
        metric: LeaderboardMetric.banconeSbronza,
        value: state.levelSbronza.toDouble(),
        timestamp: stamp,
      ),
      LeaderboardEntry(
        playerId: 'osteria_player',
        metric: LeaderboardMetric.richestOsteria,
        value: state.wallet,
        timestamp: stamp,
      ),
    ];
  }
}

