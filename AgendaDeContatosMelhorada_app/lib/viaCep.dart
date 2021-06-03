import 'package:flutter/material.dart';
import 'package:via_cep_search/via_cep_search.dart';
import 'package:agendacontatos_app/home.dart';

class ViaCep extends StatefulWidget {
  @override
  _ViaCepState createState() => _ViaCepState();
}

class _ViaCepState extends State<ViaCep> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Busca CEP"),
      ),
      body: Center(
          child: FutureBuilder<ViaCepSearch>(
              future: ViaCepSearch.getInstance("69005180"),
              builder: (context, snapshot) {
                return Text(snapshot.data == null
                    ? ""
                    : snapshot.data.bairro + " " +
                        snapshot.data.localidade +" " +
                        snapshot.data.cep +" " +
                        snapshot.data.complemento +" " +
                        snapshot.data.logradouro);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
