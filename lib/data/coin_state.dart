import 'package:flutter/foundation.dart';
import 'local_storage.dart';

final ValueNotifier<int> coinNotifier = ValueNotifier<int>(0);

Future<void> loadCoin() async {
  final coin = await LocalStorage.loadCoin();
  coinNotifier.value = coin;
}

Future<void> addCoin(int amount) async {
  coinNotifier.value += amount;
  await LocalStorage.saveCoin(coinNotifier.value);
}

Future<void> spendCoin(int amount) async {
  coinNotifier.value -= amount;
  if (coinNotifier.value < 0) coinNotifier.value = 0;
  await LocalStorage.saveCoin(coinNotifier.value);
}
