# Respostas para a entrega

1. **Qual classe representa o estado compartilhado?**

   `ListaComprasProvider`, em `lib/providers/lista_compras_provider.dart`. Ela guarda a lista e controla a adição, a exclusão, a marcação e a remoção dos produtos comprados. Também calcula os totais.

2. **Onde o Provider foi disponibilizado e por que as três telas podem acessá-lo?**

   Em `main()`, no arquivo `lib/main.dart`. O `ChangeNotifierProvider` fica acima do `MaterialApp`, por isso as três telas acessam a mesma instância e mantêm os dados ao navegar.

3. **Qual é a função de `notifyListeners()`?**

   Avisar que os dados mudaram. Assim, as telas que acompanham o Provider atualizam a lista e os totais automaticamente. Ele é chamado após uma alteração efetiva.

4. **Onde foram utilizados `context.watch` e `context.read`?**

   `context.watch` é usado na lista e no resumo para mostrar os dados atualizados. `context.read` é usado nas ações de adicionar, marcar/desmarcar, excluir e remover comprados. O `setState` altera apenas o filtro selecionado na tela.
