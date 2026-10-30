import 'package:flutter_test/flutter_test.dart';
import 'package:lista_compras_provider/providers/lista_compras_provider.dart';

void main() {
  late ListaComprasProvider lista;

  setUp(() => lista = ListaComprasProvider());
  tearDown(() => lista.dispose());

  void conferirTotais(int total, int comprados, int pendentes) {
    expect(lista.totalProdutos, total);
    expect(lista.totalComprados, comprados);
    expect(lista.totalPendentes, pendentes);
    expect(lista.totalComprados + lista.totalPendentes, lista.totalProdutos);
  }

  test('adiciona nome limpo e situação inicial pendente', () {
    lista.adicionarProduto(nome: '  Arroz  ', quantidade: 3);
    final produto = lista.produtos.single;
    expect(produto.nome, 'Arroz');
    expect(produto.quantidade, 3);
    expect(produto.comprado, isFalse);
    conferirTotais(1, 0, 1);
  });

  test('conta cadastros independentemente da quantidade de unidades', () {
    lista.adicionarProduto(nome: 'Arroz', quantidade: 3);
    lista.adicionarProduto(nome: 'Leite', quantidade: 12);
    conferirTotais(2, 0, 2);
  });

  test('marca e desmarca por id, preservando o produto anterior imutável', () {
    lista.adicionarProduto(nome: 'Arroz', quantidade: 3);
    final anterior = lista.produtos.single;
    lista.alternarComprado(anterior.id);
    expect(anterior.comprado, isFalse);
    expect(lista.produtos.single.comprado, isTrue);
    expect(lista.produtos.single.id, anterior.id);
    conferirTotais(1, 1, 0);
    lista.alternarComprado(anterior.id);
    expect(lista.produtos.single.comprado, isFalse);
    conferirTotais(1, 0, 1);
  });

  test(
    'exclui pelo id correto mesmo com nomes repetidos e não reutiliza ids',
    () {
      lista.adicionarProduto(nome: 'Arroz', quantidade: 1);
      lista.adicionarProduto(nome: 'Arroz', quantidade: 2);
      final primeiro = lista.produtos.first;
      final segundo = lista.produtos.last;
      expect(primeiro.id, isNot(segundo.id));
      lista.excluirProduto(primeiro.id);
      expect(lista.produtos.single.id, segundo.id);
      expect(lista.produtos.single.quantidade, 2);
      lista.adicionarProduto(nome: 'Arroz', quantidade: 3);
      expect(lista.produtos.last.id, isNot(isIn([primeiro.id, segundo.id])));
      conferirTotais(2, 0, 2);
    },
  );

  test(
    'remove somente comprados e mantém totais consistentes nas operações',
    () {
      for (final nome in ['Arroz', 'Feijão', 'Leite']) {
        lista.adicionarProduto(nome: nome, quantidade: 3);
      }
      final idComprado = lista.produtos[1].id;
      lista.alternarComprado(idComprado);
      conferirTotais(3, 1, 2);
      lista.removerComprados();
      expect(lista.produtos.map((p) => p.nome), ['Arroz', 'Leite']);
      conferirTotais(2, 0, 2);
      lista.excluirProduto(lista.produtos.first.id);
      conferirTotais(1, 0, 1);
      lista.alternarComprado(lista.produtos.single.id);
      lista.removerComprados();
      conferirTotais(0, 0, 0);
    },
  );

  test(
    'notifica uma vez por alteração efetiva e não notifica operações vazias',
    () {
      var notificacoes = 0;
      lista.addListener(() => notificacoes++);
      lista.excluirProduto(-1);
      lista.alternarComprado(-1);
      lista.removerComprados();
      expect(notificacoes, 0);
      lista.adicionarProduto(nome: 'Arroz', quantidade: 1);
      expect(notificacoes, 1);
      final id = lista.produtos.single.id;
      lista.alternarComprado(id);
      expect(notificacoes, 2);
      lista.alternarComprado(id);
      expect(notificacoes, 3);
      lista.removerComprados();
      expect(notificacoes, 3);
      lista.excluirProduto(id);
      expect(notificacoes, 4);
      lista.adicionarProduto(nome: 'Leite', quantidade: 1);
      lista.alternarComprado(lista.produtos.single.id);
      lista.removerComprados();
      expect(notificacoes, 7);
    },
  );

  test('rejeita argumentos inválidos sem alterar o estado nem notificar', () {
    var notificacoes = 0;
    lista.addListener(() => notificacoes++);
    for (final nome in ['', '   ']) {
      expect(
        () => lista.adicionarProduto(nome: nome, quantidade: 1),
        throwsArgumentError,
      );
    }
    for (final quantidade in [0, -1]) {
      expect(
        () => lista.adicionarProduto(nome: 'Arroz', quantidade: quantidade),
        throwsArgumentError,
      );
    }
    conferirTotais(0, 0, 0);
    expect(notificacoes, 0);
  });

  test('a coleção pública não permite alterar a lista', () {
    lista.adicionarProduto(nome: 'Arroz', quantidade: 1);
    expect(() => lista.produtos.clear(), throwsUnsupportedError);
    expect(() => lista.produtos.removeAt(0), throwsUnsupportedError);
    conferirTotais(1, 0, 1);
  });
}
