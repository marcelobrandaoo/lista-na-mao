import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lista_compras_provider.dart';
import '../widgets/produto_tile.dart';

enum FiltroProdutos { todos, pendentes, comprados }

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  FiltroProdutos _filtro = FiltroProdutos.todos;

  @override
  Widget build(BuildContext context) {
    final lista = context.watch<ListaComprasProvider>();
    final cores = Theme.of(context).colorScheme;
    // Visão derivada do Provider; o filtro é o único estado local da tela.
    final visiveis = lista.produtos
        .where(
          (produto) => switch (_filtro) {
            FiltroProdutos.todos => true,
            FiltroProdutos.pendentes => !produto.comprado,
            FiltroProdutos.comprados => produto.comprado,
          },
        )
        .toList();
    final progresso = lista.totalProdutos == 0
        ? 0.0
        : lista.totalComprados / lista.totalProdutos;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de compras')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/cadastro'),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar produto'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          color: cores.primaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  color: cores.onPrimaryContainer,
                                  size: 32,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tudo pronto para as compras?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${lista.totalComprados} de ${lista.totalProdutos} produtos comprados',
                                ),
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: progresso,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  semanticsLabel: 'Progresso das compras',
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/resumo'),
                                  icon: const Icon(Icons.bar_chart_rounded),
                                  label: const Text('Ver resumo'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Seus produtos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<FiltroProdutos>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                              value: FiltroProdutos.todos,
                              label: Text('Todos'),
                            ),
                            ButtonSegment(
                              value: FiltroProdutos.pendentes,
                              label: Text('Pendentes'),
                            ),
                            ButtonSegment(
                              value: FiltroProdutos.comprados,
                              label: Text('Comprados'),
                            ),
                          ],
                          selected: {_filtro},
                          onSelectionChanged: (selecionados) =>
                              setState(() => _filtro = selecionados.single),
                        ),
                      ],
                    ),
                  ),
                ),
                if (visiveis.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 28, 28, 120),
                      child: Column(
                        children: [
                          Icon(
                            Icons.playlist_add_check_rounded,
                            size: 64,
                            color: cores.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lista.totalProdutos == 0
                                ? 'Sua lista começa aqui!'
                                : _filtro == FiltroProdutos.pendentes
                                ? 'Nenhum produto pendente.'
                                : 'Nenhum produto comprado.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lista.totalProdutos == 0
                                ? 'Toque em “Adicionar produto” para preparar sua próxima compra.'
                                : 'Escolha outro filtro para ver os demais produtos.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                    sliver: SliverList.builder(
                      itemCount: visiveis.length,
                      itemBuilder: (_, indice) => ProdutoTile(
                        key: ValueKey(visiveis[indice].id),
                        produto: visiveis[indice],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
