import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Endereco> buscaEndereco(String cep) async {
  final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
  

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
  final cepController = TextEditingController(); // Controlador para o campo de entrada

  @override
  void initState() {
    super.initState();
    // Inicializa a variável com um CEP padrão (ou vazio)
    futureEndereco = buscaEndereco('14783069');
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
          child: Column(
            children: <Widget>[
              // Campo de entrada de texto para o CEP
              TextField(
                controller: cepController,
                decoration: const InputDecoration(labelText: 'Insira o CEP'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Obtém o CEP inserido pelo usuário
                  String cep = cepController.text;
                  // Atualiza a URL da solicitação com o novo CEP
                  setState(() {
                    futureEndereco = buscaEndereco(cep);
                  });
                },
                child: const Text('Buscar'),
              ),
              FutureBuilder<Endereco>(
                future: futureEndereco,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var endereco = snapshot.data;
                    return Text(
                      "\n\n\n\n\n\n\nCEP: ${endereco!.cep}\nEndereço: ${endereco.rua}\nComplemento: ${endereco.complemento}\nBairro: ${endereco.bairro}\nCidade: ${endereco.cidade} - ${endereco.estado}\nDDD: ${endereco.ddd}",
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose do controlador de texto quando não for mais necessário
    cepController.dispose();
    super.dispose();
  }
}