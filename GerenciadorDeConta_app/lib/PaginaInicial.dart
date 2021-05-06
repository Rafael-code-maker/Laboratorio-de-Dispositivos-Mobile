//import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

//import 'package:listatarefas_app/PaginaLogin.dart';
//import 'package:listatarefas_app/PaginaInicial.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  List<_tarefa> _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerData = TextEditingController();

  @override
  void initState() {
    _listarTarefas().then((List<_tarefa> rec) {
      setState(() {
        _listaTarefas = rec;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contas :"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        elevation: 6,
        child: Icon(Icons.add),
        onPressed: () {
          print("Botão pressionado!");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Conta: "),
                  content: Column(
                    children: <Widget>[
                      TextField(
                          controller: _controllerTarefa,
                          decoration: InputDecoration(labelText: 'Título'),
                          autofocus: true),
                      TextField(
                          controller: _controllerValor,
                          decoration: InputDecoration(labelText: 'Valor')),
                      TextField(
                          controller: _controllerData,
                          decoration: InputDecoration(labelText: 'Data')),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        textColor: Colors.deepPurple,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")),
                    FlatButton(
                        textColor: Colors.deepPurple,
                        onPressed: () async {
                          _salvarDados(_controllerTarefa.text,
                              _controllerValor.text, _controllerData.text);
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")),
                    _resetFields(),
                  ],
                );
              });
        },
      ),
      body: _body(),
    );
  }

  _body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _listaTarefas.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                title: Text(
                  _listaTarefas[index].tarefa,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                  ),
                ),
                subtitle: Text(
                  'Valor : ' +
                      _listaTarefas[index].valor +
                      " reais" +
                      "\nVencimento : " +
                      _listaTarefas[index].data,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                  ),
                ),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          //backgroundColor: Colors.deepPurple,
                          title: Text("Atualizar Conta"),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                  controller: _controllerTarefa,
                                  decoration:
                                      InputDecoration(labelText: 'Título'),
                                  autofocus: true),
                              TextField(
                                  controller: _controllerValor,
                                  decoration:
                                      InputDecoration(labelText: 'Valor')),
                              TextField(
                                  controller: _controllerData,
                                  decoration:
                                      InputDecoration(labelText: 'Data')),
                            ],
                          ),

                          actions: <Widget>[
                            FlatButton(
                                textColor: Colors.deepPurple,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancelar")),
                            FlatButton(
                                textColor: Colors.deepPurple,
                                onPressed: () async {
                                  _atualizarTarefa(
                                      _listaTarefas[index].idTarefa);
                                  setState(() {
                                    _listaTarefas[index].tarefa =
                                        _controllerTarefa.text;
                                    _controllerValor.text;
                                    _controllerData.text;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text("Salvar")),
                            _resetFields(),
                          ],
                        );
                      });
                },
                onLongPress: () async {
                  _excluirTarefa(_listaTarefas[index].idTarefa);
                  setState(() {
                    _listaTarefas.remove(_listaTarefas[index]);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  _excluirTarefa(int id) async {
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete("tarefas", where: "id=?", whereArgs: [id]);
    print("Itens excluidos: " + retorno.toString());
  }

  _atualizarTarefa(int id) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosTarefa = {
      "tarefa": _controllerTarefa.text,
      "valor": _controllerValor,
      "data": _controllerData,
    };
    int retorno = await bd
        .update("tarefas", dadosTarefa, where: "id = ?", //caracter curinga
            whereArgs: [id]);
    print("Itens atualizados: " + retorno.toString());
  }

  _salvarDados(String tarefa, String valor, String data) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosTarefa = {
      "tarefa": tarefa,
      "valor": valor,
      "data": data,
    };
    int id = await bd.insert("tarefas", dadosTarefa);
    setState(() {
      _listaTarefas.add(_tarefa(id, _controllerTarefa.text,
          _controllerValor.text, _controllerData.text));
    });
    print("Salvo: $id ");
  }

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = path.join(caminhoBancoDados, "banco.bd");
    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "CREATE TABLE tarefas (id INTEGER PRIMARY KEY AUTOINCREMENT, tarefa VARCHAR, valor VARCHAR, data VARCHAR) ";
      db.execute(sql);
    });
    return bd;
    //print("aberto: " + bd.isOpen.toString() );
  }

  Future<List<_tarefa>> _listarTarefas() async {
    Database db = await _recuperarBancoDados();
    List<Map<String, dynamic>> tarefas =
        await db.rawQuery("SELECT * FROM tarefas");
    List<_tarefa> resp = [];
    for (Map<String, dynamic> tasks in tarefas) {
      resp.add(
          _tarefa(tasks["id"], tasks["tarefa"], tasks["valor"], tasks["data"]));
    } //fim for
    return resp;
  }

  _resetFields() {
    _controllerTarefa.text = "";
    _controllerValor.text = "";
    _controllerData.text = "";
  }
}

/*
* Classe tarefa
* Um objeto do tipo tarefa contém os atributos id da tarefa e a tarefa em si.
*/
class _tarefa {
  int idTarefa;
  String tarefa;
  String valor;
  String data;

  _tarefa(idTarefa, tarefa, valor, data) {
    this.idTarefa = idTarefa;
    this.tarefa = tarefa;
    this.valor = valor;
    this.data = data;
  }
}
