class Tarefa {
  final String titulo;
  final String descricao;
  final String dataAlerta;
  final String horaAlerta;
  String? dataFinalizacao;
  int? responsavelId;
  late int idosoId;
  int? id;

  Tarefa(this.titulo, this.descricao, this.horaAlerta, this.dataAlerta);
}
