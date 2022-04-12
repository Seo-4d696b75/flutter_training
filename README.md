# hello_flutter

Flutter勉強のためのリポジトリ  
Android+Kotlinで実装されたインターン・アルバイト研修用課題[droid-training](https://github.com/yumemi/droid-training)
を移植しながら学習を進める

## task

[x] layoutの作成  
[x] 天気の表示とページの遷移  
[x] エラーハンドリングとdialog表示  
[x] JSONデータの扱い(freezed)  
[x] MVVMの導入(riverpod)  
[x] テストの追加  
[x] リソースデータの扱い(localizations,gen)  
[ ] 非同期処理

## setup

### [freezed](https://pub.dev/packages/freezed)

immutable,JSON形式でのシリアライズに利用  
以下のコマンドで`api/lib/**/*.freezed.dart`と`api/lib/**/*.g.dart`のファイルが自動生成される

```bash
cd api
dart pub run build_runner build
```

### [localization(l10n)](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

他言語対応可能な文字列リソースを扱う  
設定ファイル：`app/l10n.yaml`

以下のコマンドで`app/lib/l10n/*.dart`が生成される

```bash
cd app
flutter gen-l10n
```

**既知のエラー**  
localization(l10n)を導入したflutterプロジェクトで`flutter pub run ...`のコマンドが失敗する

```bash
Unhandled exception:
Bad state: Unable to generate package graph, no `path/to/project/app/.dart_tool/flutter_gen/pubspec.yaml` found.
...
pub finished with exit code 255
```

[Github - Bad state: Unable to generate package graph #2835](https://github.com/dart-lang/build/issues/2835#issuecomment-1076682884)

適当な内容のファイル`app/.dart_tool/flutter_gen/pubspec.yaml`を置くことで回避可能

```yaml
name: hoge
description: piyo
```

### [mockito](https://pub.dev/packages/mockito)

テストで依存をモックするのに利用  
以下のコマンドで`app/test/**/*.mocks.dart`が生成される

```bash
cd app
flutter pub run build_runner build
```

### [flutter_gen](https://pub.dev/packages/flutter_gen)

assetsファイルを安全に扱うためのライブラリ 以下のコマンドで`app/lib/gen/assets.gen.dart`が生成される

```bash
cd app
flutter pub run build_runner build
```