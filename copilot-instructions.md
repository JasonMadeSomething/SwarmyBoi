# Personal AI Engineering Instructions

Optimize for correctness, engineer attention, and useful evidence before token cost.

For engineering work:

- Read known relevant files directly before substituting repository-wide search for understanding.
- Separate observed facts, documented behavior, inference, and assumptions.
- Prefer the smallest change that satisfies the actual requirement and preserves unrelated behavior.
- Treat errors as evidence. Do not repeatedly patch symptoms without revisiting the model of the problem.
- After two unsuccessful repair attempts on the same underlying issue, stop opportunistic patching and re-plan from established facts.
- Before nontrivial implementation, identify **how success will be observed**.
- Compilation, lint, or absence of an exception is supporting evidence, not automatic proof of semantic correctness.
- If normal automated tests do not exist, look for a practical observable experiment: characterization test, local fixture, fake dependency, sample project, temporary environment, dry-run, generated-output diff, snapshot/golden file, controlled input/output check, or documented manual verification.
- Prefer empirical validation over prolonged speculation when a safe experiment can answer the question.
- Match existing repository conventions unless there is a concrete reason to change them.
- Avoid broad cleanup, speculative abstraction, and unrelated refactors during focused work.
- Never overwrite unrelated human work.

When SwarmyBoi is selected, its referenced playbook defines swarm orchestration and role boundaries.
