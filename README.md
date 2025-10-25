# flutter_solid

solid触ってみた

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


## Solid の仕組みと使い方

### どう動くか（仕組み）

- ルート直下`source/` フォルダに記述
- `solid` が `source/` を読み取り、実行に必要なボイラープレートを生成して `lib/` を作ります。

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

## サンプル画面とルーティング

- エントリ: `lib/main.dart:1`（生成物） / `source/main.dart:1`（ソース）
- ルート一覧（タイトルは `MainPage` のリストから遷移）
  - `/state` → カウンターと Computed の例
  - `/effect` → Effect の例
  - `/query` → Query（非同期）の例
  - `/environment` → 環境注入（SolidProvider）の例
  - `/stream` → Stream + Source の例
