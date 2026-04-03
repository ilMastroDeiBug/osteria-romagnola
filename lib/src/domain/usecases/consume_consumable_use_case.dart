import 'dart:math';

import '../entities/game_state.dart';
import '../entities/inventory_item.dart';
import 'apply_sbronza_use_case.dart';

enum ConsumableType {
  sangiovese,
  cappelletti,
  sigari,
  pipa,
}

extension _ConsumableConfiguration on ConsumableType {
  double get cost {
    switch (this) {
      case ConsumableType.sangiovese:
        return 18.0;
      case ConsumableType.cappelletti:
        return 14.0;
      case ConsumableType.sigari:
        return 22.0;
      case ConsumableType.pipa:
        return 42.0;
    }
  }

  int get sbronzaDelta {
    switch (this) {
      case ConsumableType.sangiovese:
        return 2;
      case ConsumableType.cappelletti:
        return -3;
      case ConsumableType.sigari:
        return 1;
      case ConsumableType.pipa:
        return 1;
    }
  }

  double get respectDelta {
    switch (this) {
      case ConsumableType.sangiovese:
        return 0.3;
      case ConsumableType.cappelletti:
        return 0.7;
      case ConsumableType.sigari:
        return 0.5;
      case ConsumableType.pipa:
        return 1.5;
    }
  }

  bool get unlocksBalcony {
    return this == ConsumableType.sigari || this == ConsumableType.pipa;
  }

  InventoryItem? get rewardItem {
    switch (this) {
      case ConsumableType.sangiovese:
      case ConsumableType.cappelletti:
      case ConsumableType.sigari:
        return null;
      case ConsumableType.pipa:
        return const InventoryItem(id: 'pipa', name: 'Pass per il balcone fumatori', quantity: 1);
    }
  }

  String get label {
    switch (this) {
      case ConsumableType.sangiovese:
        return 'Sangiovese dal bancone';
      case ConsumableType.cappelletti:
        return 'Cappelletti della nonna';
      case ConsumableType.sigari:
        return 'Sigari rumeni';
      case ConsumableType.pipa:
        return 'Pipa del Balcone';
    }
  }
}

class ConsumeConsumableUseCase {
  final ApplySbronzaUseCase applySbronzaUseCase;

  ConsumeConsumableUseCase(this.applySbronzaUseCase);

  GameState call(GameState state, ConsumableType consumable) {
    if (state.wallet < consumable.cost) {
      return state;
    }

    final nextLevel = applySbronzaUseCase(state.levelSbronza, consumable.sbronzaDelta);
    final nextWallet = max(0, state.wallet - consumable.cost);
    final nextRespect = min(100, state.respect + consumable.respectDelta);
    final nextInventory = _addRewardToInventory(state.inventory, consumable.rewardItem);

    var nextState = state.copyWith(
      wallet: nextWallet,
      respect: nextRespect,
      levelSbronza: nextLevel,
      inventory: nextInventory,
      hasBalconyAccess: state.hasBalconyAccess || consumable.unlocksBalcony,
      lastSaved: DateTime.now(),
    );

    if (consumable == ConsumableType.cappelletti) {
      nextState = nextState.copyWith(
        levelSbronza: applySbronzaUseCase(nextState.levelSbronza, -1),
      );
    }

    return nextState;
  }

  List<InventoryItem> _addRewardToInventory(
    List<InventoryItem> inventory,
    InventoryItem? reward,
  ) {
    if (reward == null) {
      return inventory;
    }

    final index = inventory.indexWhere((item) => item.id == reward.id);
    if (index >= 0) {
      final updated = List<InventoryItem>.from(inventory);
      updated[index] = updated[index].copyWith(quantity: updated[index].quantity + reward.quantity);
      return updated;
    }

    return [...inventory, reward];
  }
}

