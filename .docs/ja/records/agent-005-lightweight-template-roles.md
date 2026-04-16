# Decision Record: agent-005-lightweight-template-roles

## メタデータ
- Created At: 2026-04-16
- Scope: DECISIONS.yml テンプレートと discussion-record テンプレートの軽量な役割分担

## 注意
- このファイルは追記専用の議論履歴です。
- 更新が前提の追跡項目（status、残作業、未完了アクション項目）を書かないでください。
- 未解決質問の管理台帳として使わず、確認が必要な内容はチャットで質問し、回答後に事実だけを追記してください。
- 事実が実装拘束条件になったら、DECISIONS.yml に昇格してください。

追記ルール:
- 既存セクションは書き換えず、末尾追記のみ。
- status や残作業の追跡項目を書かないでください。

## エントリ一覧

### エントリ 0001（2026-04-16）
- Trigger: 議論フェーズに成果物が2つあることでAIが順序を逆転させやすくなる懸念に対し、決定フェーズを独立させるべきか、それともテンプレートの役割整理で解決すべきかを検討する。
- Context and Research: DOD では、決定が明示されるまで議論フェーズは完了しないため、決定フェーズを独立させても実務上の新しい作業はほとんど増えません。現在の摩擦は、discussion-record テンプレートがやや重く見えることと、DECISIONS.yml にどこまで契約詳細を書くべきかが曖昧なことから生じています。
- Discussion: DOD は2フェーズのまま維持し、フェーズを増やす代わりにテンプレートガイダンスで成果物摩擦を下げる。DECISIONS.yml は人間の一覧性を優先して既定形を軽く保つ。契約詳細が独立した拘束条件になった場合のみ、各決定ノードに必須フィールドを増やすのではなく追加のサブ決定として表現する。discussion-record.md は必須項目を減らし、根拠や詳細な昇格メタデータは任意にする。
- Outcome at this time: DOD の軽量性を保ちながら明示的な決定昇格を維持するため、新しいテンプレート指針の決定群が必要。
- Decision impact: フェーズ維持、DECISIONS.yml の一覧性、必要時のみの契約表現、discussion-record の軽量構造に関する現在有効なルールを追加する必要がある。
- DECISIONS.yml promotion: promoted
- Promotion target IDs（promoted の場合）: agent-005-lightweight-template-roles, agent-005-1-two-phase-dod, agent-005-2-decisions-template-scanability, agent-005-3-contract-details-as-needed, agent-005-4-discussion-record-minimal-structure, agent-005-5-optional-record-detail
- Evidence / references: DOD.md, templates/DECISIONS.yml, templates/discussion-record.md, .github/agents/dod.agent.md

## 実装更新（2026-04-16）
- templates/DECISIONS.yml を更新し、既定の決定形を最小限に保ちつつ、契約詳細は独立して有効になった場合にだけ追加のサブ決定として表現する方針を反映しました。
- templates/discussion-record.md と、ワークスペースで実際に使う .dodkit/templates/discussion-record.md を更新し、必須項目を減らして根拠や昇格詳細を任意化しました。
- templates/agent.md を現在の DOD エージェント指針に同期し、インストールされたエージェントでも議論から決定への成果物順序が固定で維持されるようにしました。
- 残存リスク: 既に古いテンプレートをコピー済みのリポジトリは、テンプレートを再コピーするか installer を再実行するまで旧構造のままです。

## 仕様同期更新（2026-04-16）
- DOD.md をこの decision family に合わせて同期し、決定契約を「明示は必要だが、最小限かつ人間が一覧しやすい形でよい」と読めるようにしました。
- 不変条件、非目標、受け入れ基準、失敗条件は、実装を実質的に拘束する場合に関連する決定集合の中で明示される必要がある一方、各決定事項オブジェクトに4つの専用フィールドとして必ず並べる必要はないことを明確化しました。