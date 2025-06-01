

import 'package:unitins_projeto/models/disciplina.dart';

class Curso {
  final String idCurso;
  final String nome;
  final List<Disciplina> disciplinas;

  Curso({
    required this.idCurso,
    required this.nome,
    this.disciplinas = const [],
  });

  factory Curso.fromMap(Map<String, dynamic> map) {
    return Curso(
      idCurso: map['idCurso'] ?? '',
      nome: map['nome'] ?? '',
      disciplinas: map['disciplinas'] != null
          ? (map['disciplinas'] as List).map((d) => Disciplina.fromMap(d)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCurso': idCurso,
      'nome': nome,
      'disciplinas': disciplinas.map((d) => d.toMap()).toList(),
    };
  }

  Curso copyWith({
    String? idCurso,
    String? nome,
    List<Disciplina>? disciplinas,
  }) {
    return Curso(
      idCurso: idCurso ?? this.idCurso,
      nome: nome ?? this.nome,
      disciplinas: disciplinas ?? this.disciplinas,
    );
  }
}
