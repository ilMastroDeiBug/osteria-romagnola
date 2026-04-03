import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardEntryModel {
  final String playerId;
  final String metric;
  final double value;
  final int timestamp;

  LeaderboardEntryModel({
    required this.playerId,
    required this.metric,
    required this.value,
    required this.timestamp,
  });

  factory LeaderboardEntryModel.fromEntity(LeaderboardEntry entry) {
    return LeaderboardEntryModel(
      playerId: entry.playerId,
      metric: entry.metric.name,
      value: entry.value,
      timestamp: entry.timestamp.millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'metric': metric,
      'value': value,
      'timestamp': timestamp,
    };
  }
}

