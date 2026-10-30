import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/lista_compras_provider.dart';
import 'screens/cadastro_produto_screen.dart';
import 'screens/lista_compras_screen.dart';
import 'screens/resumo_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ListaComprasProvider(),
      child: const ListaComprasApp(),
    ),
  );
}

class ListaComprasApp extends StatelessWidget {
  const ListaComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = ColorScheme.fromSeed(seedColor: const Color(0xFF216744));
    return MaterialApp(
      title: 'Lista de compras',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: cores,
        scaffoldBackgroundColor: const Color(0xFFF6F8F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F8F4),
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cores.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 52),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
      routes: {
        '/': (_) => const ListaComprasScreen(),
        '/cadastro': (_) => const CadastroProdutoScreen(),
        '/resumo': (_) => const ResumoScreen(),
      },
    );
  }
}
