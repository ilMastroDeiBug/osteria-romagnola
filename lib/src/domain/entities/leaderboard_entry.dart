enum LeaderboardMetric {
  marafoneWins,
  banconeSbronza,
  richestOsteria,
}

class LeaderboardEntry {
  final String playerId;
  final LeaderboardMetric metric;
  final double value;
  final DateTime timestamp;

  const LeaderboardEntry({
    required this.playerId,
    required this.metric,
    required this.value,
    required this.timestamp,
  });
}

