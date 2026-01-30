import 'dart:math';
import 'package:flutter/material.dart';
import '../data/pokemon_gen1_dummy.dart';
import '../data/partner_state.dart';
import '../data/coin_state.dart';
import '../model/pokemon.dart';

class GachaView extends StatefulWidget {
  const GachaView({super.key});

  @override
  State<GachaView> createState() => _GachaViewState();
}

class _GachaViewState extends State<GachaView> {
  bool _isDrawing = false;

  static const int gachaCost = 100;
  static const int duplicateReward = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('포켓몬 뽑기'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder<int>(
              valueListenable: coinNotifier,
              builder: (context, coin, _) {
                return Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      coin.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ValueListenableBuilder<int>(
            valueListenable: coinNotifier,
            builder: (context, coin, _) {
              final canDraw = coin >= gachaCost && !_isDrawing;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🎰 가챠 머신 카드
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.catching_pokemon,
                          size: 72,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '포켓몬 가챠',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '코인 ${gachaCost}개로\n랜덤 포켓몬을 획득하세요!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🎯 뽑기 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: canDraw ? _onDrawPressed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canDraw
                            ? Colors.redAccent
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _isDrawing ? '뽑는 중...' : '뽑기 (${gachaCost} 코인)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (coin < gachaCost)
                    const Text(
                      '코인이 부족해요!',
                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onDrawPressed() async {
    setState(() => _isDrawing = true);

    // 💸 코인 차감
    await spendCoin(gachaCost);

    final pokemon = _drawRandomPokemon();
    await _showResult(context, pokemon);

    if (!mounted) return;
    setState(() => _isDrawing = false);
  }

  Pokemon _drawRandomPokemon() {
    final rand = Random();
    return gen1Pokemons[rand.nextInt(gen1Pokemons.length)];
  }

  Future<void> _showResult(BuildContext context, Pokemon pokemon) async {
    final bool isNew = !pokemon.isCaught;

    if (isNew) {
      await catchPokemon(pokemon);
    } else {
      await addCoin(duplicateReward);
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isNew ? '새 포켓몬!' : '중복 포켓몬'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/pokemon/gen1/${pokemon.name}.png',
              width: 120,
            ),
            const SizedBox(height: 12),
            Text(
              isNew
                  ? pokemon.name
                  : '${pokemon.name}\n(+${duplicateReward} 코인)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
