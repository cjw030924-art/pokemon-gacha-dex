import 'package:flutter/foundation.dart';
import '../model/pokemon.dart';
import 'local_storage.dart';
import 'pokemon_gen1_dummy.dart';

// 현재 선택된 파트너 포켓몬
final ValueNotifier<Pokemon?> partnerPokemonNotifier = ValueNotifier<Pokemon?>(
  null,
);

/// 앱 시작 시 저장된 파트너 불러오기
Future<void> loadPartnerPokemon() async {
  final int? savedId = await LocalStorage.loadPartnerId();
  if (savedId == null) return;

  try {
    final pokemon = gen1Pokemons.firstWhere((p) => p.id == savedId);
    partnerPokemonNotifier.value = pokemon;
  } catch (_) {
    // 저장된 포켓몬이 없으면 무시
  }
}

/// 파트너 설정 + 자동 저장
void setPartnerPokemon(Pokemon pokemon) {
  partnerPokemonNotifier.value = pokemon;
  LocalStorage.savePartnerId(pokemon.id);
}

Future<void> loadCaughtPokemons() async {
  final ids = await LocalStorage.loadCaughtIds();

  for (final pokemon in gen1Pokemons) {
    pokemon.isCaught = ids.contains(pokemon.id);
  }
}

Future<void> catchPokemon(Pokemon pokemon) async {
  pokemon.isCaught = true;

  final ids = gen1Pokemons.where((p) => p.isCaught).map((p) => p.id).toList();

  await LocalStorage.saveCaughtIds(ids);
}
