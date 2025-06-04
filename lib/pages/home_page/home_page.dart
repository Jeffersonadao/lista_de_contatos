import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lista_contatos/pages/formulario_contato/formulario_contato_page.dart';
import 'package:lista_contatos/pages/models/card_contato_model.dart';
import 'package:lista_contatos/pages/models/pessoa_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PessoaModel> pessoas = [];

  // Dados do Back4App
  final String applicationId = '0FAUaMzUCIo1rSMQ30hMHl8ihE6bib2RlOmkxwve';
  final String restApiKey = 'W3AY8Hr5NkN00sFrh5czCODRWjp6i1nrx7MxdWA8';
  final String url = 'https://parseapi.back4app.com/classes/Pessoa';

  Map<String, String> get headers => {
    'X-Parse-Application-Id': applicationId,
    'X-Parse-REST-API-Key': restApiKey,
    'Content-Type': 'application/json',
  };

  @override
  void initState() {
    super.initState();
    _carregarPessoas();
  }

  Future<void> _carregarPessoas() async {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      setState(() {
        pessoas =
            results
                .map((e) => PessoaModel.fromJson(e as Map<String, dynamic>))
                .toList();
      });
    } else {
      print('Erro ao carregar pessoas: ${response.body}');
    }
  }

  Future<void> _adicionarOuEditarPessoa([
    PessoaModel? pessoa,
    int? index,
  ]) async {
    final pessoaParaEditar =
        pessoa ??
        PessoaModel(nome: '', idade: 0, telefone: '', email: '', imagePath: '');

    final pessoaAtualizada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioContatoPage(pessoa: pessoaParaEditar),
      ),
    );

    if (pessoaAtualizada != null && pessoaAtualizada is PessoaModel) {
      final bodyMap = {
        'nome': pessoaAtualizada.nome,
        'idade': pessoaAtualizada.idade,
        'telefone': pessoaAtualizada.telefone,
        'email': pessoaAtualizada.email,
      };

      if (pessoaAtualizada.imagePath.isNotEmpty) {
        bodyMap['imagePath'] = pessoaAtualizada.imagePath;
      }

      final body = jsonEncode(bodyMap);

      if (pessoaAtualizada.objectId != null) {
        // Atualizar
        final response = await http.put(
          Uri.parse('$url/${pessoaAtualizada.objectId}'),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          _carregarPessoas();
        } else {
          print('Erro ao atualizar: ${response.body}');
        }
      } else {
        // Criar
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 201) {
          _carregarPessoas();
        } else {
          print('Erro ao criar: ${response.body}');
        }
      }
    }
  }

  Future<void> _removerPessoa(int index) async {
    final objectId = pessoas[index].objectId!;
    final response = await http.delete(
      Uri.parse('$url/$objectId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        pessoas.removeAt(index);
      });
    } else {
      print('Erro ao deletar: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.amber,
        title: const Center(child: Text("Lista de Contatos")),
      ),
      body: ListView.builder(
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          final pessoa = pessoas[index];
          return CardContatoModel(
            pessoa: pessoa,
            onTap: () => _adicionarOuEditarPessoa(pessoa, index),
            onDelete: () => _removerPessoa(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditarPessoa(),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
