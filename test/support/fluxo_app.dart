import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_compras_provider/main.dart' as app;

// O mesmo roteiro roda como teste de widgets e no emulador Android.
void registrarTestesFluxo() {
  Future<void> tocar(WidgetTester tester, Finder alvo) async {
    await tester.ensureVisible(alvo);
    await tester.tap(alvo);
    await tester.pumpAndSettle();
  }

  Future<void> cadastrar(
    WidgetTester tester,
    String nome,
    String quantidade,
  ) async {
    await tocar(tester, find.byType(FloatingActionButton));
    await tester.enterText(find.byType(TextFormField).at(0), nome);
    await tester.enterText(find.byType(TextFormField).at(1), quantidade);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tocar(tester, find.widgetWithText(FilledButton, 'Adicionar produto'));
  }

  void conferirTotal(String titulo, String valor) {
    final cartao = find.ancestor(
      of: find.text(titulo),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: cartao, matching: find.text(valor)),
      findsOneWidget,
    );
  }

  testWidgets('roteiro: três cadastros, compra, resumo, remoção e navegação', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Sua lista começa aqui!'), findsOneWidget);
    await cadastrar(tester, 'Arroz', '3');
    await cadastrar(tester, 'Feijão', '2');
    await cadastrar(tester, 'Leite', '1');
    await tocar(tester, find.byType(Checkbox).first);
    await tocar(tester, find.text('Ver resumo'));
    conferirTotal('Produtos cadastrados', '3');
    conferirTotal('Produtos comprados', '1');
    conferirTotal('Produtos pendentes', '2');

    await tocar(tester, find.text('Remover produtos comprados'));
    await tocar(tester, find.text('Cancelar'));
    conferirTotal('Produtos cadastrados', '3');
    await tocar(tester, find.text('Remover produtos comprados'));
    await tocar(tester, find.text('Remover'));
    conferirTotal('Produtos cadastrados', '2');
    conferirTotal('Produtos comprados', '0');
    conferirTotal('Produtos pendentes', '2');
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Remover produtos comprados'),
          )
          .onPressed,
      isNull,
    );

    await tocar(tester, find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Arroz'), findsNothing);
    expect(find.text('Feijão'), findsOneWidget);
    expect(find.text('Leite'), findsOneWidget);
    await tocar(tester, find.text('Ver resumo'));
    conferirTotal('Produtos cadastrados', '2');
    await tocar(tester, find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('0 de 2 produtos comprados'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'filtros, marcação e exclusão individual por id com confirmação',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await cadastrar(tester, 'Arroz', '1');
      await cadastrar(tester, 'Arroz', '2');
      await tocar(tester, find.byType(Checkbox).first);
      await tocar(tester, find.text('Comprados'));
      expect(find.text('Quantidade: 1 · Comprado'), findsOneWidget);
      expect(find.text('Quantidade: 2 · Pendente'), findsNothing);
      expect(
        tester.widget<Text>(find.text('Arroz')).style?.decoration,
        TextDecoration.lineThrough,
      );
      await tocar(tester, find.byTooltip('Excluir Arroz'));
      await tocar(tester, find.text('Cancelar'));
      expect(find.text('Arroz'), findsOneWidget);
      await tocar(tester, find.byTooltip('Excluir Arroz'));
      await tocar(tester, find.text('Excluir'));
      expect(find.text('Nenhum produto comprado.'), findsOneWidget);
      await tocar(tester, find.text('Pendentes'));
      expect(find.text('Quantidade: 2 · Pendente'), findsOneWidget);
      await tocar(tester, find.byType(Checkbox));
      expect(find.text('Nenhum produto pendente.'), findsOneWidget);
      await tocar(tester, find.text('Todos'));
      expect(find.text('Quantidade: 2 · Comprado'), findsOneWidget);
      await tocar(tester, find.byType(Checkbox));
      expect(find.text('Quantidade: 2 · Pendente'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'cadastro rejeita vazio, espaços, zero, negativos, decimais e texto',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tocar(tester, find.byType(FloatingActionButton));
      await tocar(
        tester,
        find.widgetWithText(FilledButton, 'Adicionar produto'),
      );
      expect(find.text('Informe o nome do produto.'), findsOneWidget);
      expect(
        find.text('Informe um número inteiro maior que zero.'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextFormField).at(0), '   ');
      for (final valor in ['', '0', '-1', '1.5', '1,5', 'abc']) {
        await tester.enterText(find.byType(TextFormField).at(1), valor);
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tocar(
          tester,
          find.widgetWithText(FilledButton, 'Adicionar produto'),
        );
        expect(find.text('Informe o nome do produto.'), findsOneWidget);
        expect(
          find.text('Informe um número inteiro maior que zero.'),
          findsOneWidget,
        );
      }
      await tester.enterText(find.byType(TextFormField).at(0), '  Café  ');
      await tester.enterText(find.byType(TextFormField).at(1), '4');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tocar(
        tester,
        find.widgetWithText(FilledButton, 'Adicionar produto'),
      );
      expect(find.text('Café'), findsOneWidget);
      expect(find.text('Quantidade: 4 · Pendente'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
