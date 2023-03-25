import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _precoReais = "0";
  String _precoDolar = "0";
  String _precoEuro = "0";
  String _precoYen = "0";

  final NumberFormat _realFormat = NumberFormat.simpleCurrency(locale: "pt_BR", name: "BRL");
  final NumberFormat _dolarFormat = NumberFormat.simpleCurrency(locale: "en_US", name: "USD");
  final NumberFormat _euroFormat = NumberFormat.simpleCurrency(locale: "eu", name: "EUR");
  final NumberFormat _yenFormat = NumberFormat.simpleCurrency(locale: "ja-JP", name: "JPY");

  @override
  void initState() {
    _precoReais = _realFormat.format(0);
    _precoDolar = _dolarFormat.format(0);
    _precoEuro = _euroFormat.format(0);
    _precoYen = _yenFormat.format(0);

    super.initState();
  }

  void _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = json.decode(response.body);

    setState(() {
      _precoReais = _realFormat.format(retorno["BRL"]["buy"]);
      _precoDolar = _dolarFormat.format(retorno["USD"]["buy"]);
      _precoEuro = _euroFormat.format(retorno["EUR"]["buy"]);
      _precoYen = _yenFormat.format(retorno["JPY"]["buy"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        // Cor da StatusBar em dispositivos mobile
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.orange,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text("Cotação Bitcoin"),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/bitcoin.png"),
                const SizedBox(height: 30),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Reais: $_precoReais",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Dólar: $_precoDolar",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Euro: $_precoEuro",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Yen: $_precoYen",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _recuperarPreco,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                    child: Text(
                      "Obter cotação",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
