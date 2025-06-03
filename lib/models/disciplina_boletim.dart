class DisciplinaBoletim {
  final String idDisciplinaBoletim;
  final String idDisciplina;
  final String idUser;
  final String status;
  final double? a1;
  final double? a2;
  final double? exameFinal;
  final double? mediaSemestral;
  final double? mediaFinal;
  final int? faltasNoSemestre;

  DisciplinaBoletim({
    required this.idDisciplinaBoletim,
    required this.idDisciplina,
    required this.idUser,
    required this.status,
    required this.a1,
    required this.a2,
    required this.exameFinal,
    required this.mediaSemestral,
    required this.mediaFinal,
    required this.faltasNoSemestre,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDisciplinaBoletim': idDisciplinaBoletim,
      'idDisciplina': idDisciplina,
      'idUser': idUser,
      'status': status,
      'a1': a1,
      'a2': a2,
      'exameFinal': exameFinal,
      'mediaSemestral': mediaSemestral,
      'mediaFinal': mediaFinal,
      'faltasNoSemestre': faltasNoSemestre,
    };
  }

  factory DisciplinaBoletim.fromMap(Map<String, dynamic> map) {
    return DisciplinaBoletim(
      idDisciplinaBoletim: map['idDisciplinaBoletim'],
      idDisciplina: map['idDisciplina'],
      idUser: map['idUser'],
      status: map['status'],
      a1: map['a1']?.toDouble(),
      a2: map['a2']?.toDouble(),
      exameFinal: map['exameFinal']?.toDouble(),
      mediaSemestral: map['mediaSemestral']?.toDouble(),
      mediaFinal: map['mediaFinal']?.toDouble(),
      faltasNoSemestre: map['faltasNoSemestre'],
    );
  }

  DisciplinaBoletim copyWith({
    String? idDisciplinaBoletim,
    String? idDisciplina,
    String? idUser,
    String? status,
    double? a1,
    double? a2,
    double? exameFinal,
    double? mediaSemestral,
    double? mediaFinal,
    int? faltasNoSemestre,
  }) {
    return DisciplinaBoletim(
      idDisciplinaBoletim: idDisciplinaBoletim ?? this.idDisciplinaBoletim,
      idDisciplina: idDisciplina ?? this.idDisciplina,
      idUser: idUser ?? this.idUser,
      status: status ?? this.status,
      a1: a1 ?? this.a1,
      a2: a2 ?? this.a2,
      exameFinal: exameFinal ?? this.exameFinal,
      mediaSemestral: mediaSemestral ?? this.mediaSemestral,
      mediaFinal: mediaFinal ?? this.mediaFinal,
      faltasNoSemestre: faltasNoSemestre ?? this.faltasNoSemestre,
    );
  }
}
