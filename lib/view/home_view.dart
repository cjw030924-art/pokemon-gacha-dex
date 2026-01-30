import 'package:flutter/material.dart';
import '../data/partner_state.dart';
import '../data/coin_state.dart';
import '../data/coin_reward_state.dart';
import '../model/pokemon.dart';
import 'gacha_view.dart';
import 'pokedex_view.dart';
import 'partner_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    loadPartnerPokemon();
    loadCaughtPokemons();
    loadCoin();
    loadCoinRewardCooldown(); // ✅ 코인 보상 쿨타임 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 상단 UI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ValueListenableBuilder<Pokemon?>(
                valueListenable: partnerPokemonNotifier,
                builder: (context, partner, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 코인
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          ValueListenableBuilder<int>(
                            valueListenable: coinNotifier,
                            builder: (context, coin, _) {
                              return Text(
                                coin.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      // 👤 파트너 이름
                      Text(
                        partner == null ? '파트너: 없음' : '파트너: ${partner.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 🟢 코인 보상 버튼
            ValueListenableBuilder<Duration>(
              valueListenable: rewardCooldownNotifier,
              builder: (context, cooldown, _) {
                final canGetReward = cooldown == Duration.zero;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: canGetReward
                          ? () async {
                              final success = await tryGetCoinReward();
                              if (!success) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('+1000 코인을 획득했어요!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        canGetReward
                            ? '코인 받기 (+1000)'
                            : '다음 보상까지 ${cooldown.inSeconds}초',
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🧍 중앙 파트너 포켓몬
            Expanded(
              child: Center(
                child: ValueListenableBuilder<Pokemon?>(
                  valueListenable: partnerPokemonNotifier,
                  builder: (context, partner, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
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
                          child: Center(
                            child: partner == null
                                ? const Text(
                                    '파트너\n포켓몬',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/pokemon/gen1/${partner.name}.png',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          partner == null
                              ? '오늘도 함께 도감을 채워보자!'
                              : '${partner.name}와 함께 모험 중!',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ⬇️ 하단 버튼 3개
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomButton(
                    icon: Icons.casino,
                    label: '뽑기',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GachaView()),
                      );
                    },
                  ),
                  _bottomButton(
                    icon: Icons.menu_book,
                    label: '도감',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PokedexView()),
                      );
                    },
                  ),
                  _bottomButton(
                    icon: Icons.settings,
                    label: '파트너 설정',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PartnerView()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
