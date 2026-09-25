[← Back](../../README-en.md) | [English](README.md) | [Japanese](../README.md)

# study/

Background notes for reading this repository. They write out, from definitions and small examples, the mathematics the proof takes as known (ordinals, well-founded recursion, model theory) and the two layers of the proof (Phyrion's combinatorial layer and the semantic layer of this repository).

The writing rules are fixed in [rule.md](rule.md).

## Contents

| Note | Topic | Where it is used in this repository |
|---|---|---|
| [01 Ordinals and ω₁](01-ordinals.md) | well-orders, successors and limits, suprema, countability, regularity of $`\omega_1`$, enumerating countable ordinals | README "The relation R", "Where the six hypotheses go"; notes/01-design.md §3.6, §4.7 |
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded relations, accessibility, well-founded induction, lexicographic products, well-founded recursion, guarded recursion, termination by labels | README "The relation R"; notes/01-design.md §3.1, §4.1 |
| [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md) | structures, $`\Sigma_1`$ formulas, atomic diagrams, $`\preccurlyeq_{\Sigma_1}`$, the Tarski–Vaught test, the normal form of $`\Sigma_1`$ formulas, visible bits | README "The relation R"; notes/01-design.md §3.2–§3.4 |
| [04 Patterns of resemblance](04-patterns-of-resemblance.md) | Carlson's $`\le_1`$, small examples, the shape of finite reflection, bms-elem-pattern, what is missing for 1-Y | README "Shape of the proof"; notes/01-design.md §1, §3.8, §6.3 |
| [05 The 1-Y sequence and its mountain](05-1y-mountain.md) | expressions, rows of the mountain, differences and parents, heights, layers, the bad root, examples of expansion | README "Notation", "The four final theorems"; notes/01-design.md §2.1 |
| [06 Phyrion's combinatorial layer](06-combinatorial-layer.md) | diagrams, representations, demands toward the top, finite reflection, the six hypotheses, descent of the last label | README "Shape of the proof", "Where the six hypotheses go"; notes/01-design.md §2 |
| [07 The relation R](07-relation-r.md) | the structures of level $`(k, \eta)`$, the definition of $`R`$, the (top, layer, root label) recursion, the defining equation, strictness, weakening | README "The relation R"; notes/01-design.md §3.3–§3.8, §4.1–§4.4 |
| [08 Closure below ω₁ and the chain](08-closure-chain.md) | Good, heights of witnesses, next, λ, λ(γ) is Good, the chain | README "Where the six hypotheses go"; notes/01-design.md §3.6, §4.7 |
| [09 Discharging the obligations](09-obligations.md) | O1–O7, finite reflection, absoluteness of the top predicates, two points of the chain are related, representations of all diagrams, the final theorems | README "Where the six hypotheses go"; notes/01-design.md §2.3, §4 |

The notes in `notes/` are in Japanese.

## Reading order

```mermaid
flowchart TB
  N01["01 Ordinals and ω₁"] --> N02["02 Well-founded recursion"]
  N01 --> N03["03 Σ₁-elementary substructures"]
  N02 --> N04["04 Patterns of resemblance"]
  N03 --> N04
  N02 --> N05["05 1-Y sequence and mountain"]
  N05 --> N06["06 Combinatorial layer"]
  N04 --> N07["07 The relation R"]
  N06 --> N07
  N07 --> N08["08 Closure and chain"]
  N08 --> N09["09 Discharging the obligations"]
  N06 --> N09
```
