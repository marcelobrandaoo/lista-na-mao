import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lista_compras_provider.dart';

class ResumoScreen extends StatelessWidget {
  const ResumoScreen({super.key});

  Future<void> _confirmarRemocao(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover produtos comprados?'),
        content: const Text('Os produtos pendentes permanecerão na lista.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmado == true && context.mounted) {
      context.read<ListaComprasProvider>().removerComprados();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lista = context.watch<ListaComprasProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo da lista')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Sua compra em números',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cada produto cadastrado conta como um item, independentemente da quantidade.',
                ),
                const SizedBox(height: 24),
                _CartaoTotal(
                  titulo: 'Produtos cadastrados',
                  total: lista.totalProdutos,
                  icone: Icons.shopping_basket_outlined,
                ),
                _CartaoTotal(
                  titulo: 'Produtos comprados',
                  total: lista.totalComprados,
                  icone: Icons.check_circle_outline,
                ),
                _CartaoTotal(
                  titulo: 'Produtos pendentes',
                  total: lista.totalPendentes,
                  icone: Icons.schedule_outlined,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: lista.totalComprados == 0
                      ? null
                      : () => _confirmarRemocao(context),
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: const Text('Remover produtos comprados'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A lista fica disponível enquanto o aplicativo está em execução.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartaoTotal extends StatelessWidget {
  const _CartaoTotal({
    required this.titulo,
    required this.total,
    required this.icone,
  });
  final String titulo;
  final int total;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icone, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(child: Text(titulo)),
            const SizedBox(width: 12),
            Text('$total', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
