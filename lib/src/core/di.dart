import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../data/repositories/game_state_repository_impl.dart';
import '../domain/repositories/game_state_repository.dart';

final locator = GetIt.instance;

Future<void> registerDependencies() async {
  if (!locator.isRegistered<Box>()) {
    final box = await Hive.openBox('game_state');
    locator.registerSingleton<Box>(box);
  }

  if (!locator.isRegistered<GameStateRepository>()) {
    locator.registerSingleton<GameStateRepository>(
      GameStateRepositoryImpl(locator<Box>(), FirebaseFirestore.instance),
    );
  }
}

