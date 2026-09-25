[← Back](README.md) | [English](05-1y-mountain.md) | [Japanese](../05-1y-mountain.md)

# The 1-Y sequence and its mountain

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded, the lexicographic order is not well-founded |

This note explains the definitions of 1-Y sequences and their expansion. The definitions are Phyrion's.

The values in the examples were computed by a computer from these definitions (2026-09-23).

## 1. Expressions

**Definition (expression).** An **expression** is a finite sequence of positive integers $`s = (s_0, \ldots, s_{n-1})`$ ($`n \in \mathbb N`$) that is empty or has $`s_0 = 1`$.

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

**Definition (layer).** The mountain of §2 and §3 is called **layer 0**. From the mountain of layer $`k`$, the values and parents of row 0 of layer $`k+1`$ are defined by the three definitions below. The rows from 1 up of layer $`k+1`$ are built by the same rules as in §3. The resulting mountain is called **layer $`k+1`$**. The 1-Y mountain is the stack of layers $`0, 1, 2, \ldots`$.

In the three definitions below, heights and top values (§3) are those of layer $`k`$.

**Definition (row-0 values of layer k+1).** The row-0 value of column $`c`$ in layer $`k+1`$ is defined to be the top value of $`c`$ in layer $`k`$.

**Definition (candidate parent).** Let $`h`$ be the height of column $`c`$. If $`h \gt 0`$, the **candidate parent** of $`c`$ is defined to be the largest ancestor of $`c`$ in row $`h - 1`$ of layer $`k`$ whose height is $`h`$ or $`h - 1`$. If $`h = 0`$, or no such ancestor exists, there is no candidate parent. Candidate parents point to the left, so they form a forest (§2).

**Definition (row-0 parents of layer k+1).** The row-0 parent of column $`c`$ in layer $`k+1`$ is defined to be the largest ancestor $`p`$ of $`c`$ in the forest of candidate parents with $`0 \lt v(p) \lt v(c)`$, where $`v`$ is the row-0 value of layer $`k+1`$. If there is none, there is no parent. This is the rule "parents of row $`r+1`$" of §3, with the forest replaced by the forest of candidate parents and the values by the top values.

Column values decrease from layer to layer, so $`\max(1, \max_i s_i)`$ layers suffice.

**Example.** $`s = (1, 3)`$.

| layer 0 | column 0 | column 1 |
|---|---|---|
| row 1 | 0 | 2 |
| row 0 | 1 | 3 ← 0 |

In layer 0, column 0 has height 0 and top value 1. Column 1 has height 1 and top value 2 (in row 1 the ancestor of column 1 is column 0, whose value is 0, so it is not a parent).

- Row-0 values of layer 1: the top values $`(1, 2)`$.
- Candidate parents: column 0 has height 0, so it has none. Column 1 has height $`h = 1`$; its ancestor in row $`h - 1 = 0`$ is column 0, whose height is $`0 = h - 1`$. So the candidate parent of column 1 is column 0.
- Row-0 parents of layer 1: the ancestor of column 1 in the forest of candidate parents is column 0, and $`0 \lt 1 \lt 2`$, so the parent is column 0.

| layer 1 | column 0 | column 1 |
|---|---|---|
| row 1 | 0 | 1 |
| row 0 | 1 | 2 ← 0 |

The top values of layer 1 are $`(1, 1)`$, so the row-0 values of layer 2 are $`(1, 1)`$. No $`p`$ has $`0 \lt v(p) \lt 1`$, so layer 2 has no parents.

For $`(1, 2, 4, 3)`$ all top values of layer 0 are 1, so layers 1 and above have no parents.

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
- Bad root $`z`$: build an expression of length $`x + N \cdot (x - z)`$. The block of columns $`z`$ to $`x - 1`$ (length $`x - z`$) is copied $`N`$ times. The values are not copied directly. The mountain (the parent forests) of each layer is copied, and the values are rebuilt from it.

**Definition (block).** If there is a bad root $`z`$, then for $`i = 0, 1, \ldots, N`$ the columns $`z + i \cdot (x - z)`$ to $`z + (i+1) \cdot (x - z) - 1`$ of $`s[N]`$ form **block $`i`$**. Block 0 is the original block, and blocks $`1, \ldots, N`$ are its copies. $`s[N]`$ is the columns $`0, \ldots, z - 1`$ followed by blocks $`0, \ldots, N`$. For example, in $`(1, 2, 2)[2] = (1, 2, 1, 2, 1, 2)`$ we have $`z = 0`$, $`x = 2`$, and blocks 0, 1, 2 are the columns $`\{0, 1\}`$, $`\{2, 3\}`$, $`\{4, 5\}`$.

**Example ($`(1, 2, 4, 8, 10, 8)[2]`$).** We compute it step by step.

1. **The original mountain.** Built by §2–§4. The row-0 values of layer 1 are $`(1, 1, 1, 1, 1, 1)`$, and there are no parents from layer 1 up. So only the mountain of layer 0 matters. In the table, "$`v \leftarrow p`$" means value $`v`$ with parent column $`p`$.

   | layer 0 | column 0 | column 1 | column 2 | column 3 | column 4 | column 5 |
   |---|---|---|---|---|---|---|
   | row 3 | 0 | 0 | 0 | 1 | 0 | 1 |
   | row 2 | 0 | 0 | 1 | 2 ← 2 | 1 | 2 ← 2 |
   | row 1 | 0 | 1 | 2 ← 1 | 4 ← 2 | 2 ← 1 | 4 ← 2 |
   | row 0 | 1 | 2 ← 0 | 4 ← 1 | 8 ← 2 | 10 ← 3 | 8 ← 2 |

2. **The bad root.** The last column is $`x = 5`$, and its parent is column 2 in rows 0, 1 and 2. In row 0, $`8 \ne 4 + 1`$; in row 1, $`4 \ne 2 + 1`$; in row 2, $`2 = 1 + 1`$. So the bad root is layer 0, row 2, column $`z = 2`$. Block 0 is columns 2–4, of length $`x - z = 3`$. The length of $`s[2]`$ is $`5 + 2 \cdot 3 = 11`$; block 1 is columns 5–7 and block 2 is columns 8–10.

3. **Copy the mountain.** A column of block $`i`$ ($`i \ge 1`$) is a copy of the column at the same position in block 0. Its parents are as follows.
   - If the copied column's parent $`p`$ has $`p \lt z`$, it stays. If $`p \ge z`$, it moves right by $`3 i`$.
   - The first column of a block (the copy of column $`z`$) takes, in the rows below the bad row 2, the parent of the last column $`x`$ moved by $`3 (i - 1)`$ by the same rule (moved if it is at least $`z`$, kept if it is left of $`z`$). From row 2 up it copies the parents of column $`z`$ (none here). So its height is 2, the same as column $`z`$.

   The mountain after copying only is as follows; there are no values yet. "← $`p`$" means the parent is column $`p`$, "○" is the top row of the column (the row of its height, with no parent), and a blank is above the column's height. Columns 0–4 are the original mountain.

   | row | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
   |---|---|---|---|---|---|---|---|---|---|---|---|
   | 3 |   |   |   | ○ |   |   | ○ |   |   | ○ |   |
   | 2 |   |   | ○ | ← 2 | ○ | ○ | ← 5 | ○ | ○ | ← 8 | ○ |
   | 1 |   | ○ | ← 1 | ← 2 | ← 1 | ← 2 | ← 5 | ← 1 | ← 5 | ← 8 | ← 1 |
   | 0 | ○ | ← 0 | ← 1 | ← 2 | ← 3 | ← 2 | ← 5 | ← 6 | ← 5 | ← 8 | ← 9 |

   - Column 5: copied from column 2. In rows 0 and 1 its parent is the parent 2 of column 5 ($`x`$) moved by $`3 \cdot 0`$, i.e. 2. In row 2 it has no parent, like column 2.
   - Column 6: copied from column 3. The parent 2 is at least $`z`$, so it moves by 3 to 5.
   - Column 7: copied from column 4. The row-0 parent 3 moves to 6; the row-1 parent 1 is left of $`z`$ and stays.
   - Columns 8–10: as columns 5–7, with shift 6 (column 8 takes the parent of $`x`$ moved by 3, i.e. 5).

4. **Rebuild the values.** The top value of each column comes from the layers above. Here layer 1 is all 1, so every top value is 1. The values are set from the top row down by the formula below, where $`h(c)`$ is the height of column $`c`$.

   ```math
   v_r(c) = 1 + \sum_{u = r}^{h(c) - 1} v_u(\mathrm{par}_u(c))
   ```

   The sum is over the rows $`u`$ where $`c`$ has a parent. This is the difference $`v_{r+1}(c) = v_r(c) - v_r(\mathrm{par}_r(c))`$ of §3 run backwards.

   | row | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
   |---|---|---|---|---|---|---|---|---|---|---|---|
   | 3 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
   | 2 | 0 | 0 | 1 | 2 ← 2 | 1 | 1 | 2 ← 5 | 1 | 1 | 2 ← 8 | 1 |
   | 1 | 0 | 1 | 2 ← 1 | 4 ← 2 | 2 ← 1 | 3 ← 2 | 5 ← 5 | 2 ← 1 | 4 ← 5 | 6 ← 8 | 2 ← 1 |
   | 0 | 1 | 2 ← 0 | 4 ← 1 | 8 ← 2 | 10 ← 3 | 7 ← 2 | 12 ← 5 | 14 ← 6 | 11 ← 5 | 17 ← 8 | 19 ← 9 |

   - Column 5 (copy of column 2): height 2. Row 1 value $`1 + v_1(2) = 1 + 2 = 3`$; row 0 value $`1 + v_0(2) + v_1(2) = 1 + 4 + 2 = 7`$.
   - Column 6 (copy of column 3): height 3. Its parent is column 5 in rows 0–2 (the parent 2 of column 3 moved by 3). Row 0 value $`1 + v_0(5) + v_1(5) + v_2(5) = 1 + 7 + 3 + 1 = 12`$.
   - Column 7 (copy of column 4): height 2. Its row-0 parent is column 6 (the parent 3 of column 4 moved), and its row-1 parent is column 1 (kept, since $`1 \lt z`$). Row 0 value $`1 + v_0(6) + v_1(1) = 1 + 12 + 1 = 14`$.

   So $`(1, 2, 4, 8, 10, 8)[2] = (1, 2, 4, 8, 10, 7, 12, 14, 11, 17, 19)`$. The values $`(7, 12, 14)`$ of block 1 are not those of block 0, $`(4, 8, 10)`$, plus a constant, because the mountain is copied and the values are rebuilt, instead of copying the values.

The table lists the expansions of a few expressions.

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

1. Theorem 1: the one-step expansion relation is well-founded.
2. Theorem 2: the set of expressions reachable from a seed is well-ordered by the lexicographic order.
3. Theorem 3: for every expression, the set of its descendants is well-ordered by the lexicographic order.
4. Theorem 4: however the copy counts are chosen, repeated expansion reaches the empty expression.

Theorems 2–4 follow from Theorem 1 by combinatorial arguments only. The proof of Theorem 1 is the topic of [06](06-combinatorial-layer.md) and the later notes.

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Notation", "The four final theorems" | expressions, $`s[N]`$, $`\to^{*}`$, the four theorems |
| [notes/01-design.md](../../notes/01-design.md) §2.1 (Japanese) | the expansion $`s[N]`$ and the diagram of an expression ([06](06-combinatorial-layer.md) §1) |
