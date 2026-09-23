[← Back](README.md) | [English](05-1y-mountain.md) | [Japanese](../05-1y-mountain.md)

# The 1-Y sequence and its mountain

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded, the lexicographic order is not well-founded |

This note explains how 1-Y sequences and their expansion are defined in Lean. The definitions are those of Phyrion's formalization ([Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean)), adapted into `ZeroY/` and `OneY/` of this repository. This repository does not re-check the definition of expansion ([notes/01-design.md](../../notes/01-design.md) §5, item 6, Japanese).

The values in the examples were computed with `#eval` of `OneY.Numeric.expand` and related functions of this repository, in Lean 4.33.1 (2026-09-23).

## 1. Expressions

**Definition (expression).** An **expression** is a finite sequence of positive integers $`s = (s_0, \ldots, s_{n-1})`$ that is empty or has $`s_0 = 1`$ (`ZeroY.Legal`, `ZeroY.Expr`). It need not be generated from a seed.

- Positions are counted from 0. Entry $`i`$ is called "column $`i`$".
- A seed is an expression $`(1, m)`$ with $`m \ge 1`$. In Lean, `ZeroY.Expr.seed n` $`= (1, n+1)`$.
- Expressions are ordered by the lexicographic order $`\lt_{\mathrm{lex}}`$ (`ZeroY.SeqLt`, `ZeroY.ExprLt`). A proper prefix is smaller. As in [02](02-well-founded.md) §1, this order is not well-founded on all expressions.

## 2. Row 0 of the mountain

**Definition (parent in row 0).** The row-0 parent of column $`c`$ is the largest $`p`$ with $`p \lt c`$ and $`s_p \lt s_c`$. If there is none, $`c`$ has no parent.

In Lean this row is `ofSequence s`. It starts from the forest `linearForest`, in which every earlier column is an ancestor, and chooses parents with `select`. Columns from $`n`$ on are filled with value 1 and have no parent.

## 3. Higher rows

From the values $`v_r`$ and parents $`\mathrm{par}_r`$ of row $`r`$ we build row $`r+1`$.

**Definition (difference).** If $`c`$ has parent $`p`$ in row $`r`$, then $`v_{r+1}(c) := v_r(c) - v_r(p)`$; otherwise $`v_{r+1}(c) := 0`$ (`Row.difference`).

**Definition (parent in row r+1).** The row-$`(r+1)`$ parent of $`c`$ is the largest $`p`$ among the row-$`r`$ ancestors of $`c`$ ($`\mathrm{par}_r(c)`$, $`\mathrm{par}_r(\mathrm{par}_r(c))`$, …) with $`0 \lt v_{r+1}(p) \lt v_{r+1}(c)`$ (`select`, `restrictedParent`).

A column with value 0 is read as "absent from that row". Row $`r`$ as a whole is `rows base r`.

**Definition (height and top value).** The **height** of column $`c`$ is the largest $`r`$ with $`v_r(c) \gt 0`$ (`height`). The value in that row is the **top value** (`topValue`). Values strictly decrease from row to row, so the height is finite.

**Example.** $`s = (1, 2, 4, 3)`$. In the table, "$`v \leftarrow p`$" means value $`v`$ with parent column $`p`$.

| row | column 0 | column 1 | column 2 | column 3 |
|---|---|---|---|---|
| 2 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 2 ← 1 | 1 |
| 0 | 1 | 2 ← 0 | 4 ← 1 | 3 ← 1 |

- Row 0: the largest column with a value smaller than 3 (the value of column 3) is column 1 (value 2).
- Row 1: column 3 has value $`3 - 2 = 1`$. Its row-0 ancestors are columns 1 and 0. Their row-1 values are 1 and 0, and neither satisfies $`0 \lt v \lt 1`$. So there is no parent.
- The heights are 0, 1, 2, 1 from left to right. Every top value is 1.

**Definition (root of a component).** In row $`r`$, follow parents from column $`c`$ until a column without a parent. That column is the **root** of $`c`$ in row $`r`$ (`ParentForest.root`, `RowMountain.rootAt`). In row 1 of the example, the root of column 2 is column 1.

## 4. Layers

The 1-Y mountain treats the mountain built so far as one **layer** and stacks layers.

**Definition (extraction).** Layer $`k+1`$ is built from layer $`k`$ (`extract`).

- Values: the top value of each column.
- Forest of candidate parents (`Pseudo.forest`): for a column $`c`$ of height $`h \gt 0`$, the largest ancestor of $`c`$ in row $`h - 1`$ whose height is $`h`$ or $`h - 1`$. A column of height 0 has no candidate parent.
- Inside this forest, parents are chosen by the same rule as in row 0 (the largest ancestor with a positive, strictly smaller value) (`select`).

Layer $`k`$ as a whole is `layers a k`. Column values decrease from layer to layer, so `sequenceBound s` $`= \max(1, \max_i s_i)`$ layers suffice (`sequence_layers_all_one`).

**Example.** $`s = (1, 3)`$.

| layer 0 | column 0 | column 1 |
|---|---|---|
| row 1 | 0 | 2 |
| row 0 | 1 | 3 ← 0 |

Column 1 has height 1 and top value 2. In row 1 the ancestor of column 1 is column 0, but its value is 0, so it is not a parent.

| layer 1 | column 0 | column 1 |
|---|---|---|
| row 1 | 0 | 1 |
| row 0 | 1 | 2 ← 0 |

Row 0 of layer 1 has the top values $`(1, 2)`$. The candidate parent of column 1 is column 0 (a row-0 ancestor of height $`0 = 1 - 1`$). Since $`1 \lt 2`$, the parent is column 0. Layer 2 has values $`(1, 1)`$ and no parents.

For $`(1, 2, 4, 3)`$ all top values are 1, so layers 1 and above have no parents.

## 5. The bad root

**Definition (bad root).** Let $`x`$ be the last column. If in some layer $`k`$ and row $`r`$ the column $`x`$ has a parent $`p`$ with $`v(x) = v(p) + 1`$, then $`p`$ is the **bad root** (`BadAt a k r x p`).

- There is at most one such $`(k, r)`$ (`rootAddress_unique`).
- If $`x`$ has a parent in row 0, a bad root exists. If it has no parent in row 0, there is no bad root (`findBadRoot_none_iff`).
- The search in Lean is `findBadRoot`. Its result is a triple (layer, row, column), `RootAddress`.

| Expression | (layer, row, column) of the bad root | Reason |
|---|---|---|
| $`(1, 2, 3)`$ | $`(0, 0, 1)`$ | row 0: $`3 = 2 + 1`$ |
| $`(1, 2, 4)`$ | $`(0, 1, 1)`$ | row 0: $`4 \ne 2 + 1`$; row 1: $`2 = 1 + 1`$ |
| $`(1, 3)`$ | $`(1, 0, 0)`$ | difference 2 in layer 0; row 0 of layer 1: $`2 = 1 + 1`$ |
| $`(1, 2, 4, 3)`$ | $`(0, 0, 1)`$ | row 0: $`3 = 2 + 1`$ |

## 6. Expansion

**Definition (expansion `expand s N`).** $`N`$ is the number of copies. Let $`x`$ be the last column.

- No bad root: delete the last column. $`s[N] = (s_0, \ldots, s_{x-1})`$.
- Bad root $`z`$: build an expression of length $`x + N \cdot (x - z)`$. The block of columns $`z`$ to $`x - 1`$ (length $`x - z`$) is copied $`N`$ times. The values are not copied directly. The mountain (the parent forests) of each layer is copied, and the values are rebuilt from it (`expandedMountain`, `reconstructedValues`).

| Expression $`s`$ | $`N`$ | $`s[N]`$ |
|---|---|---|
| $`(1)`$ | 5 | $`()`$ |
| $`(1, 2)`$ | 3 | $`(1, 1, 1, 1)`$ |
| $`(1, 2, 3)`$ | 0 | $`(1, 2)`$ |
| $`(1, 2, 3)`$ | 1 | $`(1, 2, 2)`$ |
| $`(1, 2, 3)`$ | 2 | $`(1, 2, 2, 2)`$ |
| $`(1, 2, 2)`$ | 2 | $`(1, 2, 1, 2, 1, 2)`$ |
| $`(1, 2, 4)`$ | 2 | $`(1, 2, 3, 4)`$ |
| $`(1, 2, 4)`$ | 3 | $`(1, 2, 3, 4, 5)`$ |
| $`(1, 3)`$ | 2 | $`(1, 2, 4)`$ |
| $`(1, 3)`$ | 3 | $`(1, 2, 4, 8)`$ |
| $`(1, 2, 4, 3)`$ | 2 | $`(1, 2, 4, 2, 4, 2, 4)`$ |

In the example $`(1, 3)`$ the copying happens in layer 1, so the values are not a plain repetition.

## 7. One-step expansion and the final theorems

**Definition (one-step expansion).** $`t`$ is a nontrivial one-step expansion of $`s`$ if $`s[N] = t`$ for some $`N`$ and $`t \ne s`$ (`ZeroY.ExpansionStep expand t s`).

- The empty expression expands to itself (`expand_empty`). So the empty expression has no one-step expansion.
- A one-step expansion lowers the lexicographic order (`exprLt_of_step`). But the lexicographic order is not well-founded, so this alone does not give termination.

The final theorems of this repository ([README](../../README-en.md) "The four final theorems") are:

1. `expansion_wellFounded`: the one-step expansion relation is well-founded.
2. `generated_strictWellOrder`: the set of expressions reachable from a seed is well-ordered by the lexicographic order.
3. `descendants_strictWellOrder`: for every expression, the set of expressions reachable from it is well-ordered by the lexicographic order.
4. `expansion_chain_reaches_empty`: however the copy counts are chosen, repeated expansion reaches the empty expression.

Items 2–4 follow from item 1 by combinatorial arguments only (`OneY/Dynamics.lean`). The proof of item 1 is the topic of [06](06-combinatorial-layer.md) and the later notes.

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Notation", "The four final theorems" | expressions, $`s[N]`$, $`\to^{*}`$, the four theorems |
| [notes/01-design.md](../../notes/01-design.md) §2.1 (Japanese) | `expand`, `exprDiagram` |
| [notes/02-port.md](../../notes/02-port.md) (Japanese) | list of the mountain and expansion modules |
| `ZeroY/`, `OneY/` | all definitions of this note |

## 9. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| expression | `ZeroY.Expr`, `ZeroY.Legal` | [ZeroY/Syntax.lean](../../ZeroY/Syntax.lean) |
| seed | `ZeroY.Expr.seed` | same |
| lexicographic order | `ZeroY.SeqLt`, `ZeroY.ExprLt` | same |
| parent forest | `OneY.ParentForest`, `root`, `Ancestor` | [OneY/Forest.lean](../../OneY/Forest.lean) |
| row, difference, next row | `Row`, `Row.difference`, `Row.next`, `select`, `rows` | [OneY/Numeric.lean](../../OneY/Numeric.lean) |
| height, top value | `height`, `topValue` | same |
| row 0 | `ofSequence`, `linearForest` | [OneY/NumericGeometry.lean](../../OneY/NumericGeometry.lean) |
| mountain of one layer | `mountain`, `RowMountain`, `rootAt` | same, [OneY/RootGeometry.lean](../../OneY/RootGeometry.lean) |
| forest of candidate parents | `Pseudo.parent`, `Pseudo.forest` | [OneY/Pseudo.lean](../../OneY/Pseudo.lean) |
| layers | `extract`, `layers`, `sequenceBound` | [OneY/Extraction.lean](../../OneY/Extraction.lean) |
| bad root | `BadAt` | [OneY/BadRoot.lean](../../OneY/BadRoot.lean) |
| search for the bad root | `RootAddress`, `findBadRoot`, `findBadRoot_none_iff` | [OneY/RootSearch.lean](../../OneY/RootSearch.lean) |
| expansion | `expand`, `expandValues`, `expandedMountain` | [OneY/Expansion.lean](../../OneY/Expansion.lean) |
| one-step expansion | `ZeroY.ExpansionStep` | [ZeroY/Transport.lean](../../ZeroY/Transport.lean) |
| expansion and the lexicographic order; bodies of final theorems 2–4 | `exprLt_of_step`, `generated_strictWellOrder`, … | [OneY/Dynamics.lean](../../OneY/Dynamics.lean) |
