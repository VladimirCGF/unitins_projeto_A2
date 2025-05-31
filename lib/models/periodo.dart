

import 'package:unitins_projeto/models/curso.dart';

class Periodo {
  final String idPeriodo;
  final String nome;
  final List<Curso> cursos;

  Periodo({
    required this.idPeriodo,
    required this.nome,
    this.cursos = const [],
  });

  factory Periodo.fromMap(Map<String, dynamic> map) {
    return Periodo(
      idPeriodo: map['idPeriodo'] ?? '',
      nome: map['nome'] ?? '',
      cursos: map['cursos'] != null
          ? (map['cursos'] as List).map((d) => Curso.fromMap(d)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPeriodo': idPeriodo,
      'nome': nome,
      'cursos': cursos.map((d) => d.toMap()).toList(),
    };
  }

  Periodo copyWith({
    String? idPeriodo,
    String? nome,
    List<Curso>? cursos,
  }) {
    return Periodo(
      idPeriodo: idPeriodo ?? this.idPeriodo,
      nome: nome ?? this.nome,
      cursos: cursos ?? this.cursos,
    );
  }
}
