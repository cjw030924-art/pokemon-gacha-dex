import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // 🔑 Keys
  static const String _partnerIdKey = 'partner_pokemon_id';
  static const String _caughtIdsKey = 'caught_pokemon_ids';
  static const String _coinKey = 'coin';
  static const String _lastRewardTimeKey = 'last_coin_reward_time';

  /* =========================
     파트너 포켓몬
     ========================= */

  static Future<void> savePartnerId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_partnerIdKey, id);
  }

  static Future<int?> loadPartnerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_partnerIdKey);
  }

  static Future<void> clearPartner() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_partnerIdKey);
  }

  /* =========================
     잡은 포켓몬
     ========================= */

  static Future<void> saveCaughtIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _caughtIdsKey,
      ids.map((e) => e.toString()).toList(),
    );
  }

  static Future<List<int>> loadCaughtIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_caughtIdsKey);
    if (list == null) return [];
    return list.map(int.parse).toList();
  }

  static Future<void> clearCaughtIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_caughtIdsKey);
  }

  /* =========================
     포켓코인
     ========================= */

  static Future<void> saveCoin(int coin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinKey, coin);
  }

  static Future<int> loadCoin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinKey) ?? 0;
  }

  /* =========================
     코인 보상 쿨타임
     ========================= */

  // 마지막 코인 보상 시간 저장
  static Future<void> saveLastRewardTime(int millis) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastRewardTimeKey, millis);
  }

  // 마지막 코인 보상 시간 불러오기
  static Future<int?> loadLastRewardTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastRewardTimeKey);
  }

  /* =========================
     전체 초기화 (옵션)
     ========================= */

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
