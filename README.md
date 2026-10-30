# Lista de compras com Provider

Aplicativo acadêmico feito com **Flutter, Dart e Provider**. Permite cadastrar produtos, marcar compras, excluir itens e consultar um resumo.

**Os dados ficam somente na memória.** Eles permanecem ao trocar de tela, mas são perdidos ao reiniciar o aplicativo. Não há banco de dados nem login.

## 1. Abrir e executar no Android Studio

É necessário ter Flutter, os plugins Flutter/Dart do Android Studio e um emulador Android. O projeto foi testado com Flutter **3.47.2** e Dart **3.13.2**.

Para baixar o projeto em outro computador, use **Code > Download ZIP** no GitHub e extraia a pasta, ou execute:

```powershell
git clone https://github.com/marcelobrandaoo/lista-na-mao.git
```

1. No Android Studio, clique em **Open** ou **File > Open**.
2. Abra a pasta do projeto que contém o arquivo **`pubspec.yaml`**. Neste computador, ela se chama `Lista de compra`. Selecione essa pasta inteira, não apenas a subpasta `android`.
3. Se o programa pedir o SDK Flutter, selecione a pasta onde o Flutter está instalado.
4. Abra o **Terminal** do Android Studio e execute:

   ```powershell
   flutter pub get
   ```

5. Abra **Tools > Device Manager** e inicie o emulador pelo botão ▶. Neste computador, o **Pixel_4 já está criado**. Aguarde aparecer a tela inicial do Android.
6. Selecione esse emulador na barra de dispositivos do Android Studio.
7. Abra **`lib/main.dart`** e clique em **Run ▶**.

A primeira execução pode demorar e precisar de internet para baixar as dependências. Depois de instalado, o aplicativo funciona sem conexão.

### Alternativa pelo terminal

Com o emulador aberto, execute na pasta que contém `pubspec.yaml`:

```powershell
flutter pub get
flutter devices
flutter run -d emulator-5554
```

Se `flutter devices` mostrar outro identificador para o Android, substitua `emulator-5554` por ele. Para encerrar a execução pelo terminal, pressione `q`.

### Executar no VS Code

Abra a mesma pasta do projeto, instale as extensões **Flutter** e **Dart**, execute `flutter pub get` no terminal, selecione o emulador na barra inferior e pressione **F5**.

## 2. Como usar o aplicativo

| Ação | Como fazer |
| --- | --- |
| Cadastrar | Toque em **Adicionar produto**, preencha nome e quantidade e confirme. |
| Marcar ou desmarcar uma compra | Toque na caixa de seleção ao lado do produto. |
| Excluir um produto | Toque na lixeira e confirme **Excluir**. |
| Filtrar a lista | Escolha **Todos**, **Pendentes** ou **Comprados**. |
| Consultar os totais | Toque em **Ver resumo**. |
| Limpar os comprados | No resumo, toque em **Remover produtos comprados** e confirme **Remover**. |
| Voltar à lista | Use a seta de voltar. |

O nome é obrigatório e a quantidade deve ser um número inteiro maior que zero. Produtos com nomes iguais são permitidos e podem ser excluídos separadamente.

**Os totais contam produtos cadastrados, não unidades.** Por exemplo: Arroz com quantidade 3 conta como **um** produto.

## 3. Roteiro para testar

Comece com a lista vazia. Se necessário, encerre o aplicativo e execute novamente.

1. Cadastre **Arroz (3)**, **Feijão (2)** e **Leite (1)**.
2. Marque **Arroz** como comprado. O nome deve ficar riscado e a situação deve mostrar **Comprado**.
3. Toque em **Ver resumo**. O resultado esperado é **3 cadastrados, 1 comprado e 2 pendentes**.
4. Toque em **Remover produtos comprados**. Primeiro teste **Cancelar**; depois repita e confirme **Remover**.
5. Volte à lista. Devem restar somente **Feijão e Leite**, ambos pendentes.
6. Abra o cadastro, volte sem salvar e consulte o resumo novamente. Os dois produtos devem continuar na lista, com totais **2 cadastrados, 0 comprados e 2 pendentes**.
7. Teste os três filtros. **Comprados** deve mostrar uma mensagem de lista sem resultados. O resumo deve contar todos os produtos, qualquer que seja o filtro escolhido.
8. Tente salvar com nome vazio ou só espaços. Teste quantidade vazia, `0`, `-1`, `1.5`, `1,5` e `abc` (cole os valores se o teclado não permitir digitá-los). O formulário deve exibir erros e impedir o cadastro.
9. Cadastre dois produtos de mesmo nome, com quantidades diferentes. Exclua um deles e confira que o outro permanece. Teste também cancelar a exclusão e marcar/desmarcar um item com filtro ativo.
10. Confira que o botão de remover comprados fica desabilitado quando não há comprados. Verifique a rolagem, o formulário com teclado aberto e o botão de voltar do Android.

## 4. Onde está o código

```text
lib/
  main.dart                             → início do app, Provider e rotas
  models/produto.dart                    → dados de um produto
  providers/lista_compras_provider.dart  → lista compartilhada e suas operações
  screens/lista_compras_screen.dart      → lista e filtros
  screens/cadastro_produto_screen.dart   → formulário de cadastro
  screens/resumo_screen.dart             → totais e remoção dos comprados
  widgets/produto_tile.dart              → exibição de cada produto

test/                                   → testes do Provider e das telas
integration_test/                       → testes executados no Android
```

O Provider é criado uma única vez, acima do `MaterialApp`, e é compartilhado pelas três telas. As respostas sobre seu funcionamento estão em [RESPOSTAS_ENTREGA.md](RESPOSTAS_ENTREGA.md).

## 5. Verificações automáticas

Na raiz do projeto:

```powershell
dart format lib test integration_test
flutter analyze
flutter test
```

Para testar as telas no emulador aberto:

```powershell
flutter test integration_test/app_test.dart -d emulator-5554
```

**Resultados já obtidos:** código formatado, análise sem problemas, **11 testes locais aprovados** e **3 testes aprovados no Pixel_4 com Android 14**. O aplicativo também foi instalado e aberto nesse emulador.

O roteiro manual da seção 3 permite conferir teclado, rolagem e navegação pelo Android.

## Se o emulador travar

Feche o emulador e use **Cold Boot** no **Device Manager**. Aguarde o Android iniciar e execute o aplicativo novamente. Esse procedimento preserva os dados da máquina virtual.
