import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // VARIAVEIS
  final _tValor = TextEditingController();
  final _tPessoas = TextEditingController();
  final _tPessoasB = TextEditingController();
  final _tValorBebidaA = TextEditingController();
  final _tQuantidadeBebidaA = TextEditingController();
  double valor = 0;
  String label = "Porcentagem do Garçom : ";
  var _infoText = "Informe os dados!";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP Racha Conta"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields(){
    _tValor.text = "";
    _tPessoas.text = "";
    setState(() {
      _infoText = "Informe os dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Digite o valor da conta :", _tValor),
              _editText("Digite o número de pessoas que bebem bebidas alcoolicas :", _tPessoasB),
              _editText("Digite o número de pessoas que não estão bebendo bebidas alcoolicas :", _tPessoas),
              _editText("Digite o valor da bebida alcoolica :", _tValorBebidaA),
              _editText("Digite a quantidade de bebidas alcoolicas compradas :", _tQuantidadeBebidaA),
            Slider(
              //controller: controller,
                value: valor, //definir o valor inicial
                min:0,
                max:100,
                label: label, //label dinamico
                divisions: 10, //define as divisoes entre o minimo e o maximo
                activeColor: Colors.red,
                inactiveColor: Colors.black12,
                onChanged: (double novoValor){
                  setState(() {
                    valor = novoValor;
                    label = "Porcentagem do Garçom :  " + novoValor.toString() + "%";
                  });
                  // print("Valor selecionado: "+valor.toString());
                }),
              _buttonCalcular(),
              _textInfo(),
            ],
          ),
        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.blue,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: ElevatedButton(
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            _calculate();
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR O IMC
  void _calculate(){
    setState(() {
      
      double valorGeral = double.parse(_tValor.text); // Valor total da conta
      double pessoas = double.parse(_tPessoas.text); // pessoas que não bebem
      double pessoasB = double.parse(_tPessoasB.text); //pessoas que bebem
      double quantidadeB = double.parse(_tQuantidadeBebidaA.text); // Quantidade de bebidas alcoolicas
      double valorB = double.parse(_tValorBebidaA.text); //Valor das bebidas alcoolicas
      

      double valorGarcom = (valor/100 * valorGeral); //Gorgeta do Garçom
      double valorTotal = valorGeral + valorGarcom;  //Valor da conta mais a Gorgeta
      
      double valorBebidas = quantidadeB * valorB; //Valor bebido
      double valorBebidasU = valorBebidas/pessoasB; //Valor bebido dividido entre quem bebeu
      double valorUnitarioGeral = (valorTotal - valorBebidas)/ (pessoas + pessoasB); //valor unitário sem o adicional da bebida
      double valorUnitarioBebida = valorUnitarioGeral + valorBebidasU; //valor unitário com o adicional da bebida





      //String Total = Total.toStringAsPrecision(4);
      _infoText = "Valor Garçom = " + valorGarcom.toStringAsPrecision(4) + "\nValor total = " + valorTotal.toStringAsPrecision(4) + "\nValor unitario para quem bebeu = " + valorUnitarioBebida.toStringAsPrecision(4) + 
      "\nValor unitario para quem não bebeu = " + valorUnitarioGeral.toStringAsPrecision(4);
    });
  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue, fontSize: 25.0),
    );
  }
}
