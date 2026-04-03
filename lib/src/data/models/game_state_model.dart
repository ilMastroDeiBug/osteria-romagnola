import '../../domain/entities/game_state.dart';
import '../../domain/entities/inventory_item.dart';

class GameStateModel {
  final double wallet;
  final double respect;
  final int levelSbronza;
  final List<Map<String, dynamic>> inventory;
  final int marafoneWins;
  final bool hasBalconyAccess;
  final int lastSaved;

  const GameStateModel({
    required this.wallet,
    required this.respect,
    required this.levelSbronza,
    required this.inventory,
    required this.marafoneWins,
    required this.hasBalconyAccess,
    required this.lastSaved,
  });

  factory GameStateModel.fromEntity(GameState state) {
    return GameStateModel(
      wallet: state.wallet,
      respect: state.respect,
      levelSbronza: state.levelSbronza,
      inventory: state.inventory.map((item) => item.toMap()).toList(),
      marafoneWins: state.marafoneWins,
      hasBalconyAccess: state.hasBalconyAccess,
      lastSaved: state.lastSaved.millisecondsSinceEpoch,
    );
  }

  GameState toEntity() {
    return GameState(
      wallet: wallet,
      respect: respect,
      levelSbronza: levelSbronza,
      inventory: inventory
          .map((map) => InventoryItem.fromMap(Map<String, dynamic>.from(map)))
          .toList(),
      marafoneWins: marafoneWins,
      hasBalconyAccess: hasBalconyAccess,
      lastSaved: DateTime.fromMillisecondsSinceEpoch(lastSaved),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wallet': wallet,
      'respect': respect,
      'levelSbronza': levelSbronza,
      'inventory': inventory,
      'marafoneWins': marafoneWins,
      'hasBalconyAccess': hasBalconyAccess,
      'lastSaved': lastSaved,
    };
  }

  factory GameStateModel.fromMap(Map<String, dynamic> map) {
    return GameStateModel(
      wallet: (map['wallet'] as num).toDouble(),
      respect: (map['respect'] as num).toDouble(),
      levelSbronza: map['levelSbronza'] as int,
      inventory: (map['inventory'] as List).map((entry) {
        return Map<String, dynamic>.from(entry as Map);
      }).toList(),
      marafoneWins: map['marafoneWins'] as int,
      hasBalconyAccess: map['hasBalconyAccess'] as bool,
      lastSaved: map['lastSaved'] as int,
    );
  }
}

