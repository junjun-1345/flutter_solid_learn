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
