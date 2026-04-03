import 'dart:math';

import '../entities/game_state.dart';

class PlayMarafoneUseCase {
  GameState call(GameState state) {
    final baseChance = 0.7;
    final drinkPenalty = state.levelSbronza / 15;
    final successChance = (baseChance - drinkPenalty).clamp(0.25, 0.95);
    final victory = Random().nextDouble() < successChance;

    final reward = victory ? 54.0 : -18.0;
    final respectDelta = victory ? 2.0 : -1.0;
    final nextWallet = max(0, state.wallet + reward);
    final nextRespect =
        (state.respect + respectDelta).clamp(0.0, 100.0).toDouble();

    return state.copyWith(
      wallet: nextWallet,
      respect: nextRespect,
      marafoneWins: state.marafoneWins + (victory ? 1 : 0),
      levelSbronza: max(0, state.levelSbronza - 1),
      lastSaved: DateTime.now(),
    );
  }
}

