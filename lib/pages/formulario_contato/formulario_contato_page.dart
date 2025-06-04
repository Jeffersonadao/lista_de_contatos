import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pessoa_model.dart';

class FormularioContatoPage extends StatefulWidget {
  final PessoaModel pessoa;

  const FormularioContatoPage({super.key, required this.pessoa});

  @override
  State<FormularioContatoPage> createState() => _FormularioContatoPageState();
}

class _FormularioContatoPageState extends State<FormularioContatoPage> {
  late TextEditingController nomeController;
  late TextEditingController idadeController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;
  String imagePath = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.pessoa.nome);
    idadeController = TextEditingController(
      text: widget.pessoa.idade != 0 ? widget.pessoa.idade.toString() : '',
    );
    telefoneController = TextEditingController(text: widget.pessoa.telefone);
    emailController = TextEditingController(text: widget.pessoa.email);
    imagePath = widget.pessoa.imagePath;
  }

  Future<void> cropImage(XFile imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cortar Imagem',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cortar Imagem'),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imagePath = croppedFile.path;
      });
    }
  }

  void _escolherFoto() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Wrap(
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.camera),
                title: const Text("Câmera"),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    await cropImage(photo);
                  }
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.images),
                title: const Text("Galeria"),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final photo = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (photo != null) {
                    await cropImage(photo);
                  }
                },
              ),
            ],
          ),
    );
  }

  void _salvarContato() {
    if (_formKey.currentState!.validate()) {
      final pessoa = PessoaModel(
        objectId: widget.pessoa.objectId,
        nome: nomeController.text.trim(),
        idade: int.tryParse(idadeController.text) ?? 0,
        telefone: telefoneController.text.trim(),
        email: emailController.text.trim(),
        imagePath: imagePath,
      );

      Navigator.pop(context, pessoa);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulário de Contato")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _escolherFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.amber,
                  backgroundImage:
                      (imagePath.isNotEmpty && File(imagePath).existsSync())
                          ? FileImage(File(imagePath))
                          : null,
                  child:
                      (imagePath.isEmpty || !File(imagePath).existsSync())
                          ? const FaIcon(
                            FontAwesomeIcons.person,
                            size: 50,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Idade",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a idade';
                  }
                  final idade = int.tryParse(value);
                  if (idade == null || idade < 0) {
                    return 'Idade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o telefone'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o e-mail';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _salvarContato,
                    child: const Text("Salvar", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
