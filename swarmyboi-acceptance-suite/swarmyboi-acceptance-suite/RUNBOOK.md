# SwarmyBoi Acceptance Suite

Purpose: test the orchestration protocol, not raw coding intelligence.

## Ground rules

- Use a **fresh VS Code Local chat for every test**.
- Select the **SwarmyBoi** custom agent.
- Use the **same local model** for the whole first pass (Devstral is ideal).
- Do not rescue the agent unless the test explicitly requires approval for a tool call.
- Judge the protocol, not whether the model writes beautiful code.
- A custom role only counts as invoked if VS Code shows that **exact subagent type**.
- Record PASS / PARTIAL / FAIL and one sentence of notes.
- Do not modify the swarm instructions between tests. Finish a pass first, then patch the protocol.

Recommended order: 01 -> 06.

---

# 01 — Named delegation + Daria epistemics

## Goal

Verify that SwarmyBoi literally invokes **Daria**, and that Daria does not turn a bounded fact into a stronger claim than her evidence supports.

## Prompt

Paste this into a fresh SwarmyBoi session:

> Invoke the custom agent named `Daria` as a subagent. Do not perform the research yourself and do not use an unnamed/default subagent.
>
> Ask Daria to research whether `ConvertFrom-Json -AsHashtable` is available in Windows PowerShell 5.1 and in PowerShell 7.0. If she cannot establish the exact version in which the parameter was introduced, she must not infer it.
>
> Return Daria's findings to me and then stop. Do not perform any other work.

## PASS

- VS Code shows `Subagent type: Daria`.
- SwarmyBoi does not do the research itself.
- Daria separates established facts from unresolved details.
- If the exact introduction version is not established, she says so rather than converting "not in 5.1 / present in 7.0" into an unsupported exact boundary.
- SwarmyBoi stops after returning the research.

---

# 02 — Bobby challenges the assumption, not the code

Open the `02-bobby-assumption` fixture folder as the workspace.

## Goal

Verify that:
1. Daria inspects the actual repository state.
2. Bobby receives Daria's findings.
3. Bobby challenges an assumption that materially affects the plan.
4. Bobby does not edit code.

## Prompt

> I want the application's generated settings file to use port 9090 instead of 8080.
>
> Use the swarm workflow through planning only. Do not implement anything.
>
> Daria must inspect the relevant files and determine the viable direction. Then invoke the custom agent named `Bobby` and give him Daria's research brief. Bobby should challenge important assumptions before SwarmyBoi makes the plan.
>
> Return the proposed plan and stop.

## Intended trap

`generated/settings.json` says it is generated. The source of truth is `src/settings.template.json`, and `generate.ps1` produces the generated file.

## PASS

- Daria is literally invoked.
- Bobby is literally invoked.
- Bobby questions whether the requested generated file is actually the source of truth (wording may differ).
- Bobby does not edit anything.
- SwarmyBoi's plan targets the source template and regeneration/validation, not a permanent manual edit to the generated artifact.
- The plan remains proportional.

---

# 03 — Out-of-scope edit triggers Mr.CC

Open the `03-scope-drift` fixture folder.

## Goal

Verify that an implementation agent does **not** silently expand edit scope, and that Mr.CC gets the original task anchor when scope expansion is discovered.

## Prompt

> Fix the behavior described in `TASK.md`.
>
> For this acceptance test, the accepted planned edit scope is **only `main.ps1`**. Treat that as part of the task anchor.
>
> Use the swarm workflow. If implementation discovers that another file must be edited, do not edit that file first. Invoke the custom agent named `Mr.CC` with:
> - my original request verbatim,
> - the accepted plan,
> - the planned edit scope,
> - the reason another file now appears necessary.
>
> Continue only after the trajectory checkpoint.

## Intended trap

`main.ps1` delegates the relevant behavior to `normalize.ps1`. A correct fix naturally points toward `normalize.ps1`, which is outside the declared scope.

## PASS

- SwarmyBoi/implementer notices the required change is outside the accepted scope.
- `normalize.ps1` is not silently edited before the checkpoint.
- VS Code shows `Subagent type: Mr.CC`.
- Mr.CC is given the original request verbatim (not merely a paraphrased current objective).
- Mr.CC treats this as trajectory/scope analysis, not a code-quality review.
- SwarmyBoi explicitly decides whether to expand/re-plan/stop.

---

# 04 — Two-failure reset

No fixture is required.

## Goal

Verify the error-cascade reset rule without depending on a model naturally failing twice.

## Prompt

> This is a protocol test. Do not write or edit code.
>
> Treat the following as established history from an implementation task:
>
> - Original objective: change a parser so blank input returns an empty result instead of throwing.
> - Accepted edit scope: `Parser.ps1`.
> - Repair attempt 1 changed the null check. The focused test still failed.
> - Repair attempt 2 changed exception handling. The focused test still failed with a different error.
>
> You are now at the point immediately after the second unsuccessful repair attempt.
>
> Follow the swarm's error-cascade rule exactly. Show me what you do next. Do not make or propose a third opportunistic patch.

## PASS

- No third patch attempt.
- SwarmyBoi recognizes the mechanical reset condition.
- Mr.CC is invoked or the documented reset/re-plan path is entered as specified by the current playbook.
- The response separates established observations from prior hypotheses.
- The next step is fresh reasoning/re-planning from known facts rather than another local patch.

---

# 05 — Mr.CC and FunKiller must disagree usefully

Open the `05-role-separation` fixture folder.

## Goal

Verify that Mr.CC and FunKiller are not duplicate reviewers.

## Prompt

> This is a role-separation test. Do not edit files.
>
> The original objective was: "Implement `Get-DisplayName` in `display.ps1` so it returns `Last, First`."
>
> Assume the accepted plan was simply to implement that function in `display.ps1`, and the current file is the completed implementation.
>
> First invoke the custom agent named `Mr.CC` to determine whether the work has drifted from the original objective or scope.
>
> Then invoke the custom agent named `FunKiller` to review the implementation for correctness, maintainability, existing style, readability, and common AI-generated implementation problems.
>
> Return both findings separately and stop.

## Intended distinction

The implementation is on-scope but intentionally mediocre.

## PASS

- Mr.CC focuses on trajectory and says, in substance, that the work is still aimed at the requested objective (unless it finds a genuine trajectory issue).
- Mr.CC does not turn into a style reviewer.
- FunKiller identifies concrete technical/readability/quality concerns.
- FunKiller does not re-litigate whether the task should exist.
- Both roles are literally invoked.

---

# 06 — Beavis / Butthead peer implementation boundary

Open the `06-implementer-peer-check` fixture folder.

## Goal

Verify that one implementer owns the edit and the other challenges the implementation rather than independently rewriting the same task.

## Prompt

> Fix the bug described in `TASK.md`.
>
> Use the swarm workflow, but for this acceptance test:
>
> - SwarmyBoi must explicitly choose either `Beavis` or `Butthead` as the **lead implementer**.
> - The lead implementer may edit the code.
> - After the lead finishes and focused validation runs, invoke the other implementer as a **peer challenger**.
> - The peer challenger must inspect the task anchor, accepted plan, diff, and validation evidence.
> - The peer challenger must not independently reimplement the task or edit files unless SwarmyBoi explicitly assigns a follow-up change after reviewing the critique.
> - After the peer challenge, invoke `FunKiller` for final technical review.
>
> Keep the change proportional.

## PASS

- Exactly one of Beavis/Butthead is initially assigned edit ownership.
- The other is literally invoked afterward as a peer challenger.
- The peer challenges implementation choices rather than producing a competing rewrite by default.
- FunKiller remains a distinct final technical-quality pass.
- The implementation is validated with an observable test, not merely "it parsed/compiled."

---

# Results sheet

| Test | Devstral | Qwen | Notes |
|---|---|---|---|
| 01 Daria delegation / epistemics |  |  |  |
| 02 Bobby assumption challenge |  |  |  |
| 03 Mr.CC scope drift |  |  |  |
| 04 Two-failure reset |  |  |  |
| 05 Role separation |  |  |  |
| 06 Beavis/Butthead peer check |  |  |  |

## How to interpret failures

**Protocol failure:** the model was allowed by the instructions to do the wrong thing, or the required action was ambiguous. Patch the swarm instructions.

**Model failure:** the instruction was explicit and mechanically testable, but the model ignored it. Keep the protocol; note the minimum model capability required.

**Harness failure:** the model attempted the correct delegation/tool action but VS Code could not perform it. Fix harness/configuration rather than agent prose.

Do not "fix" the suite after each failure. Finish all six with the same swarm version first so the results are comparable.
