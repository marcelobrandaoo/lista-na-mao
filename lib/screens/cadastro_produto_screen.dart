import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lista_compras_provider.dart';

class CadastroProdutoScreen extends StatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ListaComprasProvider>().adicionarProduto(
      nome: _nomeController.text,
      quantidade: int.parse(_quantidadeController.text.trim()),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar produto')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'O que está faltando?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Adicione um produto por vez. Você pode marcar como comprado depois.',
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome do produto',
                      hintText: 'Ex.: Arroz',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: (valor) => valor == null || valor.trim().isEmpty
                        ? 'Informe o nome do produto.'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _quantidadeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _salvar(),
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      hintText: 'Ex.: 3',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (valor) {
                      final quantidade = int.tryParse(valor?.trim() ?? '');
                      if (quantidade == null || quantidade <= 0) {
                        return 'Informe um número inteiro maior que zero.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar produto'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
