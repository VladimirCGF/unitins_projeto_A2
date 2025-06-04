import 'disciplina_boletim.dart';

class User {
  final String idUser;
  final String nome;
  final String cpf;
  final String email;
  final String matricula;
  final String idCurso;
  final List<DisciplinaBoletim> boletim;

  User({
    required this.idUser,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.matricula,
    required this.idCurso,
    this.boletim = const [],
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'] ?? '',
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      email: map['email'] ?? '',
      matricula: map['matricula'] ?? '',
      idCurso: map['idCurso'] ?? '',
      boletim: (map['boletim'] as List<dynamic>?)
          ?.map((e) => DisciplinaBoletim.fromMap(e))
          .toList() ??
          [],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'matricula': matricula,
      'idCurso': idCurso,
      'boletim': boletim.map((e) => e.toMap()).toList(),
    };
  }

  User copyWith({
    String? idUser,
    String? nome,
    String? cpf,
    String? email,
    String? matricula,
    String? idCurso,
    List<DisciplinaBoletim>? boletim,
  }) {
    return User(
      idUser: idUser ?? this.idUser,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      matricula: matricula ?? this.matricula,
      idCurso: idCurso ?? this.idCurso,
      boletim: boletim ?? this.boletim,
    );
  }
}
