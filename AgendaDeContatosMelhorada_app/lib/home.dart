import 'dart:io';

import 'package:agendacontatos_app/viaCep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:via_cep_search/via_cep_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:agendacontatos_app/imagem.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key key, this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _controllerNome = TextEditingController(); //Campo Nome do Contato
  var _controllerEmail = TextEditingController(); //Campo E-mail do Contato
  var _controllerEndereco = TextEditingController(); //Campo Endereco do Contato
  var _controllerCEP = TextEditingController(); //Campo CEP do Contato
  var _controllerTelefone = TextEditingController(); //Campo Telefone do Contato
  var _controllerBusca =
      TextEditingController(); //Campo para a busca de Contato por meio do identificador
  var item;
  var snapshots;
  var cep;
  int identificador = 0;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    snapshots = db
        .collection("contatos")
        .where('excluido', isEqualTo: false)
        .snapshots();


    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Agenda de Contatos"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.add_road)),
              //Icone ilustrativo da cep
              Tab(icon: Icon(Icons.upload_file)),
              //Icone ilustrativo da teste
              Tab(icon: Icon(Icons.group_add)),
              //Icone ilustrativo da primeira tela
              Tab(icon: Icon(Icons.list)),
              //Icone ilustrativo da segunda tela
              Tab(icon: Icon(Icons.system_update_alt)),
              //Icone ilustrativo da terceira tela
            ],
          ),
        ),
        body: TabBarView(
          children: [
            new Container(
              child: ViaCep(),
            ),
            new Container(
                child: Imagem(),
            ),

            //Primeira Tela -> Página de cadastro de um novo contato
            new Container(
              child: new Form(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    //Campo de entrada do nome do contato
                    TextFormField(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "Nome: ", hintText: "Nome do contato"),
                      controller: _controllerNome,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Digite o nome";
                        } //fim if
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Campo para a entrada do e-mail do contato
                    TextFormField(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "E-mail:", hintText: "E-mail do contato"),
                      controller: _controllerEmail,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Digite o e-mail ";
                        } //fim if
                        if (text.contains("@") == false) {
                          return "Formato de e-mail inválido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Campo para a entrada do telefone do contato
                    TextFormField(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "Telefone:",
                          hintText: "Telefone do contato"),
                      controller: _controllerTelefone,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Digite o Telefone ";
                        } //fim if
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Campo para a entrada do endereco do contato
                    TextFormField(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "Endereço:",
                          hintText: "Endereço do contato (opcional)"),
                      controller: _controllerEndereco,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Campo para a entrada do CEP do contato
                    TextFormField(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "CEP:",
                          hintText: "CEP do contato (opcional)"),
                      controller: _controllerCEP,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: 40,
                    child : ElevatedButton(
                      child: Text("Adicionar imagem",style: TextStyle(fontSize: 20, color: Colors.white,),),
                      onPressed: () {
                         return Container(child : Imagem());
                      },
                    ),),
                    //Botão para salvar um novo contato na agenda de contatos
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: 40,
                      child: ElevatedButton(
                        child: Text(
                          "Cadastrar novo contato",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        //onPressed: () => null
                        onPressed: () async {
                          print("Novo contato adicionado a agenda");
                          FirebaseFirestore.instance
                              .collection("contatos")
                              .doc(_controllerEmail.text)
                              .set({
                            "nome": _controllerNome.text,
                            "email": _controllerEmail.text,
                            "telefone": _controllerTelefone.text,
                            "endereco": _controllerEndereco.text,
                            "cep": _controllerEndereco.text,
                            "excluido": false,
                            "identificador": _controllerEmail.text,
                            "codigo": identificador,
                          });
                          _resetFields();
                          _incrementaID();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Segunda Tela -> Página de listagem dos contatos
            new Container(
              child: new StreamBuilder(
                stream: snapshots,
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return Center(
                      child: Text("Error: ${snapshots.error}"),
                    );
                  } //fim if
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } //fim if
                  //Se o banco de dados estiver vazio, o ID do proximo contato a ser inserido será igual a 0.
                  if (snapshots.data.documents.length == 0) {
                    identificador = 0;
                    print("Nenhum contato na agenda");
                    print("ID do proximo contato = $identificador");
                    //Se o banco de dados já possuir contatos cadastrados, o ID do proximo contato a ser inserido
                    //será igual ao ID do ultimo contato inserido + 1.
                  } else {
                    var posUltimo = snapshots.data.documents.length - 1;
                    var ultimoContato = snapshots.data.documents[posUltimo];
                    print(ultimoContato['codigo']);
                    identificador = ultimoContato['codigo'] + 1;
                  } //fim if
                  return ListView.builder(
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, i) {
                      var item = snapshots.data.documents[i];
                      return ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.contact_phone),
                          iconSize: 32,
                          onPressed: () => null,
                        ),
                        //Atributos que aparecem de cada contato na listagem
                        title: Text(item['nome']),
                        subtitle:
                            Text('Identificador: ' + item['identificador']),
                        onTap: () async {
                          print(item['nome']);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            //Terceira Tela -> Página de busca, exclusão e alteração de um contato
            new Container(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  //Campo de entrada do identificador do contato para a realização da busca.
                  TextFormField(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        labelText: "Buscar Contato: ",
                        hintText: "Identificador para a busca"),
                    controller: _controllerBusca,
                    validator: (String text) {
                      if (text.isEmpty) {
                        return "Digite o texto";
                      } //fim if
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Botao para buscar um contato na agenda.
                  Container(
                    height: 35,
                    child: ElevatedButton(
                      child: Text(
                        "Buscar",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onPressed: () async {
                        print(_controllerBusca.text);
                        String caminho = _controllerBusca
                            .text; //String que contem o caminho para realizar a busca do contato desejado.
                        var contato = await FirebaseFirestore.instance
                            .doc('/contatos/' + caminho)
                            .get(); //Armazena os dados do contato que está sendo buscado.
                        if (contato['excluido'] == false) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Dados do Contato'),
                                  content: Form(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Campo para entrada de uma possível alteração do nome do contato.
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Nome',
                                            labelText: 'Nome: ' +
                                                contato[
                                                    'nome'], //Mostra como está cadastrado atualmente o nome do contato.
                                          ),
                                          controller: _controllerNome,
                                        ),
                                        //Campo para entrada de uma possível alteração do e-mail do contato.
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'E-mail',
                                            labelText: 'E-mail: ' +
                                                contato[
                                                    'email'], //Mostra como está cadastrado atualmente o e-mail do contato.
                                          ),
                                          controller: _controllerEmail,
                                        ),
                                        //Campo para entrada de uma possível alteração do telefone do contato.
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Telefone',
                                            labelText: 'Telefone: ' +
                                                contato[
                                                    'telefone'], //Mostra como está cadastrado atualmente o telefone do contato.
                                          ),
                                          controller: _controllerTelefone,
                                        ),
                                        //Campo para entrada de uma possível alteração do endereco do contato.
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Endereço',
                                            labelText: 'Endereço: ' +
                                                contato[
                                                    'endereco'], //Mostra como está cadastrado atualmente o endereco do contato.
                                          ),
                                          controller: _controllerEndereco,
                                        ),
                                        //Campo para entrada de uma possível alteração do CEP do contato.
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'CEP',
                                            labelText: 'CEP: ' +
                                                contato[
                                                    'cep'], //Mostra como está cadastrado atualmente o CEP do contato.
                                          ),
                                          controller: _controllerCEP,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    //Botão para cancelar ação sobre o contato buscado.
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _resetFields();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    //Botão para excluir o contato buscado.
                                    TextButton(
                                      //onPressed: () => null,
                                      onPressed: () async {
                                        //print(_controllerNome.text);
                                        print("Excluindo " +
                                            contato['nome'] +
                                            "...");
                                        print(caminho);
                                        await FirebaseFirestore.instance
                                            .doc('/contatos/' + caminho)
                                            .update({'excluido': true});
                                        _resetFields();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Excluir'),
                                    ),
                                    //Botao para alterar o contato buscado.
                                    //O atributo do contato apenas será alterado se for cedido pelo usuario uma atualização de determinado campo.
                                    TextButton(
                                      onPressed: () async {
                                        if (_controllerNome.text != "") {
                                          await FirebaseFirestore.instance
                                              .doc('contatos/' + caminho)
                                              .update({
                                            'nome': _controllerNome.text
                                          });
                                          print("Alterou nome do contato");
                                        } //fim if
                                        if (_controllerEmail.text != "") {
                                          await FirebaseFirestore.instance
                                              .doc('contatos/' + caminho)
                                              .update({
                                            'email': _controllerEmail.text
                                          });
                                          print("Alterou email do contato");
                                        } //fim if
                                        if (_controllerTelefone.text != "") {
                                          await FirebaseFirestore.instance
                                              .doc('contatos/' + caminho)
                                              .update({
                                            'telefone': _controllerTelefone.text
                                          });
                                          print("Alterou telefone do contato");
                                        } //fim if
                                        if (_controllerEndereco.text != "") {
                                          await FirebaseFirestore.instance
                                              .doc('contatos/' + caminho)
                                              .update({
                                            'endereco': _controllerEndereco.text
                                          });
                                          print("Alterou endereco do contato");
                                        } //fim if
                                        if (_controllerCEP.text != "") {
                                          await FirebaseFirestore.instance
                                              .doc('contatos/' + caminho)
                                              .update(
                                                  {'cep': _controllerCEP.text});
                                          print("Alterou CEP do contato");
                                        } //fim if
                                        _resetFields();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Atualizar'),
                                    ),
                                  ],
                                );
                              });
                        } else {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //PROCEDIMENTO PARA LIMPAR CAMPOS
  void _resetFields() {
    _controllerNome.text = "";
    _controllerEmail.text = "";
    _controllerTelefone.text = "";
    _controllerEndereco.text = "";
    _controllerCEP.text = "";
    _controllerBusca.text = "";
  }

  //Incrementa o ID (codigo) utilizado para a identificacao dos contatos.
  void _incrementaID() {
    identificador++;
  }

}
