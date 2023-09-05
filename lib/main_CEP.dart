import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Endereco> buscaEndereco() async {
  final response =
      await http.get(Uri.parse('https://viacep.com.br/ws/14781449/json/'));

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
  final String cep;
  final String rua;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String ddd;

  const Endereco({
    required this.cep,
    required this.rua,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.ddd,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'],
      rua: json['logradouro'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      cidade: json['localidade'],
      estado: json['uf'],
      ddd: json['ddd'],
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
      title: 'Busca de dados CEP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Busca dados em CEP'),
        ),
        body: Center(
          child: FutureBuilder<Endereco>(
            future: futureEndereco,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var cep = snapshot.data!.cep;
                var rua = snapshot.data!.rua;
                var complemento = snapshot.data!.complemento;
                var bairro = snapshot.data!.bairro;
                var cidade = snapshot.data!.cidade;
                var estado = snapshot.data!.estado;
                var ddd = snapshot.data!.ddd;
                return Text(
                    "CEP: $cep\nEndereço: $rua\nComplemento: $complemento\nBairro: $bairro\nCidade: $cidade - $estado\nDDD: $ddd");
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
