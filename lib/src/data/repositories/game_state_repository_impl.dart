import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/game_state.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/repositories/game_state_repository.dart';
import '../models/game_state_model.dart';
import '../models/leaderboard_entry_model.dart';

class GameStateRepositoryImpl implements GameStateRepository {
  final Box _box;
  final FirebaseFirestore _firestore;

  GameStateRepositoryImpl(this._box, this._firestore);

  @override
  Future<GameState> loadGameState() async {
    final raw = _box.get('game_state');
    if (raw is Map) {
      final normalized = Map<String, dynamic>.from(
        raw.map((key, value) => MapEntry(key.toString(), value)),
      );
      return GameStateModel.fromMap(normalized).toEntity();
    }

    return GameState.initial();
  }

  @override
  Future<void> saveGameState(GameState state) async {
    final model = GameStateModel.fromEntity(state);
    await _box.put('game_state', model.toMap());
  }

  @override
  Future<void> syncLeaderboard(LeaderboardEntry entry) async {
    final model = LeaderboardEntryModel.fromEntity(entry);
    await _firestore.collection('leaderboards').doc(entry.metric.name).set(
          model.toMap(),
          SetOptions(merge: true),
        );
  }
}

