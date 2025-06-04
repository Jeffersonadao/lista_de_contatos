class PessoaModel {
  String? objectId;
  String nome;
  int idade;
  String telefone;
  String email;
  String imagePath;

  PessoaModel({
    this.objectId,
    required this.nome,
    required this.idade,
    required this.telefone,
    required this.email,
    required this.imagePath,
  });

  factory PessoaModel.fromJson(Map<String, dynamic> json) {
    return PessoaModel(
      objectId: json['objectId'],
      nome: json['nome'],
      idade: json['idade'],
      telefone: json['telefone'],
      email: json['email'],
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'idade': idade,
      'telefone': telefone,
      'email': email,
      'imagePath': imagePath,
    };
  }
}
