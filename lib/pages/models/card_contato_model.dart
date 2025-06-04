import 'dart:io';

import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';

class CardContatoModel extends StatelessWidget {
  final PessoaModel pessoa;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const CardContatoModel({
    super.key,
    required this.pessoa,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              pessoa.imagePath.isNotEmpty
                  ? FileImage(File(pessoa.imagePath))
                  : null,
          child: pessoa.imagePath.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(pessoa.nome),
        subtitle: Text('Tel: ${pessoa.telefone} - Email: ${pessoa.email}'),
        onTap: onTap,
        trailing:
            onDelete != null
                ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                )
                : null,
      ),
    );
  }
}
