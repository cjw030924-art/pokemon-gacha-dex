import 'package:flutter/material.dart';
import '../data/pokemon_gen1_dummy.dart';
import '../data/partner_state.dart';
import '../model/pokemon.dart';

class PartnerView extends StatelessWidget {
  const PartnerView({super.key});

  @override
  Widget build(BuildContext context) {
    // 내가 획득한 포켓몬만
    final List<Pokemon> caughtPokemons = gen1Pokemons
        .where((p) => p.isCaught)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('파트너 설정')),
      body: caughtPokemons.isEmpty
          ? const Center(
              child: Text(
                '아직 획득한 포켓몬이 없어요',
                style: TextStyle(fontSize: 16, color: Colors.black45),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: caughtPokemons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final pokemon = caughtPokemons[index];
                  return _PartnerSelectCard(
                    pokemon: pokemon,
                    onTap: () {
                      _showConfirmDialog(context, pokemon);
                    },
                  );
                },
              ),
            ),
    );
  }

  // ❓ 파트너 지정 확인 팝업
  void _showConfirmDialog(BuildContext context, Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('파트너 설정'),
          content: Text('이 포켓몬을 파트너로 지정할까요?\n\n${pokemon.name}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('아니오'),
            ),
            ElevatedButton(
              onPressed: () {
                setPartnerPokemon(pokemon); // ✅ 저장 + 상태 변경
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pop(context); // 파트너 설정 화면 닫기
              },
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }
}

class _PartnerSelectCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const _PartnerSelectCard({required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 포켓몬 이미지
            ClipOval(
              child: Image.asset(
                'assets/images/pokemon/gen1/${pokemon.name}.png',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 8),

            // 이름
            Text(
              pokemon.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            // 번호
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
