class ApplySbronzaUseCase {
  int call(int currentLevel, int delta) {
    final nextLevel = currentLevel + delta;
    return nextLevel.clamp(0, 10).toInt();
  }
}

