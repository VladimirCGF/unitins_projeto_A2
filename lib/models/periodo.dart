

import 'package:unitins_projeto/models/disciplina.dart';

class Periodo {
  final String idPeriodo;
  final String nome;
  final List<Disciplina> disciplinas;

  Periodo({
    required this.idPeriodo,
    required this.nome,
    this.disciplinas = const [],
  });

  factory Periodo.fromMap(Map<String, dynamic> map) {
    return Periodo(
      idPeriodo: map['idPeriodo'] ?? '',
      nome: map['nome'] ?? '',
      disciplinas: map['disciplinas'] != null
          ? (map['disciplinas'] as List).map((d) => Disciplina.fromMap(d)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPeriodo': idPeriodo,
      'nome': nome,
      'disciplinas': disciplinas.map((d) => d.toMap()).toList(),
    };
  }

  Periodo copyWith({
    String? idPeriodo,
    String? nome,
    List<Disciplina>? disciplinas,
  }) {
    return Periodo(
      idPeriodo: idPeriodo ?? this.idPeriodo,
      nome: nome ?? this.nome,
      disciplinas: disciplinas ?? this.disciplinas,
    );
  }
}
