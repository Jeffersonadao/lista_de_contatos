📱 Lista de Contatos

Um aplicativo Flutter para cadastro, listagem, edição e remoção de contatos, integrado ao Back4App como backend (Parse Server). Permite o gerenciamento de uma lista de contatos com informações como nome, idade, telefone, e-mail e foto de perfil.

🚀 Funcionalidades

✅ Listagem de contatos com dados armazenados no Back4App.

✅ Cadastro de novos contatos.

✅ Edição dos dados dos contatos.

✅ Remoção de contatos.

✅ Upload e edição (crop) de foto de perfil.

✅ Validação de e-mail, telefone e idade.

✅ Integração completa via REST API com Back4App.

✅ Interface moderna e intuitiva usando Flutter e pacotes de ícones.

🛠️ Tecnologias e Dependências

Flutter

Dart

Back4App (Parse Server) — Backend em nuvem

HTTP — Comunicação com a API REST

Image Picker — Captura de imagens da câmera e galeria

Image Cropper — Corte de imagem para fotos de perfil

Font Awesome Flutter — Ícones estilizados

Brasil Fields — Máscara de telefone (formatação brasileira)

Email Validator — Validação de e-mails



📄 Estrutura da Classe Pessoa no Back4App:

Campo	Tipo	Descrição
objectId	String	ID gerado automaticamente
nome	String	Nome do contato
idade	Int	Idade do contato
telefone	String	Telefone
email	String	E-mail
imagePath	String	Caminho da imagem
createdAt	Date	Data de criação
updatedAt	Date	Data de atualização

🖥️ Telas do App

Tela inicial: Lista todos os contatos cadastrados.

Tela de formulário: Permite adicionar ou editar os dados de um contato, com validações e upload de foto.

Upload de imagem: Seleção por câmera ou galeria, com opção de crop quadrado.

⚙️ Como executar
Clone o repositório:

bash
Copiar
Editar
git clone https://github.com/Jeffersonadao/lista_de_contatos.git
cd lista_de_contatos
Instale as dependências:

bash
Copiar
Editar
flutter pub get
Execute o projeto:

bash
Copiar
Editar
flutter run

💡 Observações

Para funcionar corretamente, é necessário ter um projeto ativo no Back4App com a classe Pessoa criada, e os campos corretamente definidos.


📝 Melhorias Futuras

🔄 Upload real de imagens para armazenamento na nuvem (ex.: Firebase Storage ou Parse Files).

🔍 Implementar busca de contatos.

🌙 Tema claro/escuro.

🔔 Notificações.

👨‍💻 Desenvolvedor
Feito com ❤️ por Jefferson Adao

📜 Licença
Este projeto é livre para uso acadêmico e pessoal.
