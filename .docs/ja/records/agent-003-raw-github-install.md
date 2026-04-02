# Decision Record: agent-003-raw-github-install

## メタデータ
- Status: Accepted
- Date: 2026-04-03
- Scope: リモートインストーラー配信エンドポイント

## 背景とリサーチ
要求された導入UXは `installer.sh | bash` です。
失敗しない導線のためには、正しいホスト選定と安定URL戦略が必要です。

リサーチ結果:
- GitHubのRaw配信ホストは `raw.githubusercontent.com` です。
- この環境で `raw.githubusercontent.com` は名前解決でき、`raw.gitusercontent.com` は名前解決できません。
- GitHub公式ドキュメントは、安定参照が必要な場合にコミット固定のパーマリンク利用を推奨しています。

参照:
- https://raw.githubusercontent.com/github/docs/main/README.md
- https://docs.github.com/en/repositories/working-with-files/using-files/getting-permanent-links-to-files
- ローカル検証: `getent hosts raw.githubusercontent.com` と `getent hosts raw.gitusercontent.com`

## 決定
インストーラー配信のホストは `raw.githubusercontent.com` を採用し、`curl | bash` の導入コマンドを提供します。

推奨コマンドパターン:
- `curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/<ref>/installer.sh | bash`

`<ref>` は既定で安定ブランチまたはタグを使用し、再現性が必要な場合はコミット固定を許可します。

## 決定契約
### 不変条件
- インストーラー配信ホストは `raw.githubusercontent.com` を使用する。
- コマンドはHTTP/ネットワークエラーで失敗する設定（`-f`）を含む。
- URL構造はリポジトリ内の `installer.sh` パスに直接対応する。

### 非目標
- `raw.gitusercontent.com` は使用しない。
- 追跡困難な短縮URLや不透明なリダイレクトに依存しない。
- 未実装の検証方式を実装済みとして説明しない。

### 受け入れ基準
- 公開したワンライナーでクリーンシェルから取得・実行できる。
- エンドポイントURLがそのままコピー可能で、owner/repo/refプレースホルダを明記している。
- `<ref>` 固定による決定論的インストール方法が文書化されている。

### 失敗条件
- ホストが名前解決できない、またはRawではないHTMLを返す。
- ブランチ変動で不安定なのに固定方法が案内されていない。
- 無効ドメインやタイポを案内文に含める。

## 影響
Positive:
- 要求された導入UXを満たせます。
- 一般的なシェル環境とCI初期化フローで利用できます。

Trade-offs:
- `curl | bash` はサプライチェーンリスクがあるため、将来的に固定参照・レビュー・チェックサム/署名の補強が必要です。
