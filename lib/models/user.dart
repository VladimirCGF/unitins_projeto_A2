class User {
  final String idUser;
  final String nome;
  final String cpf;
  final String email;
  final String matricula;
  final String curso;

  User({
    required this.idUser,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.matricula,
    required this.curso,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'],
      nome: map['nome'],
      cpf: map['cpf'],
      email: map['email'],
      matricula: map['matricula'],
      curso: map['curso'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'matricula': matricula,
      'curso': curso,
    };
  }

  User copyWith({
    String? idUser,
    String? nome,
    String? cpf,
    String? email,
    String? matricula,
    String? curso,
  }) {
    return User(
      idUser: idUser ?? this.idUser,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      matricula: matricula ?? this.matricula,
      curso: curso ?? this.curso,
    );
  }
}