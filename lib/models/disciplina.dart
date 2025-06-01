class Disciplina {
  final String idDisciplina;
  final String codigo;
  final String nome;
  final String ch;
  final String periodo;
  final String idCurso;


  Disciplina({
    required this.idDisciplina,
    required this.codigo,
    required this.nome,
    required this.ch,
    required this.periodo,
    required this.idCurso,
  });

  factory Disciplina.fromMap(Map<String, dynamic> map) {
    return Disciplina(
      idDisciplina: map['idDisciplina'] ?? '',
      codigo: map['codigo'],
      nome: map['nome'],
      ch: map['ch'],
      periodo: map['periodo'],
      idCurso: map['idCurso'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idDisciplina': idDisciplina,
      'codigo': codigo,
      'nome': nome,
      'ch': ch,
      'periodo': periodo,
      'idCurso': idCurso,
    };
  }

  Disciplina copyWith({
    String? idDisciplina,
    String? codigo,
    String? nome,
    String? ch,
    String? periodo,
    String? idCurso,
  }) {
    return Disciplina(
      idDisciplina: idDisciplina ?? this.idDisciplina,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      ch: ch ?? this.ch,
      periodo: periodo ?? this.periodo,
      idCurso: idCurso ?? this.idCurso,
    );
  }
}
