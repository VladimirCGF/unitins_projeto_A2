import 'curso.dart';

class Boletim {
  final String idBoletim;
  final String periodoLetivo; // Ex: "2023.1"
  final Curso curso;
  final int faltasNoSemestre;
  final double? a1;
  final double? a2;
  final double? exameFinal;
  final double? mediaSemestral;
  final double? mediaFinal;
  final String status; // "Aprovado", "Reprovado", "Cursando"

  Boletim({
    required this.idBoletim,
    required this.periodoLetivo,
    required this.curso,
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
      curso: Curso.fromMap(map['curso']),
      faltasNoSemestre: map['faltasNoSemestre'],
      a1: map['a1']?.toDouble(),
      a2: map['a2']?.toDouble(),
      exameFinal: map['exameFinal']?.toDouble(),
      mediaSemestral: map['mediaSemestral']?.toDouble(),
      mediaFinal: map['mediaFinal']?.toDouble(),
      status: map['status'],
    );
  }

  // Calcula frequência percentual (considerando 60 aulas/semestre padrão)
  double get frequenciaPercentual {
    const totalAulas = 60;
    return ((totalAulas - faltasNoSemestre) / totalAulas) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': idBoletim,
      'periodoLetivo': periodoLetivo,
      'curso': curso.toMap(),
      'faltasNoSemestre': faltasNoSemestre,
      'a1': a1,
      'a2': a2,
      'exameFinal': exameFinal,
      'mediaSemestral': mediaSemestral,
      'mediaFinal': mediaFinal,
      'status': status,
    };
  }
}