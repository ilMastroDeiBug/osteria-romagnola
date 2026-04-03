import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/repositories/game_state_repository.dart';
import '../../domain/usecases/apply_sbronza_use_case.dart';
import '../../domain/usecases/consume_consumable_use_case.dart';
import '../../domain/usecases/load_game_state_use_case.dart';
import '../../domain/usecases/persist_game_state_use_case.dart';
import '../../domain/usecases/play_marafone_use_case.dart';
import '../../domain/usecases/sync_leaderboard_use_case.dart';

final gameStateRepositoryProvider = Provider<GameStateRepository>((_) => locator<GameStateRepository>());

final applySbronzaUseCaseProvider = Provider((ref) => ApplySbronzaUseCase());
final consumeConsumableUseCaseProvider = Provider((ref) =>
    ConsumeConsumableUseCase(ref.read(applySbronzaUseCaseProvider)));
final loadGameStateUseCaseProvider = Provider((ref) =>
    LoadGameStateUseCase(ref.read(gameStateRepositoryProvider)));
final persistGameStateUseCaseProvider = Provider((ref) =>
    PersistGameStateUseCase(ref.read(gameStateRepositoryProvider)));
final syncLeaderboardUseCaseProvider = Provider((ref) =>
    SyncLeaderboardUseCase(ref.read(gameStateRepositoryProvider)));
final playMarafoneUseCaseProvider = Provider((ref) => PlayMarafoneUseCase());

final gameStateNotifierProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(
    ref.read(loadGameStateUseCaseProvider),
    ref.read(persistGameStateUseCaseProvider),
    ref.read(consumeConsumableUseCaseProvider),
    ref.read(playMarafoneUseCaseProvider),
    ref.read(syncLeaderboardUseCaseProvider),
  );
});

class GameStateNotifier extends StateNotifier<GameState> {
  final LoadGameStateUseCase _loadGameState;
  final PersistGameStateUseCase _persistGameState;
  final ConsumeConsumableUseCase _consumeConsumable;
  final PlayMarafoneUseCase _playMarafone;
  final SyncLeaderboardUseCase _syncLeaderboard;

  GameStateNotifier(
    this._loadGameState,
    this._persistGameState,
    this._consumeConsumable,
    this._playMarafone,
    this._syncLeaderboard,
  ) : super(GameState.initial()) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    state = await _loadGameState();
  }

  Future<void> consume(ConsumableType type) async {
    final nextState = _consumeConsumable(state, type);
    await _persistAndSync(nextState);
  }

  Future<void> playMarafone() async {
    final nextState = _playMarafone(state);
    await _persistAndSync(nextState);
  }

  Future<void> _persistAndSync(GameState nextState) async {
    state = nextState;
    await _persistGameState(nextState);
    await _syncLeaderboard(nextState);
  }
}

