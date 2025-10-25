# flutter_solid

A new Flutter project.

## 開発環境 (mise)

このプロジェクトは mise で Flutter のバージョンを固定しています。

- 固定バージョン: `.mise.toml` の `[tools]` にて `flutter = "3.35.3"`
- インストール: プロジェクト直下で以下を実行

```bash
brew install mise               # 未導入なら
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc && exec zsh
mise install
```

- 動作確認

```bash
flutter --version
dart --version
```

### VS Code 連携

- 個人環境設定は Git から除外するため、`.vscode/settings.json` は `.gitignore` 済みです。
- VS Code で Flutter SDK の場所を明示したい場合の例（個人名を含まないチルダ表記）:

```json
{
  "mise.configureExtensionsUseSymLinks": true,
  "mise.configureExtensionsAutomaticallyIgnoreList": ["dart-code.flutter"],
  "dart.flutterSdkPath": "~/.local/share/mise/installs/flutter/3.35.3-stable",
  "dart.sdkPath": "~/.local/share/mise/installs/flutter/3.35.3-stable/bin/dart"
}
```

## Solid の仕組みと使い方

### どう動くか（仕組み）

- ソースオブトゥルースは `source/` フォルダです。あなたが書くのはここ。
- `solid` が `source/` を読み取り、実行に必要なボイラープレートを生成して `lib/` を作ります。
- `lib/` は生成物なので基本は編集しません（手で触らない）。
- 命名や構成は `source/` に合わせて保たれ、余計な `part` などの複雑さを増やしません。
- Flutter のビルドは（一般的に）`lib/` を入力に固定しているため、`lib/` を出力先にしています。
- Solid は単なるコード生成ではなく、既存コードを「最適化された形」にトランスパイルします。

### 使い方（CLI）

基本コマンド:

```bash
solid [options]
```

主なオプション:

- `-s, --source`  入力ディレクトリ（デフォルト: `source`）
- `-o, --output`  出力ディレクトリ（デフォルト: `lib`）
- `-w, --[no-]watch`  監視モード（変更を自動反映）
- `-c, --[no-]clean`  ビルドキャッシュを削除（次回はフルビルド）
- `-v, --[no-]verbose`  詳細ログ出力
- `-h, --[no-]help`  ヘルプの表示

例:

```bash
solid                    # 基本のトランスパイル
solid --watch            # 監視モード（変更で自動再生成）
solid --clean --verbose  # クリーン + 詳細ログ
```

開発フローのヒント:

- プロジェクトに Solid をセットアップしたら `source/` フォルダを作成します。
- 別ターミナルで `solid --watch` を起動し、変更時に自動で `lib/` が更新されるようにします。
- `lib/` は生成物のため手動編集は避けましょう。必要な変更は `source/` 側に行います。
