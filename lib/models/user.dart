class User {
  final String id;
  final String nome;
  final String email;
  final String matricula;
  final String curso;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.matricula,
    required this.curso,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      matricula: map['matricula'],
      curso: map['curso'],
    );
  }
}