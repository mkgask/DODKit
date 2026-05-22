# Decision Record: agent-006-agent-orchestration-model

## Metadata
- Created At: 2026-04-18
- Scope: DODカスタムエージェント、フェーズスキル、成果物監査のオーケストレーションモデル

## Notes
- このファイルは追記専用の議論履歴です。
- 可変の追跡項目（status、remaining work、open action items）は追加しません。
- 未解決事項の一覧は保持しません。追加の確認が必要な場合はチャットで確認し、解決した事実だけを追記します。
- 実装を拘束する事実になった場合は DECISIONS.yml に昇格します。
- 各項目は議論に必要な範囲で簡潔に保ちます。
- 証拠や昇格メタデータの詳細は任意であり、明確さを損なわない限り省略できます。

Append rules:
- EOF にのみ追記し、既存の節は編集しません。
- status tracking や remaining-work items は追加しません。

## Entry List

### Entry 0001 (2026-04-18)
- Why now: DOD のフェーズ実行を1つの主エージェントで維持するか、複数の対等なエージェントへ分割するかを決めるため。
- Findings / trade-offs: DOD は Gate A、Gate B、Gate C によって公式な進行順序を固定しているため、フェーズ遷移には単一の責任主体が必要です。対等な複数エージェント構成は引き継ぎコストを増やし、成果物順序、status 更新、最終ゲート判定の責任を曖昧にしやすくなります。一方で、フェーズ内の手順自体は分離可能であり、議論、実装、成果物監査は再利用可能なスキルとしてモジュール化できます。独立した監査エージェントは、監査独立性や並列負荷が追加のオーケストレーションコストを上回る場合にのみ有効です。
- Current conclusion: フロー制御とゲート判定は1つのメイン DOD エージェントに集約し、議論フェーズ、実装フェーズ、成果物監査は既定では専用スキルとして実行します。独立した read-only の監査エージェントは、独立性または規模の要求がある場合に限って導入します。
- Promotion to DECISIONS.yml: promoted -> agent-006-agent-orchestration-model, agent-006-1-main-agent-governance, agent-006-2-phase-skills-default, agent-006-3-audit-skill-default, agent-006-4-audit-agent-exception
- Evidence / references (optional): DOD.md, templates/agent.md, DECISIONS.yml

### Entry 0002 (2026-05-22)
- Why now: DOD の各 skill をそれぞれ subagent で動かすべきか、それともメインエージェントが skills を順次実行し、必要時のみ subagent を使うべきかを決めるため。
- Findings / trade-offs: 1 skill ごとに subagent を起動すると、局所的な先入観を減らし、特に検証で独立した見方を得やすい利点はあるが、そのぶん引き継ぎコストが増え、Gate A と Gate B をまたいで active decision context を保ちにくくなる。DOD では、promoted decisions と current record がそのまま次の operational step へ持ち越されるべきなので、既定ではその連続性を 1 つの責任主体の中で保つ方がよい。よりよい折衷は、メインエージェントが skills を順次実行するのを既定としつつ、独立性、探索量、fresh validation perspective が追加のオーケストレーションコストを正当化する場合に限って、bounded な read-only subagent assistance を許可することだ。その場合でも、最終ゲート判定、record 更新、decision promotion、closeout はメインエージェントの責務に残る。
- Current conclusion: 既定のオーケストレーションモデルは、1つのメイン DOD エージェントの下で skills を順次実行する形とする。subagent は、各 skill の既定実行単位ではなく、例外的な read-only helper としてのみ使う。
- Promotion to DECISIONS.yml: promoted -> agent-006-agent-orchestration-model, agent-006-2-phase-skills-default, agent-006-5-subagent-assistance-exception
- Evidence / references (optional): DECISIONS.yml, templates/agent.md, records/agent-008-phase-skill-set.md