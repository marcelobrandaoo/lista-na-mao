import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/produto.dart';

/// Única fonte de dados das telas. Tudo existe somente durante a execução.
class ListaComprasProvider extends ChangeNotifier {
  final List<Produto> _produtos = [];
  static int _proximoId = 1;

  UnmodifiableListView<Produto> get produtos => UnmodifiableListView(_produtos);

  // A quantidade de unidades não interfere na contagem de cadastros.
  int get totalProdutos => _produtos.length;
  int get totalComprados => _produtos.where((p) => p.comprado).length;
  int get totalPendentes => totalProdutos - totalComprados;

  void adicionarProduto({required String nome, required int quantidade}) {
    final nomeLimpo = nome.trim();
    if (nomeLimpo.isEmpty) {
      throw ArgumentError.value(nome, 'nome', 'Informe o nome do produto.');
    }
    if (quantidade <= 0) {
      throw ArgumentError.value(
        quantidade,
        'quantidade',
        'A quantidade deve ser maior que zero.',
      );
    }
    _produtos.add(
      Produto(id: _proximoId++, nome: nomeLimpo, quantidade: quantidade),
    );
    notifyListeners();
  }

  void excluirProduto(int id) {
    final tamanhoAnterior = _produtos.length;
    _produtos.removeWhere((p) => p.id == id);
    if (_produtos.length != tamanhoAnterior) notifyListeners();
  }

  void alternarComprado(int id) {
    final indice = _produtos.indexWhere((p) => p.id == id);
    if (indice == -1) return;
    final produto = _produtos[indice];
    _produtos[indice] = produto.copyWith(comprado: !produto.comprado);
    notifyListeners();
  }

  void removerComprados() {
    final tamanhoAnterior = _produtos.length;
    _produtos.removeWhere((p) => p.comprado);
    if (_produtos.length != tamanhoAnterior) notifyListeners();
  }
}
