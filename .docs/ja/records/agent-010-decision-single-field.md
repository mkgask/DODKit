# Decision Record: agent-010-decision-single-field

## Metadata
- Created At: 2026-06-28
- Scope: DECISIONS.yml の title/reason 分割を decision 単一フィールドに置き換える

## Notes
- このファイルは append-only の議論履歴です。
- ここに可変の追跡項目（status、残作業、未完アクション）を書いてはいけません。
- 未解決事項のバックログをここに置いてはいけません。確認が必要な場合はチャットで解消し、解消した事実だけを追記してください。
- 実装拘束条件になった事実は DECISIONS.yml に昇格してください。
- 各 entry は必要最小限の短さで記述してください。
- 根拠や詳細な昇格メタデータは任意です。明確性を損なわない限り省略できます。

Append rules:
- 追記は EOF のみ。過去の section を編集しない。
- status tracking や remaining-work items を書かない。

## Entry List

### Entry 0001 (2026-06-28)
- Why now: 現行の title/reason 分割では、AI が更新した際に title が短い見出しへ縮退し、reason が拘束理由ではなく補足説明へ流れる傾向があり、意味の結び付きと一覧性が崩れやすい。
- Findings / trade-offs: 関連する既存議論、特に agent-005-lightweight-template-roles は軽量な一覧性と有効拘束条件の明示を重視している。分割スキーマは AI 支援編集で不整合を生みやすく、運用上の摩擦源になっている。decision 単一フィールドにすると決定名と拘束内容を一体で保持でき、乖離を減らせる。トレードオフとして構造分離は弱まるが、必要時のみ 3 行程度までを許可する運用で補える。
- Current conclusion: DECISIONS.yml の記述スキーマは decision を唯一の説明フィールドにし、title/reason は廃止する。同じスキーマを DECISIONS.example.yml と templates/DECISIONS.yml にも適用する。
- Promotion to DECISIONS.yml: promoted -> agent-010-decision-single-field, agent-010-1-decision-single-field-length
- Evidence / references (optional): records/agent-005-lightweight-template-roles.md, DECISIONS.yml, DECISIONS.example.yml, templates/DECISIONS.yml

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-06-28)
- Why now: 昇格済みスキーマ変更の実装フェーズをクローズし、実装結果を履歴に残すため。
- Findings / trade-offs: DECISIONS.yml を decision 単一スキーマへ移行し、Template カテゴリに新しい decision family を Implementation Approved で追加した。DECISIONS.example.yml と templates/DECISIONS.yml から title/reason を除去し、decision は必要時のみ 3 行程度まで許可する運用を明記した。日本語ミラー成果物も同期した。
- Current conclusion: リポジトリの正本・サンプル・テンプレートの決定オブジェクトは、説明フィールドとして decision を単一採用する状態に統一された。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): DECISIONS.yml, DECISIONS.example.yml, templates/DECISIONS.yml, .docs/ja/DECISIONS.yml, .docs/ja/DECISIONS.example.yml, .docs/ja/templates/DECISIONS.yml
