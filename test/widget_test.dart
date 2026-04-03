import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:osteria_romagnola/src/core/di.dart';
import 'package:osteria_romagnola/src/domain/entities/game_state.dart';
import 'package:osteria_romagnola/src/domain/entities/leaderboard_entry.dart';
import 'package:osteria_romagnola/src/domain/repositories/game_state_repository.dart';
import 'package:osteria_romagnola/src/presentation/app.dart';

class _FakeGameStateRepository implements GameStateRepository {
  @override
  Future<GameState> loadGameState() async => GameState.initial();

  @override
  Future<void> saveGameState(GameState state) async {}

  @override
  Future<void> syncLeaderboard(LeaderboardEntry entry) async {}
}

void main() {
  setUp(() async {
    await locator.reset();
    locator.registerSingleton<GameStateRepository>(_FakeGameStateRepository());
  });

  testWidgets('renders Osteria app shell', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OsteriaApp(),
      ),
    );

    await tester.pump();

    expect(find.text('BANCONE'), findsOneWidget);
    expect(find.text('TAVOLO DI GIOCO'), findsOneWidget);
  });
}
