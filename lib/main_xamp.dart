import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Endereco> buscaEndereco() async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2/recebeget.php?nome=Cleitão&idade=32&carro=Fiat 147'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Endereco.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Falha no carregamento do Endereço');
  }
}

class Endereco {
  final String nome;
  final int novaidade;
  final String carro;

  const Endereco(
      {required this.nome, required this.novaidade, required this.carro});

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      nome: json['nome'],
      novaidade: json['novaidade'],
      carro: json['carro'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Endereco> futureEndereco;

  @override
  void initState() {
    super.initState();
    futureEndereco = buscaEndereco();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de busca de dados',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Busca exemplo de dados no XAMPP'),
        ),
        body: Center(
          child: FutureBuilder<Endereco>(
            future: futureEndereco,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var nome = snapshot.data!.nome;
                var idade = snapshot.data!.novaidade.toString();
                var carro = snapshot.data!.carro;
                return Text("$nome tem uma nova idade: $idade anos.\nSeu carro é: $carro");
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
