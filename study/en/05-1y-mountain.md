[← Back](README.md) | [English](05-1y-mountain.md) | [Japanese](../05-1y-mountain.md)

# The 1-Y sequence and its mountain

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded, the lexicographic order is not well-founded |

This note explains the definitions of 1-Y sequences and their expansion. The definitions are Phyrion's.

The values in the examples were computed by a computer from these definitions (2026-09-23).

## 1. Expressions

**Definition (expression).** An **expression** is a finite sequence of positive integers $`s = (s_0, \ldots, s_{n-1})`$ that is empty or has $`s_0 = 1`$. $`n \in \mathbb N`$ is called the **length** of the expression.

- Positions are counted from 0. Entry $`i`$ is called "column $`i`$".
- A **seed** is an expression $`(1, m)`$ with an integer $`m \ge 1`$. An expression need not be obtainable from a seed by expansions (§6).
- Expressions are ordered by the lexicographic order $`\lt_{\mathrm{lex}}`$. A proper prefix is smaller. As in [02](02-well-founded.md) §1, this order is not well-founded on all expressions.

## 2. Row 0 of the mountain

From an expression $`s`$ we build, for each row $`0, 1, 2, \ldots`$, a value and a parent for every column. This table is the **mountain** of $`s`$. We write $`v_r(c)`$ for the value and $`\mathrm{par}_r(c)`$ for the parent of column $`c`$ in row $`r`$ ($`r, c \in \mathbb N`$). The values of row 0 are $`v_0(c) := s_c`$.

**Definition (forest and ancestor).** A **forest** assigns to each column $`c`$ at most one column to the left of $`c`$ as the **parent** of $`c`$. In a forest, a column reached from $`c`$ by following parents one or more times is an **ancestor** of $`c`$.

**Definition (parent in row 0).** The row-0 parent of column $`c`$ is the largest $`p`$ with $`p \lt c`$ and $`s_p \lt s_c`$. If there is none, $`c`$ has no parent. The row-0 parents form a forest.

## 3. Higher rows

From the values $`v_r`$ and parents $`\mathrm{par}_r`$ of row $`r`$ we build row $`r+1`$.

**Definition (difference).** If $`c`$ has parent $`p`$ in row $`r`$, then $`v_{r+1}(c) := v_r(c) - v_r(p)`$; otherwise $`v_{r+1}(c) := 0`$.

**Definition (parent in row r+1).** The row-$`(r+1)`$ parent of $`c`$ is the largest $`p`$ among the ancestors of $`c`$ in the forest of row-$`r`$ parents ($`\mathrm{par}_r(c)`$, $`\mathrm{par}_r(\mathrm{par}_r(c))`$, …) with $`0 \lt v_{r+1}(p) \lt v_{r+1}(c)`$.

A column with value 0 is read as "absent from that row".

**Definition (height and top value).** The **height** of column $`c`$ is the largest $`r`$ with $`v_r(c) \gt 0`$. The value in that row is the **top value**. Values strictly decrease from row to row, so the height is finite. This height of a column is unrelated to the height of a structure in [03](03-sigma1-elementary.md) §1.

**Example.** $`s = (1, 2, 4, 3)`$. In the table, "$`v \leftarrow p`$" means value $`v`$ with parent column $`p`$.

| row | column 0 | column 1 | column 2 | column 3 |
|---|---|---|---|---|
| 2 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 2 ← 1 | 1 |
| 0 | 1 | 2 ← 0 | 4 ← 1 | 3 ← 1 |

- Row 0: the largest column with a value smaller than 3 (the value of column 3) is column 1 (value 2).
- Row 1: column 3 has value $`3 - 2 = 1`$. Its row-0 ancestors are columns 1 and 0. Their row-1 values are 1 and 0, and neither satisfies $`0 \lt v \lt 1`$. So there is no parent.
- The heights are 0, 1, 2, 1 from left to right. Every top value is 1.

**Definition (edge).** If the parent of column $`c`$ in row $`r`$ is $`p`$, the pair $`(p, c)`$ is a **parent–child edge** (or just **edge**) of row $`r`$. $`p`$ is the parent and $`c`$ the child of the edge.

**Definition (root of a component).** A set of columns connected by the edges of row $`r`$ is a **component** of row $`r`$. In row $`r`$, follow parents from column $`c`$ until a column without a parent. That column is the **root** of $`c`$ in row $`r`$. If $`c`$ has no parent, its root is $`c`$ itself. Columns of the same component have the same root. In row 1 of the example, the root of column 2 is column 1.

## 4. Layers

The mountain of §2 and §3 is called **layer 0**. The 1-Y mountain builds layers $`1, 2, \ldots`$ one after another from layer 0 and stacks them. Each layer has the values of row 0 and the forest of row-0 parents. The higher rows are built by the same rules as in §3. The mountain of layer $`k`$ is simply called layer $`k`$.

**Definition (extraction).** Layer $`k+1`$ is built from layer $`k`$.

- Values: the top value of each column.
- Forest of candidate parents: for a column $`c`$ of height $`h \gt 0`$, the largest ancestor of $`c`$ in row $`h - 1`$ whose height is $`h`$ or $`h - 1`$. A column of height 0 has no candidate parent.
- Inside this forest, parents are chosen by the same rule as in row 0 (the largest ancestor with a positive, strictly smaller value). Ancestors here are ancestors in this candidate forest (§2). The chosen parents are the row-0 parents of layer $`k+1`$.

Column values decrease from layer to layer, so $`\max(1, \max_i s_i)`$ layers suffice.

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

**Definition (bad root).** Let $`x`$ be the last column. If in some layer $`k`$ and row $`r`$ the column $`x`$ has a parent $`p`$ with $`v(x) = v(p) + 1`$ ($`v`$ the values of layer $`k`$, row $`r`$), then $`p`$ is the **bad root**.

- There is at most one such $`(k, r)`$.
- If $`x`$ has a parent in row 0, a bad root exists. If it has no parent in row 0, there is no bad root.
- The position of the bad root is given as a triple (layer, row, column).

| Expression | (layer, row, column) of the bad root | Reason |
|---|---|---|
| $`(1, 2, 3)`$ | $`(0, 0, 1)`$ | row 0: $`3 = 2 + 1`$ |
| $`(1, 2, 4)`$ | $`(0, 1, 1)`$ | row 0: $`4 \ne 2 + 1`$; row 1: $`2 = 1 + 1`$ |
| $`(1, 3)`$ | $`(1, 0, 0)`$ | difference 2 in layer 0; row 0 of layer 1: $`2 = 1 + 1`$ |
| $`(1, 2, 4, 3)`$ | $`(0, 0, 1)`$ | row 0: $`3 = 2 + 1`$ |

## 6. Expansion

**Definition (expansion $`s[N]`$).** $`N \in \mathbb N`$ is the number of copies. Let $`x`$ be the last column.

- No bad root: delete the last column. $`s[N] = (s_0, \ldots, s_{x-1})`$.
- Bad root $`z`$: build an expression of length $`x + N \cdot (x - z)`$. The block of columns $`z`$ to $`x - 1`$ (length $`x - z`$) is copied $`N`$ times. The values are not copied directly. The mountain (the parent forests) of each layer is copied, and the values are rebuilt from it. This note does not give the details of the rebuilding.

**Definition (block).** If there is a bad root $`z`$, then for $`i = 0, 1, \ldots, N`$ the columns $`z + i \cdot (x - z)`$ to $`z + (i+1) \cdot (x - z) - 1`$ of $`s[N]`$ form **block $`i`$**. Block 0 is the original block, and blocks $`1, \ldots, N`$ are its copies. $`s[N]`$ is the columns $`0, \ldots, z - 1`$ followed by blocks $`0, \ldots, N`$. For example, in $`(1, 2, 2)[2] = (1, 2, 1, 2, 1, 2)`$ we have $`z = 0`$, $`x = 2`$, and blocks 0, 1, 2 are the columns $`\{0, 1\}`$, $`\{2, 3\}`$, $`\{4, 5\}`$.

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

**Definition (one-step expansion).** $`t`$ is a nontrivial one-step expansion of $`s`$ if $`s[N] = t`$ for some $`N \in \mathbb N`$ and $`t \ne s`$.

- The empty expression expands to itself. So the empty expression has no one-step expansion.
- A one-step expansion lowers the lexicographic order. But the lexicographic order is not well-founded, so this alone does not give termination.

**Definition (reachable).** If there are $`s = t_0, t_1, \ldots, t_j = t`$ ($`j \in \mathbb N`$) where each $`t_{i+1}`$ is an expansion $`t_i[N_i]`$ ($`N_i \in \mathbb N`$) of $`t_i`$, we say $`t`$ is **reachable** from $`s`$ and write $`s \to^{*} t`$. Since $`j = 0`$ is allowed, $`s`$ is reachable from $`s`$. An expression reachable from $`s`$ is a **descendant** of $`s`$.

The final theorems of this repository ([README](../../README-en.md) "The four final theorems") are:

1. Theorem 1 (well-foundedness): the one-step expansion relation is well-founded.
2. Theorem 2 (well-order from the seeds): the set of expressions reachable from a seed is well-ordered by the lexicographic order.
3. Theorem 3 (well-order of descendants): for every expression, the set of its descendants is well-ordered by the lexicographic order.
4. Theorem 4 (reaching the empty expression): however the copy counts are chosen, repeated expansion reaches the empty expression.

Theorems 2–4 follow from Theorem 1 by combinatorial arguments only. The proof of Theorem 1 is the topic of [06](06-combinatorial-layer.md) and the later notes.

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Notation", "The four final theorems" | expressions, $`s[N]`$, $`\to^{*}`$, the four theorems |
| [notes/01-design.md](../../notes/01-design.md) §2.1 (Japanese) | the expansion $`s[N]`$ and the diagram of an expression ([06](06-combinatorial-layer.md) §1) |
