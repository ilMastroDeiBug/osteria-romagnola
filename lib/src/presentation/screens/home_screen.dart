import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/game_state.dart';
import '../providers/game_state_provider.dart';

enum RoomView { bancone, tavolo, balcone }

extension RoomViewLabel on RoomView {
  String get label {
    switch (this) {
      case RoomView.bancone:
        return 'Bancone';
      case RoomView.tavolo:
        return 'Tavolo di gioco';
      case RoomView.balcone:
        return 'Balcone fumatori';
    }
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drunkController;
  RoomView _currentRoom = RoomView.bancone;

  @override
  void initState() {
    super.initState();
    _drunkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _drunkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateNotifierProvider);
    final intoxicationLevel = (gameState.levelSbronza / 10).clamp(0.0, 1.0);
    final blurSigma = intoxicationLevel * 6;
    final rotation =
        sin(_drunkController.value * 2 * pi) * intoxicationLevel * 0.04;

    return Scaffold(
      body: SafeArea(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F0B0B).withOpacity(0.95),
                    const Color(0xFF281411).withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatRow(gameState),
                  const SizedBox(height: 12),
                  _buildRoomTabs(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildRoomContent(gameState)),
                  const SizedBox(height: 12),
                  _buildInventory(gameState),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(GameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statChip('Portafoglio', 'EUR ${state.wallet.toStringAsFixed(1)}'),
        _statChip('Rispetto', state.respect.toStringAsFixed(0)),
        _statChip('Sbronza', '${state.levelSbronza}/10'),
        _statChip('Marafone', '${state.marafoneWins} vittorie'),
      ],
    );
  }

  Widget _statChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.orangeAccent),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRoomTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: RoomView.values.map((room) {
        final isActive = _currentRoom == room;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: isActive ? 8 : 2,
            backgroundColor: isActive ? Colors.orange : Colors.grey.shade700,
          ),
          onPressed: () => setState(() => _currentRoom = room),
          child: Text(room.label.toUpperCase()),
        );
      }).toList(),
    );
  }

  Widget _buildRoomContent(GameState state) {
    switch (_currentRoom) {
      case RoomView.bancone:
        return _banconeState();
      case RoomView.tavolo:
        return _tavoloState();
      case RoomView.balcone:
        return _balconeState(state);
    }
  }

  Widget _banconeState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Il bancone plasma il loop: spendi denaro per vino e cappelletti e modula il livello di lucidita.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _actionButton(
              'Sangiovese',
              'Aumenta la sbronza',
              () => ref
                  .read(gameStateNotifierProvider.notifier)
                  .consume(ConsumableType.sangiovese),
            ),
            _actionButton(
              'Cappelletti',
              'Riduce la confusione',
              () => ref
                  .read(gameStateNotifierProvider.notifier)
                  .consume(ConsumableType.cappelletti),
            ),
            _actionButton(
              'Pipa per balcone',
              'Raggiungi il tabacco segreto',
              () => ref
                  .read(gameStateNotifierProvider.notifier)
                  .consume(ConsumableType.pipa),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'I consumabili regolano ubriachezza, rispetto e accesso alle schermate extra. Gestisci il portafoglio con la saggezza romagnola.',
          ),
        ),
      ],
    );
  }

  Widget _tavoloState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Il Marafone e la vera arena: la telecamera passa dal primo piano a una vista top-down, l'IA locale osserva ogni carta.",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.4),
              border: Border.all(color: Colors.orange, width: 1.5),
            ),
            child: const Center(
              child: Text(
                'Marafone vs IA: leggi le carte, gestisci l\'ubriachezza e sfrutta le interazioni segrete per attivare "Fai a botte".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _actionButton(
          'Gioca Marafone',
          'Vinci crediti e rispetto',
          () => ref.read(gameStateNotifierProvider.notifier).playMarafone(),
        ),
      ],
    );
  }

  Widget _balconeState(GameState state) {
    final notifier = ref.read(gameStateNotifierProvider.notifier);

    if (!state.hasBalconyAccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Il Balcone dei Fumatori e chiuso: acquista sigari per sbloccarlo ed entrare nelle quest secondarie.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _actionButton(
            'Sigari rumeni',
            'Sblocca il balcone',
            () => notifier.consume(ConsumableType.sigari),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Qui nascono incontri con PNG speciali e scommesse clandestine: serve lucidita per leggere i dialoghi alterati.',
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Hai accesso al balcone: dialoghi alterati, botte e scommesse clandestine animano lo spazio.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "L'arrivo della pipa/sigari apre quest secondarie e interazioni sbloccate solo se il livello di sbronza supera 8.",
          ),
        ),
        const SizedBox(height: 12),
        _actionButton('Scommessa clandestina', 'Rischia per rispetto', () {
          notifier.playMarafone();
        }),
      ],
    );
  }

  Widget _actionButton(String title, String subtitle, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInventory(GameState state) {
    if (state.inventory.isEmpty) {
      return const Text(
        'Inventario vuoto. Acquista consumabili per ottenere vantaggi temporanei e sbloccare effetti nascosti.',
      );
    }

    return Wrap(
      spacing: 10,
      children: state.inventory.map((item) {
        return Chip(
          label: Text('${item.name} x${item.quantity}'),
          backgroundColor: Colors.white10,
        );
      }).toList(),
    );
  }
}
