# 決定記録: agent-014-decision-document-ownership

## メタデータ
- Created At: 2026-08-22
- Scope: DOD の決定事項をプロジェクト文書とエージェント文書の間で管理する所有権と重複禁止規則の定義

## 注意
- このファイルは追記専用の議論履歴です。
- 更新が前提の追跡項目（status、残作業、未完了アクション項目）を追加しないでください。
- 未解決質問の管理台帳として使わず、確認が必要な内容はチャットで質問し、回答後に事実だけを追記してください。
- 事実が実装拘束条件になったら、DECISIONS.yml に昇格してください。
- 各エントリは、その議論で必要な最小限の長さに保ってください。
- 根拠や詳細な昇格メタデータは任意です。なくても意味が通るなら省略して構いません。

追記ルール:
- 既存セクションは書き換えず、末尾追記のみ。
- status や残作業の追跡項目を追加しないでください。

## エントリ一覧

### エントリ 0001（2026-08-22）
- Why now: 以前、AIエージェントが同じプロジェクト決定を DECISIONS.yml と PRINCIPLES.md や AGENTS.md などの別文書へコピーしたことがあった。既存の DOD 手法では決定事項リストと議論記録の役割がすでに定義されているが、discussion skill には書き込み前に文書の所有権を分類する明示的な指示がない。
- Findings / trade-offs: DOD.md、DECISIONS.yml、AGENTS.md、README.md、templates/agent.md、discussion と discussion-validation の各 skill、隣接する decision-promotion skill、インストーラーマニフェストとテスト、agent-013 の記録、英語・日本語ミラーを境界付きで調査した。その結果、DECISIONS.yml は現在のプロジェクト決定と実装拘束条件の正本としてすでに扱われている。DOD.md もこの分類を説明しているため、そこを変更すると書き込み時の失敗ではなく方法論上の重複説明を増やす。現在のリポジトリに PRINCIPLES.md は存在しない。AGENTS.md にはリポジトリとエージェントの運用規則があり、その役割のために独立した正本として残せるため、編集を全面禁止するのは広すぎる。必要な境界は、同じプロジェクト固有の決定文のコピーを禁止しつつ、それぞれの文書に固有の運用上または説明上の内容を許可することである。インストーラーは対象の skill テンプレートをすでに配布しているため、マニフェスト変更は不要である。
- Focus / exclusions: 焦点は templates/skills の議論時の所有権確認と、昇格前の検証確認に置く。DOD.md、AGENTS.md、README.md、PRINCIPLES.md の作成、インストーラーの挙動、新しい決定ファイル階層の挙動は対象外とする。影響する文書面は英語の原本と日本語ミラーである。
- Current conclusion: templates/skills/discussion.skill.md に簡潔な文書所有権ガードレールを追加し、対応する日本語ミラーを更新する。discussion-validation に、プロジェクト固有の実装拘束条件に DECISIONS.yml 上の正本が1つあり、他文書の変更が独立した理由を持つことを確認する項目を追加し、日本語ミラーにも反映する。拘束条件は DECISIONS.yml に、理由と履歴はこの record に置き、AGENTS.md、PRINCIPLES.md、DOD.md、README.md、または skill files に同じ決定をコピーしない。この候補方針は discussion-validation の準備ができている。
- Promotion to DECISIONS.yml: none; candidate direction is ready for discussion-validation
- Evidence / references (optional): DOD.md; DECISIONS.yml; AGENTS.md; README.md; templates/agent.md; templates/skills/discussion.skill.md; templates/skills/discussion-validation.skill.md; templates/skills/decision-promotion.skill.md; install.sh; tests/install.test.sh; records/agent-013-discussion-record-boundaries.md; .docs/ja/templates/skills/discussion.skill.md; .docs/ja/templates/skills/discussion-validation.skill.md

## 追記テンプレート（同一ファイル末尾にコピーして追記）

### エントリ {next-sequence}（{timestamp}）
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references（optional）:

### エントリ 0002（2026-08-22）
- Why now: 昇格前に、候補となる文書所有権の方針を当初の目的と現在有効な DOD の制約に照らして検証する。
- Findings / trade-offs: 境界付きの調査では、現在の決定事項リスト、DOD 手法、エージェント指示、議論関連の skill、隣接する昇格ガイダンス、インストーラーとテストのスコープ、既存の記録境界決定、英語・日本語ミラーを確認した。候補方針は、エージェントが議論の結論を書く時点で問題に対処し、昇格前にも軽量な確認を追加する。既存の2フェーズモデル、追記専用記録、決定一覧の走査性、スコープ付き決定ファイルの規則、プロジェクト決定と独立して管理されるエージェントまたはリポジトリ運用指示の区別を維持する。AGENTS.md や skill の更新を全面禁止するのは適切でない。それらのファイルには固有の運用変更が必要になる場合があるため、複製しない対象はプロジェクト固有の拘束力ある決定文とする。
- Current conclusion: discussion-validation は通過した。DOD Process に文書所有権の新しい決定ファミリーを追加し、DECISIONS.yml の正本、プロジェクト固有の決定文を重複させないこと（ただし独立した運用・説明内容は許可する）、discussion と discussion-validation における所有権確認を別々のルールとして定義する。実装では、英語の discussion と discussion-validation の skill テンプレート、および日本語ミラーを更新する。DOD.md、AGENTS.md、README.md、PRINCIPLES.md、インストーラーマニフェスト、既存の agent-013 記録は変更しない。
- Promotion to DECISIONS.yml: none; discussion-validation passed, promotion targets -> agent-014-decision-document-ownership, agent-014-1-canonical-project-decision-source, agent-014-2-no-duplicate-project-decision-text, agent-014-3-document-ownership-validation
- Evidence / references (optional): DOD.md; DECISIONS.yml; AGENTS.md; templates/skills/discussion.skill.md; templates/skills/discussion-validation.skill.md; templates/skills/decision-promotion.skill.md; records/agent-013-discussion-record-boundaries.md; .docs/ja/templates/skills/discussion.skill.md; .docs/ja/templates/skills/discussion-validation.skill.md

### エントリ 0003（2026-08-22）
- Why now: 文書所有権の決定ファミリーを昇格した後の実装結果を記録する。
- Findings / trade-offs: discussion skill は結論を書く前に文書所有権を分類するようになり、discussion-validation skill は DECISIONS.yml 上の正本が1つであることと、正当化されていないプロジェクト固有の決定文の重複を確認するようになった。英語の2つの skill テンプレートには同等の日本語ミラーを用意した。DOD.md、AGENTS.md、README.md、PRINCIPLES.md、インストーラーマニフェスト、既存の agent-013 記録は変更していない。変更ファイルの診断に問題はなく、インストーラーの関数レベル回帰テストと git diff --check は通過した。
- Current conclusion: 実装は昇格した決定契約に一致している。プロジェクト固有の実装拘束条件について、正本と重複禁止のガードが明示され、独立した運用上または説明上の文書変更は引き続き可能である。agent-014 の決定ファミリーは、実装承認済み status でクローズできる。
- Promotion to DECISIONS.yml: promoted -> agent-014-decision-document-ownership, agent-014-1-canonical-project-decision-source, agent-014-2-no-duplicate-project-decision-text, agent-014-3-document-ownership-validation
- Evidence / references (optional): DECISIONS.yml; templates/skills/discussion.skill.md; templates/skills/discussion-validation.skill.md; .docs/ja/templates/skills/discussion.skill.md; .docs/ja/templates/skills/discussion-validation.skill.md; tests/install.test.sh; git diff --check

### エントリ 0004（2026-08-22）
- Why now: 最終成果物検証で、更新した DECISIONS.yml に必要な日本語ミラーへ新しい決定ファミリーがまだ反映されていないことが分かった。
- Findings / trade-offs: 日本語の DECISIONS.yml ミラーに、agent-014 の親決定、3つのサブ決定、実装承認済み status、record link を同じ内容で追加した。診断も通過した。これにより、インストーラーを変更したり、別の principles 文書を追加したりせず、英語を先に作成して日本語ミラーを同期するリポジトリ規則を維持できる。
- Current conclusion: 英語・日本語の決定事項リスト、skill テンプレート、議論記録は、同じ文書所有権の決定契約を表現している。前の実装結果の結論は、この同期修正後も有効である。
- Promotion to DECISIONS.yml: already promoted -> agent-014-decision-document-ownership, agent-014-1-canonical-project-decision-source, agent-014-2-no-duplicate-project-decision-text, agent-014-3-document-ownership-validation
- Evidence / references (optional): DECISIONS.yml; .docs/ja/DECISIONS.yml; tests/install.test.sh
