import 'package:flutter/material.dart';
import '../data/pokemon_gen1_dummy.dart';
import '../model/pokemon.dart';

class PokedexView extends StatefulWidget {
  const PokedexView({super.key});

  @override
  State<PokedexView> createState() => _PokedexViewState();
}

class _PokedexViewState extends State<PokedexView> {
  int selectedGen = 1; // 1 ~ 9

  @override
  Widget build(BuildContext context) {
    // 현재 세대 포켓몬 목록 (지금은 1세대만)
    final List<Pokemon> currentPokemons = selectedGen == 1 ? gen1Pokemons : [];

    final int caughtCount = currentPokemons.where((p) => p.isCaught).length;
    final int totalCount = currentPokemons.length;

    return Scaffold(
      appBar: AppBar(title: Text('포켓몬 도감 · ${selectedGen}세대')),
      body: Column(
        children: [
          // 🔝 세대 선택 버튼
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final gen = index + 1;
                final bool isSelected = gen == selectedGen;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGen = gen;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${gen}세대',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 📊 완성도 표시 (퍼센트 ❌, n / total)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '${selectedGen}세대 : $caughtCount / $totalCount',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 8),

          // 📘 도감 그리드
          Expanded(
            child: currentPokemons.isEmpty
                ? const Center(
                    child: Text(
                      '아직 준비 중인 세대입니다',
                      style: TextStyle(color: Colors.black45),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentPokemons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final pokemon = currentPokemons[index];
                      return _PokemonCard(pokemon: pokemon);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final bool isCaught = pokemon.isCaught;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🧍 포켓몬 이미지 / 실루엣
          ClipOval(
            child: Image.asset(
              'assets/images/pokemon/gen1/${pokemon.name}.png',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              color: isCaught ? null : Colors.black87,
              colorBlendMode: isCaught ? null : BlendMode.srcIn,
            ),
          ),

          const SizedBox(height: 8),

          // 이름
          Text(
            isCaught ? pokemon.name : '???',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isCaught ? Colors.black : Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          // 번호
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
