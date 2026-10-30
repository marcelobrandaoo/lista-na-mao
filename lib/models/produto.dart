/// Cada cadastro tem identidade própria, mesmo quando os nomes se repetem.
class Produto {
  const Produto({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });

  final int id;
  final String nome;
  final int quantidade;
  final bool comprado;

  Produto copyWith({String? nome, int? quantidade, bool? comprado}) {
    return Produto(
      id: id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
    );
  }
}
