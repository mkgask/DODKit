# Decision Record: agent-008-phase-skill-set

## Metadata
- Created At: 2026-05-21
- Scope: DOD のフェーズ実行用デフォルトスキル群を 4 スキル構成で定義し、既定の audit を validation スキルへ吸収する

## Notes
- This file is append-only discussion history.
- Do not add mutable tracking fields here (status, remaining work, open action items).
- Do not keep open-question backlogs here. If clarification is needed, ask in chat and append the resolved facts.
- If a fact becomes a binding implementation constraint, promote it to DECISIONS.yml.
- Keep each entry as short as the discussion allows.
- Evidence and detailed promotion metadata are optional; omit them when the entry stays clear without them.

Append rules:
- Append at EOF only; do not edit earlier sections.
- Do not add status tracking or remaining-work items.

## Entry List

### Entry 0001 (2026-05-21)
- Why now: フェーズスキルと検証チェックポイントの採用後、メイン DOD エージェント配下にどの具体的なスキルを同梱するべきかを明確化し、既定の audit skill を残す必要があるかを決めるため。
- Findings / trade-offs: 既存の決定ではフェーズスキルと、議論検証および実装検証という 2 つの検証チェックポイント自体は承認済みだが、デフォルトのスキル構成はまだ曖昧だった。別個の audit skill を維持すると、多くの監査作業が決定昇格前の方向性確認か、クローズ前の成果物確認のどちらかに当たり、責務が重複する。これらの確認を 2 つの validation skill に吸収すれば、パッケージをより小さく保てて、2 フェーズ DOD モデルとの対応も明確になる。そのうえで、独立性や規模が正当化する場合に限って、将来 separate read-only audit agent を使う余地は残せる。したがって、既定の再利用単位は discussion、discussion-validation、implementation、implementation-validation の 4 スキルとし、フロー制御、ゲート判定、決定昇格順序はメインエージェントが保持するのがよい。
- Current conclusion: DOD のデフォルトスキル構成は、フェーズに対応した 4 スキルとするべきである。既定の audit チェックは独立した audit skill としては持たず、discussion-validation skill と implementation-validation skill に吸収する。
- Promotion to DECISIONS.yml: promoted -> agent-008-phase-skill-set, agent-008-1-discussion-skill, agent-008-2-discussion-validation-skill, agent-008-3-implementation-skill, agent-008-4-implementation-validation-skill, agent-006-2-phase-skills-default, agent-006-3-audit-skill-default
- Evidence / references (optional): DECISIONS.yml, records/agent-006-agent-orchestration-model.md, records/agent-007-phase-verification-model.md, templates/agent.md

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-05-21)
- Why now: 新しく作る 4 本の skill 成果物を書き始める前に、リポジトリ上のソース配置を決めるため。
- Findings / trade-offs: VS Code が実際に検出する skill は `.github/skills/<name>/SKILL.md` だが、リポジトリ側にもレビュー、差分確認、翻訳をしやすい source-of-truth 配置が必要である。`templates/skills/` 配下に、配布する各 skill ごとに 1 つの `.skill.md` ファイルを置けば、再利用する内容をまとめて管理しつつ、これらがまだライブのワークスペースカスタマイズではなくソーステンプレートであることも明確にできる。この方式なら、まず内容を先に固め、その後で installer や出力マッピングを別変更でつなげられる。
- Current conclusion: DOD のデフォルト 4 skills のソースは `templates/skills/` 配下の `.skill.md` ファイルとして管理する。これらはリポジトリテンプレートであり、将来の install または sync で実際の skill 検出レイアウトへ写像する。
- Promotion to DECISIONS.yml: promoted -> agent-004-6-skill-template-source-layout
- Evidence / references (optional): templates/, .github/skills/, records/agent-004-installer-template-details.md, records/agent-008-phase-skill-set.md

### Entry 0003 (2026-05-21)
- Why now: 最初の discussion skill テンプレートが、実装向けの局所探索に寄りすぎていないかを見直すため。
- Findings / trade-offs: 最初の discussion skill 草案は、ローカル仮説の早期形成へ寄りすぎており、これは実装ループには合うが議論フェーズには狭すぎた。DOD の議論作業では、有効拘束条件が隣接ドメイン、既存決定、近傍インターフェース、スコープ境界に分散していることが多く、早すぎる絞り込みは考慮漏れリスクを上げる。より適切な既定は、まず affected landscape を bounded broad scan で把握し、その後に選んだ焦点領域、意図的な除外、残る不確実性を明示しつつ絞り込むことだ。discussion-validation は、その方向性だけでなく、その絞り込みを正当化できるだけの broad scan があったかも検証するべきである。
- Current conclusion: discussion skill は、焦点化の前に affected landscape への bounded broad scan から始めるべきである。discussion-validation skill は、broad-scan coverage と、その後の絞り込み妥当性を明示的に検証するべきである。
- Promotion to DECISIONS.yml: promoted -> agent-008-5-broad-then-focus-discussion
- Evidence / references (optional): DOD.md, templates/skills/discussion.skill.md, templates/skills/discussion-validation.skill.md