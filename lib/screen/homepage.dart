import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final TextEditingController _controllerCEP = TextEditingController();

  String _lougadouro = "";
  String _complemento = "";
  String _bairro = "";
  String _localidade = "";

  void _recuperarCep() async {
    String cepDigitado = _controllerCEP.text;
    var url = Uri.parse("https://viacep.com.br/ws/$cepDigitado/json/");
    http.Response response;

    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);

    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];

    setState(() {
      _lougadouro = "Logradouro: $logradouro";
      _complemento = "Complemento: $complemento";
      _bairro = "Bairro: $bairro";
      _localidade = "Localidade $localidade";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumo de serviços')),
      body: Container(
        padding: const EdgeInsets.all(29),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Consumo de API CEP',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFielContainer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Digte o seu CEP',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  enabled: true,
                ),
                keyboardType: TextInputType.number,
                maxLength: 8,
                controller: _controllerCEP,
              ),
            ),
            ElevatedButton(
              onPressed: _recuperarCep,
              child: const Text('Pesquisar por CEP'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_lougadouro),
                  Text(_complemento),
                  Text(_bairro),
                  Text(_localidade),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextFielContainer extends StatelessWidget {
  final Widget child;
  const TextFielContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size w = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      width: w.width * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
