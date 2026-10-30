import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/lista_compras_provider.dart';

class ProdutoTile extends StatelessWidget {
  const ProdutoTile({super.key, required this.produto});
  final Produto produto;

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir produto?'),
        content: Text('Deseja excluir “${produto.nome}” da lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmado == true && context.mounted) {
      context.read<ListaComprasProvider>().excluirProduto(produto.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: produto.comprado ? cores.primaryContainer : cores.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Row(
          children: [
            Checkbox(
              value: produto.comprado,
              semanticLabel:
                  '${produto.comprado ? 'Desmarcar' : 'Marcar'} ${produto.nome} como comprado',
              onChanged: (_) => context
                  .read<ListaComprasProvider>()
                  .alternarComprado(produto.id),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration: produto.comprado
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantidade: ${produto.quantidade} · ${produto.comprado ? 'Comprado' : 'Pendente'}',
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Excluir ${produto.nome}',
              onPressed: () => _confirmarExclusao(context),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
