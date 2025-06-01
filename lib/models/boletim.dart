import 'disciplina.dart';

class Boletim {
  final String idBoletim;
  final String periodoLetivo; // Ex: "2023.1"
  final Set<Disciplina> disciplinas;
  final int? faltasNoSemestre;
  final double? a1;
  final double? a2;
  final double? exameFinal;
  final double? mediaSemestral;
  final double? mediaFinal;
  final String status;

  Boletim({
    required this.idBoletim,
    required this.periodoLetivo,
    required this.disciplinas,
    required this.faltasNoSemestre,
    this.a1,
    this.a2,
    this.exameFinal,
    this.mediaSemestral,
    this.mediaFinal,
    required this.status,
  });

  factory Boletim.fromMap(Map<String, dynamic> map) {
    return Boletim(
      idBoletim: map['idBoletim'],
      periodoLetivo: map['periodoLetivo'],
      disciplinas: (map['disciplinas'] as List<dynamic>)
          .map((disciplinaMap) => Disciplina.fromMap(disciplinaMap))
          .toSet(),
      faltasNoSemestre: map['faltasNoSemestre'],
      a1: map['a1']?.toDouble(),
      a2: map['a2']?.toDouble(),
      exameFinal: map['exameFinal']?.toDouble(),
      mediaSemestral: map['mediaSemestral']?.toDouble(),
      mediaFinal: map['mediaFinal']?.toDouble(),
      status: map['status'],
    );
  }

  double get frequenciaPercentual {
    const totalAulas = 60;
    return ((totalAulas - faltasNoSemestre!) / totalAulas) * 100;
  }

  Map<String, dynamic> toMap() {
    print('idBoletim: $idBoletim');
    print('periodoLetivo: $periodoLetivo');
    print('disciplinas: $disciplinas');
    print('faltasNoSemestre: $faltasNoSemestre');
    print('a1: $a1');
    print('a2: $a2');
    print('exameFinal: $exameFinal');
    print('mediaSemestral: $mediaSemestral');
    print('mediaFinal: $mediaFinal');
    print('status: $status');
    return {
      'idBoletim': idBoletim,
      'periodoLetivo': periodoLetivo,
      'disciplinas': disciplinas.map((disciplina) => disciplina.toMap()).toList(),
      'faltasNoSemestre': faltasNoSemestre,
      'a1': a1,
      'a2': a2,
      'exameFinal': exameFinal,
      'mediaSemestral': mediaSemestral,
      'mediaFinal': mediaFinal,
      'status': status,
    };
  }

  Boletim copyWith({
    String? idBoletim,
    String? periodoLetivo,
    Set<Disciplina>? disciplinas,
    int? faltasNoSemestre,
    double? a1,
    double? a2,
    double? exameFinal,
    double? mediaSemestral,
    double? mediaFinal,
    String? status,
  }) {
    return Boletim(
      idBoletim: idBoletim ?? this.idBoletim,
      periodoLetivo: periodoLetivo ?? this.periodoLetivo,
      disciplinas: disciplinas ?? this.disciplinas,
      faltasNoSemestre: faltasNoSemestre ?? this.faltasNoSemestre,
      a1: a1 ?? this.a1,
      a2: a2 ?? this.a2,
      exameFinal: exameFinal ?? this.exameFinal,
      mediaSemestral: mediaSemestral ?? this.mediaSemestral,
      mediaFinal: mediaFinal ?? this.mediaFinal,
      status: status ?? this.status,
    );
  }
}
