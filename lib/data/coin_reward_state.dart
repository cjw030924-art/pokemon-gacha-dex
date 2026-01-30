import 'dart:async';
import 'package:flutter/foundation.dart';
import 'local_storage.dart';
import 'coin_state.dart';

const int rewardAmount = 1000;
const Duration rewardCooldown = Duration(seconds: 5);

final ValueNotifier<Duration> rewardCooldownNotifier = ValueNotifier(
  Duration.zero,
);

Timer? _cooldownTimer;

DateTime? _lastRewardTime;

/// 앱 시작 시 호출
Future<void> loadCoinRewardCooldown() async {
  final millis = await LocalStorage.loadLastRewardTime();
  if (millis == null) {
    rewardCooldownNotifier.value = Duration.zero;
    return;
  }

  _lastRewardTime = DateTime.fromMillisecondsSinceEpoch(millis);
  _startCooldownTimer();
}

/// 코인 보상 시도
Future<bool> tryGetCoinReward() async {
  if (rewardCooldownNotifier.value != Duration.zero) return false;

  // 코인 지급
  addCoin(rewardAmount);

  // 시간 저장
  _lastRewardTime = DateTime.now();
  await LocalStorage.saveLastRewardTime(
    _lastRewardTime!.millisecondsSinceEpoch,
  );

  _startCooldownTimer();
  return true;
}

/// ⏱️ 핵심: 1초마다 쿨타임 갱신
void _startCooldownTimer() {
  _cooldownTimer?.cancel();

  _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_lastRewardTime == null) {
      rewardCooldownNotifier.value = Duration.zero;
      timer.cancel();
      return;
    }

    final passed = DateTime.now().difference(_lastRewardTime!);
    final remain = rewardCooldown - passed;

    if (remain <= Duration.zero) {
      rewardCooldownNotifier.value = Duration.zero;
      timer.cancel();
    } else {
      rewardCooldownNotifier.value = remain;
    }
  });
}
