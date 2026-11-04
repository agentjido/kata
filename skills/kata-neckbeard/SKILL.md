---
name: kata-neckbeard
description: Answer questions about an existing system with evidence from its source code, tests, configuration, and documentation. Use when the user asks how a feature works, where behavior is implemented, or what requirements and limits apply.
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: investigate
  object: software-system
  profile: bounded-execution
  authority: read-only
  consumes: [system-question, software-system]
  produces: [evidence-supported-answer]
  optimized_for: "codex/gpt-6-astra/xhigh"
---

# Kata Neckbeard

**Outcome:** An evidence-supported answer about the current system for the
person or agent that needs to understand it next.

**Done:** The scoped question is answered, each material claim has a relevant
source reference, conflicts and deductions are clear, and missing evidence or
runtime limits are stated.

## Assignment

The required inputs are the question and one target system. Resolve the target
from the conversation; ask when it remains unclear. The practice is
evidence-based system investigation. The work profile is `bounded-execution`.

Direct user authority or inherited caller authority permits read-only inspection
of the target's documentation, source, configuration, tests, and relevant
history. Read applicable project instructions and preserve Git state. Do not
edit files, change code, or change local, remote, or live-system state. If the
available evidence cannot answer the question, report that limit instead of
expanding the scope or inventing a reason.

## Investigate

Choose the investigation order based on the question and available evidence.
Use the repository README and `guides/README.md`, when present, to locate
documentation as needed; documentation may live elsewhere. Read the relevant
documentation, source, configuration, and test source. Follow entry points and
data flow as far as needed to explain the requested behavior and its limits.

Support each material claim with a link to the current source file and relevant
lines. Use code and configuration as evidence of implemented behavior, test
source for expected behavior, and documentation for requirements or intent.
Compare the relevant documentation and implementation; report disagreements
with references to both sources.

When the question asks why a choice was made, consult available decision
records, comments, or relevant history. Do not infer rationale or design history
from implementation alone. If the evidence does not establish a reason, say so.
Separate confirmed facts from deductions and identify missing evidence.

Stop investigating once the scoped answer is supported and remaining uncertainty
can be stated accurately. Answer the specific question first, in natural,
direct language. Include relevant prerequisites, limits, and unresolved questions.
State what static inspection cannot confirm. Do not claim that tests passed or
deployed behavior was verified without evidence.
