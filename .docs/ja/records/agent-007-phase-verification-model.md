# Decision Record: agent-007-phase-verification-model

## Metadata
- Created At: 2026-04-22
- Scope: DOD において、実装検証に加えて明示的な議論検証が必要かを整理する

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

### Entry 0001 (2026-04-22)
- Why now: DOD に明示的な検証フェーズを追加すべきか、それとも既存の 2 フェーズの内部に検証を留めるべきかを整理するため。
- Findings / trade-offs: DOD は意図的に議論フェーズと実装フェーズの 2 つに絞って軽量性を保っているが、実際の作業では議論記録、決定昇格、実装、検証が自然に現れる。実装検証だけでは不十分で、コードが有効な決定を正しく満たしていても、その決定自体が当初の目的に対して誤った方向を向いている可能性がある。一方で、独立した検証フェーズを増やすと手順が重くなり、議論や実装のやり直しと重複しやすい。より軽い選択肢は 2 フェーズを維持したまま、2 種類の検証ポイントを明示することだ。すなわち、決定昇格前の議論検証と、クローズ前の実装検証である。議論検証は候補結論が有効な決定になる前に、当初の目的、現在の拘束条件、想定されるドリフトに照らして方向を確認する。実装検証は、昇格済み決定に対してテスト、コード、成果物を検証する。
- Current conclusion: DOD は 2 フェーズモデルを維持するべきである。独立した検証フェーズは追加せず、その代わりに、決定昇格前の軽量な議論検証と、実装クローズ前の明示的な実装検証を必須にする。
- Promotion to DECISIONS.yml: promoted -> agent-007-phase-verification-model, agent-007-1-no-third-phase, agent-007-2-discussion-validation-before-promotion, agent-007-3-implementation-validation-before-closeout
- Evidence / references (optional): DOD.md, DECISIONS.yml, records/agent-005-lightweight-template-roles.md, templates/agent.md

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-04-22)
- Why now: 承認された検証モデルを、英語版と日本語版の仕様、README 要約、DOD エージェントガイダンスへ同期するため。
- Findings / trade-offs: 仕様とエージェントガイダンスは、DOD を 2 フェーズのまま保ちつつ、2 つの検証チェックポイントを明示する形になった。議論検証は議論フェーズ内の軽量な昇格前チェックとして定義され、実装検証は実装フェーズ内のクローズ前チェックとして定義された。これにより、軽量性を保ったまま、実装検証だけでは捉えきれない方向性の誤りがあることを明確にできる。
- Current conclusion: 検証モデルは、第3のライフサイクルフェーズを追加せずに、リポジトリ内の文書とエージェントガイダンスへ実装された。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): DOD.md, README.md, templates/agent.md, .github/agents/dod.agent.md, .docs/ja/DOD.md, .docs/ja/README.md, .docs/ja/templates/agent.md, .docs/ja/.github/agents/dod.agent.md

### Entry 0003 (2026-04-22)
- Why now: DOD ワークフローをゲート条件の散在としてではなく、各フェーズ内の明示的な手順順序として表現し、エージェントガイダンスの認知負荷を下げるため。
- Findings / trade-offs: 同じ拘束条件を維持したままでも、エージェント指示をより順序ベースにできる。議論フェーズ内と実装フェーズ内の推奨順序を明示すると、新しいフェーズを増やしたり DOD 本文を再び膨らませたりせずに、人間の運用とエージェント出力を揃えやすくなる。
- Current conclusion: エージェントガイダンスは、DOD の拘束条件を、議論 -> 議論検証 -> 決定昇格、その後に設計 -> テスト・実装 -> 検証、というフェーズ内の順序で表現するのがよい。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): templates/agent.md, .github/agents/dod.agent.md, .docs/ja/templates/agent.md, .docs/ja/.github/agents/dod.agent.md