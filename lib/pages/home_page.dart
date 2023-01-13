import 'package:flutter/material.dart';
import 'package:pokequiz/pages/quiz_page.dart';
import 'package:pokequiz/widgets/button.dart';

import '../models/pokemon.dart';
import '../repositories/poke_repository.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key, required this.textoBotao, required this.listaPokeRecebida})
      : super(key: key);

  String textoBotao;
  final List<Pokemon> listaPokeRecebida;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeRepository pokeRepository = PokeRepository();
  List<Pokemon> listaPokemon = [];
  int pontuacao = 0;

  @override
  void initState() {
    super.initState();

    if (widget.listaPokeRecebida.isNotEmpty) {
      listaPokemon = widget.listaPokeRecebida;
    } else {
      pokeRepository.searchAll().then((lista) {
        setState(() {
          listaPokemon = lista;
        });
      });
    }

    pokeRepository.pegarPontuacao().then((ponto) => {setState(() {
      pontuacao =  ponto;
    })});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/fundo.jpg"),
                  fit: BoxFit.fill),
            ),
          ),
          FutureBuilder(
            builder: (context, snapshot) {
              if (listaPokemon.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                              scale: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                               Text(
                                "Recorde atual: $pontuacao",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Button(
                                title: widget.textoBotao,
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(
                                            listaPokemons: listaPokemon),
                                      ),
                                      (route) => false);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Buscando Pokemon's",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    )
                  ],
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
