import 'package:flutter/material.dart';
import 'package:pokequiz/models/pokemon.dart';
import 'package:pokequiz/pages/home_page.dart';
import 'package:pokequiz/repositories/poke_repository.dart';
import 'package:pokequiz/widgets/button.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.listaPokemons}) : super(key: key);
  final List<Pokemon> listaPokemons;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String url =
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png";

  PokeRepository pokeRepository = PokeRepository();

  var sorteados = [];
  String pokemonCorreto = "";
  int pokeSorteado = 0;
  int pontuacao = 0;
  bool revela = false;
  var jaSorteados = [];

  void sorteiaPokemons() {
    sorteados.clear();
  
    do{
      pokeSorteado = Random().nextInt(50);
    }while(jaSorteados.contains(pokeSorteado));

    setState(() {    
      var str1 = widget.listaPokemons[pokeSorteado].name[0].toUpperCase();
      str1 = str1 + widget.listaPokemons[pokeSorteado].name.substring(1).toLowerCase();

      pokemonCorreto = str1;
      url = widget.listaPokemons[pokeSorteado].sprite;
    });

    sorteados.add(pokemonCorreto);

    if (!jaSorteados.contains(pokeSorteado)) {
      jaSorteados.add(pokeSorteado);
    }

    int indiceSort = Random().nextInt(50);
    for (var i = 0; i < 3; i++) {
      do {
        indiceSort = Random().nextInt(50);
      } while (indiceSort == pokeSorteado);
      
      var str = widget.listaPokemons[indiceSort].name[0].toUpperCase();
      str = str + widget.listaPokemons[indiceSort].name.substring(1).toLowerCase();

       sorteados.add(str);
    }

    setState(() {
      sorteados.shuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    sorteiaPokemons();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Parabens!!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Você chegou ao final do jogo!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Recomeçar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                            textoBotao: "Jogar",
                            listaPokeRecebida: widget.listaPokemons),
                      ),
                      (route) => false);
                },
              ),
            ],
          );
        },
      );
    }

    void verificaResposta(String name) async {
      if (name == pokemonCorreto) {
        setState(() {
          pontuacao++;
          revela = true;
        });

        if (jaSorteados.length == 50) {
          _showMyDialog();
        } else {
          await Future.delayed(const Duration(seconds: 1));
          sorteiaPokemons();

          setState(() {
            revela = false;
          });
        }


      } else {
        
        final recorde = await pokeRepository.pegarPontuacao();

        if(pontuacao > recorde){
          await pokeRepository.salvarPontuacao(pontuacao);
        }

        setState(() {
          pontuacao = 0;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(
                  textoBotao: "Jogar novamente",
                  listaPokeRecebida: widget.listaPokemons),
            ),
            (route) => false);
      }
    }

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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    width: 180,
                    height: 190,
                    child:
                        Image.network(url, color: revela ? null : Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Pontos: $pontuacao",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: ListView(
                      children: [
                        Button(
                            title: sorteados[0],
                            onPressed: () => verificaResposta(sorteados[0])),
                        const SizedBox(
                          height: 13,
                        ),
                        Button(
                            title: sorteados[1],
                            onPressed: () => verificaResposta(sorteados[1])),
                        const SizedBox(
                          height: 13,
                        ),
                        Button(
                            title: sorteados[2],
                            onPressed: () => verificaResposta(sorteados[2])),
                        const SizedBox(
                          height: 13,
                        ),
                        Button(
                            title: sorteados[3],
                            onPressed: () => verificaResposta(sorteados[3]))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
