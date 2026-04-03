import 'package:flutter/foundation.dart';

import 'inventory_item.dart';

class GameState {
  final double wallet;
  final double respect;
  final int levelSbronza;
  final List<InventoryItem> inventory;
  final int marafoneWins;
  final bool hasBalconyAccess;
  final DateTime lastSaved;

  const GameState({
    required this.wallet,
    required this.respect,
    required this.levelSbronza,
    required this.inventory,
    required this.marafoneWins,
    required this.hasBalconyAccess,
    required this.lastSaved,
  });

  factory GameState.initial() {
    return GameState(
      wallet: 120.0,
      respect: 0.0,
      levelSbronza: 0,
      inventory: const [],
      marafoneWins: 0,
      hasBalconyAccess: false,
      lastSaved: DateTime.now(),
    );
  }

  GameState copyWith({
    double? wallet,
    double? respect,
    int? levelSbronza,
    List<InventoryItem>? inventory,
    int? marafoneWins,
    bool? hasBalconyAccess,
    DateTime? lastSaved,
  }) {
    return GameState(
      wallet: wallet ?? this.wallet,
      respect: respect ?? this.respect,
      levelSbronza: levelSbronza ?? this.levelSbronza,
      inventory: inventory ?? this.inventory,
      marafoneWins: marafoneWins ?? this.marafoneWins,
      hasBalconyAccess: hasBalconyAccess ?? this.hasBalconyAccess,
      lastSaved: lastSaved ?? this.lastSaved,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameState &&
        other.wallet == wallet &&
        other.respect == respect &&
        other.levelSbronza == levelSbronza &&
        listEquals(other.inventory, inventory) &&
        other.marafoneWins == marafoneWins &&
        other.hasBalconyAccess == hasBalconyAccess &&
        other.lastSaved == lastSaved;
  }

  @override
  int get hashCode {
    return wallet.hashCode ^
        respect.hashCode ^
        levelSbronza.hashCode ^
        inventory.hashCode ^
        marafoneWins.hashCode ^
        hasBalconyAccess.hashCode ^
        lastSaved.hashCode;
  }
}

