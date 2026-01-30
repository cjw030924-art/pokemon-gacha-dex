import 'package:flutter/material.dart';
import '../data/pokemon_gen1_dummy.dart';
import '../data/pokemon_gen2_dummy.dart';
import '../data/pokemon_gen3_dummy.dart';
import '../model/pokemon.dart';

class PokedexView extends StatefulWidget {
  const PokedexView({super.key});

  @override
  State<PokedexView> createState() => _PokedexViewState();
}

class _PokedexViewState extends State<PokedexView> {
  int selectedGen = 1;

  List<Pokemon> get currentPokemons {
    switch (selectedGen) {
      case 1:
        return gen1Pokemons;
      case 2:
        return gen2Pokemons;
      case 3:
        return gen3Pokemons;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final caughtCount = currentPokemons.where((p) => p.isCaught).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          '포켓몬 도감 · ${selectedGen}세대',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // 세대 버튼
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final gen = index + 1;
                final selected = gen == selectedGen;

                return GestureDetector(
                  onTap: () => setState(() => selectedGen = gen),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      '${gen}세대',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 진행도
          Text(
            '$caughtCount / ${currentPokemons.length} 포획',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          // 도감
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
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.78,
                        ),
                    itemBuilder: (_, index) =>
                        _PokemonCard(pokemon: currentPokemons[index]),
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
    final caught = pokemon.isCaught;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ClipOval(
                child: Container(
                  color: const Color(0xFFF0F1F3),
                  width: 72,
                  height: 72,
                  child: Image.asset(
                    'assets/images/pokemon/gen1/${pokemon.name}.png',
                    fit: BoxFit.cover,
                    color: caught ? null : Colors.black87,
                    colorBlendMode: caught ? null : BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caught ? pokemon.name : '???',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: caught ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}
