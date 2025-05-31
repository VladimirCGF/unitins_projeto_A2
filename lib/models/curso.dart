class Curso {
  final String idCurso;
  final String codigo;
  final String nome;
  final String ch; // Carga horária
  final String periodo;


  Curso({
    required this.idCurso,
    required this.codigo,
    required this.nome,
    required this.ch,
    required this.periodo,
  });

  factory Curso.fromMap(Map<String, dynamic> map) {
    return Curso(
      idCurso: map['idCurso'] ?? '',
      codigo: map['codigo'],
      nome: map['nome'],
      ch: map['ch'],
      periodo: map['periodo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCurso': idCurso,
      'codigo': codigo,
      'nome': nome,
      'ch': ch,
      'periodo': periodo,
    };
  }

  Curso copyWith({
    String? idCurso,
    String? codigo,
    String? nome,
    String? ch,
    String? periodo,
  }) {
    return Curso(
      idCurso: idCurso ?? this.idCurso,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      ch: ch ?? this.ch,
      periodo: periodo ?? this.periodo,
    );
  }
}
