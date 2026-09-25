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
- Bad root (§5) at layer $`K`$, row $`d`$, column $`z`$: let $`L := x - z`$, and build the expression $`s[N]`$ of length $`W := x + N L`$ by steps 1 and 2 below. The values are not copied directly; the mountain of each layer is copied, and the values are rebuilt from it.

**Definition (block).** If there is a bad root $`z`$, then for $`i = 0, 1, \ldots, N`$ the columns $`z + i L`$ to $`z + (i+1) L - 1`$ of $`s[N]`$ form **block $`i`$**. Block 0 is the original columns $`z, \ldots, x - 1`$, and blocks $`1, \ldots, N`$ are its copies. Every column from $`z`$ on is written uniquely as $`c = z + i L + j`$ ($`0 \le i \le N`$, $`0 \le j \lt L`$); $`i`$ is its block number and $`j`$ its position in the block. For example, in $`(1, 2, 2)[2] = (1, 2, 1, 2, 1, 2)`$ we have $`z = 0`$, $`x = 2`$, and blocks 0, 1, 2 are the columns $`\{0, 1\}`$, $`\{2, 3\}`$, $`\{4, 5\}`$.

Below, $`h_k(c)`$ is the height of column $`c`$ in layer $`k`$ (§3, §4), and $`\mathrm{par}_{k,r}(c)`$ is its parent in layer $`k`$, row $`r`$. A parent exists exactly when $`r \lt h_k(c)`$.

**Definition (shift).** For $`i \in \mathbb N`$ and a column $`p`$, let $`m_i(p) := p`$ if $`p \lt z`$, and $`m_i(p) := p + i L`$ if $`p \ge z`$. It moves a column of block 0 to the same position in block $`i`$.

**Step 1 (copy the mountain of each layer).** For each layer $`k`$, the height $`h'_k(c)`$ of each column $`c \lt W`$ of $`s[N]`$ and its parents $`\mathrm{par}'_{k,r}(c)`$ for $`r \lt h'_k(c)`$ are given by the following branches. "Unchanged" means $`h'_k(c) = h_k(c)`$ and $`\mathrm{par}'_{k,r}(c) = \mathrm{par}_{k,r}(c)`$. A column $`c \ge z`$ is written $`c = z + i L + j`$ (block $`i`$, position $`j`$).

- **Layer $`k \gt K`$ (above the bad root)**
  - $`c \lt z`$: unchanged.
  - $`c \ge z`$: copy column $`z + j`$ shifted $`i`$ times. $`h'_k(c) = h_k(z + j)`$, $`\mathrm{par}'_{k,r}(c) = m_i(\mathrm{par}_{k,r}(z + j))`$.
- **Layer $`k = K`$ (the layer of the bad root)**
  - $`c \lt x`$: unchanged.
  - $`c \ge x`$ with $`j \ge 1`$: copy column $`z + j`$ shifted $`i`$ times. $`h'_K(c) = h_K(z + j)`$, $`\mathrm{par}'_{K,r}(c) = m_i(\mathrm{par}_{K,r}(z + j))`$.
  - $`c \ge x`$ with $`j = 0`$ (the first column of a block): the height is $`h'_K(c) = h_K(z)`$. The parents depend on the row.
    - Rows $`r \lt d`$ (below the bad row): the parent of the last column $`x`$ shifted $`i - 1`$ times, $`\mathrm{par}'_{K,r}(c) = m_{i-1}(\mathrm{par}_{K,r}(x))`$.
    - Rows $`d \le r \lt h_K(z)`$: the parent of column $`z`$ as it is, $`\mathrm{par}'_{K,r}(c) = \mathrm{par}_{K,r}(z)`$.
- **Layer $`k \lt K`$ (below the bad root)**. Let $`f := h_k(z)`$ and $`e := h_k(x) - f`$ ($`e \gt 0`$). A column $`\sigma`$ **lies above $`z`$** if $`h_k(\sigma) \ge f`$ and the root of $`\sigma`$ in row $`f`$ is $`z`$.
  - $`c \lt x`$: unchanged.
  - $`c \ge x`$: first fix the source column $`\sigma`$ and the shift count $`b`$: if $`j \ge 1`$, $`\sigma := z + j`$ and $`b := i`$; if $`j = 0`$, $`\sigma := x`$ and $`b := i - 1`$.
    - $`\sigma`$ lies above $`z`$: the height is $`h'_k(c) = h_k(\sigma) + b e`$ (the part from row $`f`$ up grows by $`b e`$ rows). The parents depend on the row.
      - Rows $`r \lt f`$: $`\mathrm{par}'_{k,r}(c) = m_b(\mathrm{par}_{k,r}(\sigma))`$.
      - Rows $`f \le r \lt f + b e`$: $`\mathrm{par}'_{k,r}(c) = \mathrm{par}_{k,f}(\sigma) + b L`$.
      - Rows $`r \ge f + b e`$: $`\mathrm{par}'_{k,r}(c) = \mathrm{par}_{k,r - b e}(\sigma) + b L`$.
    - $`\sigma`$ does not lie above $`z`$: $`h'_k(c) = h_k(\sigma)`$, $`\mathrm{par}'_{k,r}(c) = m_b(\mathrm{par}_{k,r}(\sigma))`$.
    - Column $`c = x`$ has $`\sigma = x`$, $`b = 0`$, so it is unchanged in either branch.

**Step 2 (rebuild the values).** Let $`B := \max(1, \max_i s_i)`$ be the number of layers (§4). The top values $`t_k`$ of the layers are determined from the top layer down. Let $`t_{B-1}(c) := 1`$, and for $`k = B - 1, B - 2, \ldots, 0`$ define the values of the copied mountain by

```math
v^k_r(c) := t_k(c) + \sum_{u = r}^{h'_k(c) - 1} v^k_u(\mathrm{par}'_{k,u}(c)) \quad (r \le h'_k(c)), \qquad v^k_r(c) := 0 \quad (r \gt h'_k(c))
```

and, if $`k \ge 1`$, $`t_{k-1}(c) := v^k_0(c)`$. Parents are columns to the left, so the formula is computed from the left. Finally $`s[N] := (v^0_0(0), \ldots, v^0_0(W - 1))`$.

This formula is the difference $`v_{r+1}(c) = v_r(c) - v_r(\mathrm{par}_r(c))`$ of §3 run backwards: the value in the top row $`h'_k(c)`$ is the top value $`t_k(c)`$, and each row down adds the value of the parent. The row-0 values of layer $`k + 1`$ were the top values of layer $`k`$ (§4), so the top values of layer $`k`$ are the row-0 values $`v^{k+1}_0`$ of layer $`k + 1`$.

**Example 1 ($`(1, 2, 4, 8, 10, 8)[2]`$).** We follow the definition.

1. **The original mountain.** Built by §2–§4. The row-0 values of layer 1 are $`(1, 1, 1, 1, 1, 1)`$, and there are no parents from layer 1 up. So only the mountain of layer 0 matters. In the table, "$`v \leftarrow p`$" means value $`v`$ with parent column $`p`$.

   | layer 0 | column 0 | column 1 | column 2 | column 3 | column 4 | column 5 |
   |---|---|---|---|---|---|---|
   | row 3 | 0 | 0 | 0 | 1 | 0 | 1 |
   | row 2 | 0 | 0 | 1 | 2 ← 2 | 1 | 2 ← 2 |
   | row 1 | 0 | 1 | 2 ← 1 | 4 ← 2 | 2 ← 1 | 4 ← 2 |
   | row 0 | 1 | 2 ← 0 | 4 ← 1 | 8 ← 2 | 10 ← 3 | 8 ← 2 |

2. **The bad root.** The last column is $`x = 5`$, and its parent is column 2 in rows 0, 1 and 2. In row 0, $`8 \ne 4 + 1`$; in row 1, $`4 \ne 2 + 1`$; in row 2, $`2 = 1 + 1`$. So the bad root is layer 0, row 2, column $`z = 2`$. Block 0 is columns 2–4, of length $`x - z = 3`$. The length of $`s[2]`$ is $`5 + 2 \cdot 3 = 11`$; block 1 is columns 5–7 and block 2 is columns 8–10.

3. **Copy the mountain (step 1).** $`L = 3`$, $`K = 0`$, $`d = 2`$. Layer 0 is the layer of the bad root, so it is copied by the branch "layer $`k = K`$" of step 1. Layers 1 and up have no parents, so their copies have no parents.

   The mountain after copying only is as follows; there are no values yet. "← $`p`$" means the parent is column $`p`$, "○" is the top row of the column (the row of its height, with no parent), and a blank is above the column's height. Columns 0–4 are the original mountain.

   | row | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
   |---|---|---|---|---|---|---|---|---|---|---|---|
   | 3 |   |   |   | ○ |   |   | ○ |   |   | ○ |   |
   | 2 |   |   | ○ | ← 2 | ○ | ○ | ← 5 | ○ | ○ | ← 8 | ○ |
   | 1 |   | ○ | ← 1 | ← 2 | ← 1 | ← 2 | ← 5 | ← 1 | ← 5 | ← 8 | ← 1 |
   | 0 | ○ | ← 0 | ← 1 | ← 2 | ← 3 | ← 2 | ← 5 | ← 6 | ← 5 | ← 8 | ← 9 |

   - Column 5: $`5 = z + 1 \cdot 3 + 0`$, so $`i = 1`$, $`j = 0`$. Its height is $`h_0(z) = 2`$. In rows 0 and 1 ($`\lt d`$) its parent is the parent 2 of the original last column $`x = 5`$ shifted $`i - 1 = 0`$ times, $`m_0(2) = 2`$.
   - Column 6: $`i = 1`$, $`j = 1`$: a copy of column 3. Its parent is $`m_1(2) = 5`$ and its height $`h_0(3) = 3`$.
   - Column 7: $`i = 1`$, $`j = 2`$: a copy of column 4. The row-0 parent is $`m_1(3) = 6`$ and the row-1 parent is $`m_1(1) = 1`$ (kept, since $`1 \lt z`$).
   - Columns 8–10: as columns 5–7 with $`i = 2`$. Column 8 has parent $`m_1(2) = 5`$, column 9 has $`m_2(2) = 8`$, and column 10 has $`m_2(3) = 9`$ and $`m_2(1) = 1`$.

4. **Rebuild the values (step 2).** Layers 1 and up have no parents, so in every layer the values stay the top values, and $`t_0(c) = 1`$. So the values of layer 0 are given by the formula below, where $`h(c)`$ is the height of column $`c`$ in the copied mountain.

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

**Example 2 ($`(1, 3)[2]`$).** The bad root is in layer 1, and the branch "layer $`k \lt K`$" of step 1 is used.

1. **The original mountain.** As in the example of §4: column 1 of layer 0 has height 1 (parent column 0 in row 0), column 1 of layer 1 has height 1 (parent column 0 in row 0), and layer 2 has no parents.
2. **The bad root.** In layer 1, row 0, $`2 = 1 + 1`$, so the bad root is layer $`K = 1`$, row $`d = 0`$, column $`z = 0`$ (§5). $`x = 1`$, $`L = 1`$, $`W = 1 + 2 = 3`$.
3. **Copy the mountain.** The new columns are 1 and 2, both with $`j = 0`$. The source columns and shift counts used in layer 0 are $`\sigma = x = 1`$, $`b = 0`$ for column 1 and $`\sigma = 1`$, $`b = 1`$ for column 2.
   - Layer 2 (branch $`k \gt K`$): no parents.
   - Layer 1 (branch $`k = K`$): since $`j = 0`$, columns 1 and 2 have height $`h_1(z) = h_1(0) = 0`$. No parents.
   - Layer 0 (branch $`k \lt K`$): $`f = h_0(0) = 0`$ and $`e = h_0(1) - 0 = 1`$. Column 1 has $`h_0(1) \ge 0`$ and root column 0 in row 0, so it lies above $`z`$. Column 1 has $`b = 0`$ and keeps the original (height 1, row-0 parent column 0). Column 2 has $`b = 1`$, so its height grows to $`h_0(1) + 1 \cdot 1 = 2`$. Its row-0 parent ($`f \le 0 \lt f + b e = 1`$) is $`\mathrm{par}_{0,0}(1) + 1 = 1`$, and its row-1 parent ($`\ge 1`$) is $`\mathrm{par}_{0,1-1}(1) + 1 = 1`$.

   | layer 0 | column 0 | 1 | 2 |
   |---|---|---|---|
   | row 2 |   |   | ○ |
   | row 1 |   | ○ | ← 1 |
   | row 0 | ○ | ← 0 | ← 1 |

4. **Rebuild the values.** The number of layers is $`B = \max(1, 3) = 3`$, and $`t_2 = 1`$. The copied mountains of layers 2 and 1 have no parents, so $`t_1`$ and $`t_0`$ are all 1 as well. In layer 0, column 1 has $`v_1(1) = 1`$ and $`v_0(1) = 1 + v_0(0) = 2`$. Column 2 has $`v_2(2) = 1`$, $`v_1(2) = 1 + v_1(1) = 2`$, and $`v_0(2) = 1 + v_0(1) + v_1(1) = 1 + 2 + 1 = 4`$. So $`(1, 3)[2] = (1, 2, 4)`$.

**Example 3 ($`(1, 3, 9, 23)[2]`$).** The bad root is in layer 1, row 1, and in layer 0 the mountain grows by 2 rows with each copy.

1. **The original mountain.** The row-0 values of layer 2 are all 1, and there are no parents from layer 2 up.

   | layer 0 | column 0 | 1 | 2 | 3 |
   |---|---|---|---|---|
   | row 3 | 0 | 0 | 0 | 4 |
   | row 2 | 0 | 0 | 4 | 8 ← 2 |
   | row 1 | 0 | 2 | 6 ← 1 | 14 ← 2 |
   | row 0 | 1 | 3 ← 0 | 9 ← 1 | 23 ← 2 |

   | layer 1 | column 0 | 1 | 2 | 3 |
   |---|---|---|---|---|
   | row 2 | 0 | 0 | 1 | 1 |
   | row 1 | 0 | 1 | 2 ← 1 | 2 ← 1 |
   | row 0 | 1 | 2 ← 0 | 4 ← 1 | 4 ← 1 |

2. **The bad root.** The last column is $`x = 3`$. In layer 0, rows 0, 1, 2 give $`23 \ne 9 + 1`$, $`14 \ne 6 + 1`$, $`8 \ne 4 + 1`$. In layer 1, row 0 gives $`4 \ne 2 + 1`$ and row 1 gives $`2 = 1 + 1`$. So $`K = 1`$, $`d = 1`$, $`z = 1`$. $`L = 2`$ and $`W = 3 + 2 \cdot 2 = 7`$; the new columns 3, 4, 5, 6 have $`(i, j) = (1, 0)`$, $`(1, 1)`$, $`(2, 0)`$, $`(2, 1)`$.

3. **Copy the mountain.**
   - Layer 1 (branch $`k = K`$):
     - Columns 3, 5 ($`j = 0`$): height $`h_1(z) = 1`$. The row-0 parent ($`\lt d`$) is the parent 1 of $`x`$ shifted $`i - 1`$ times: $`m_0(1) = 1`$ for column 3 and $`m_1(1) = 3`$ for column 5.
     - Columns 4, 6 ($`j = 1`$): copies of column 2 shifted $`i`$ times. Height 2, parents $`m_1(1) = 3`$ and $`m_2(1) = 5`$.

   | layer 1 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 |
   |---|---|---|---|---|---|---|---|
   | row 2 |   |   | ○ |   | ○ |   | ○ |
   | row 1 |   | ○ | ← 1 | ○ | ← 3 | ○ | ← 5 |
   | row 0 | ○ | ← 0 | ← 1 | ← 1 | ← 3 | ← 3 | ← 5 |

   - Layer 0 (branch $`k \lt K`$): $`f = h_0(1) = 1`$ and $`e = h_0(3) - 1 = 2`$. Columns 2 and 3 have root column 1 in row 1, so they lie above $`z`$.
     - Column 3: $`\sigma = x`$, $`b = 0`$; unchanged.
     - Column 4: $`\sigma = 2`$, $`b = 1`$. Height $`2 + 2 = 4`$. The parent is $`m_1(1) = 3`$ in row 0, $`\mathrm{par}_{0,1}(2) + 2 = 3`$ in rows 1 and 2, and $`\mathrm{par}_{0,3-2}(2) + 2 = 3`$ in row 3.
     - Column 5: $`\sigma = x = 3`$, $`b = 1`$. Height $`3 + 2 = 5`$. The parent is column 4 in every row.
     - Column 6: $`\sigma = 2`$, $`b = 2`$. Height $`2 + 4 = 6`$. The parent is column 5 in every row.

   | layer 0 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 |
   |---|---|---|---|---|---|---|---|
   | row 6 |   |   |   |   |   |   | ○ |
   | row 5 |   |   |   |   |   | ○ | ← 5 |
   | row 4 |   |   |   |   | ○ | ← 4 | ← 5 |
   | row 3 |   |   |   | ○ | ← 3 | ← 4 | ← 5 |
   | row 2 |   |   | ○ | ← 2 | ← 3 | ← 4 | ← 5 |
   | row 1 |   | ○ | ← 1 | ← 2 | ← 3 | ← 4 | ← 5 |
   | row 0 | ○ | ← 0 | ← 1 | ← 2 | ← 3 | ← 4 | ← 5 |

4. **Rebuild the values.** There are no parents from layer 2 up, so $`t_1`$ is all 1. First the values of layer 1:

   | layer 1 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 |
   |---|---|---|---|---|---|---|---|
   | row 2 |   |   | 1 |   | 1 |   | 1 |
   | row 1 |   | 1 | 2 ← 1 | 1 | 2 ← 3 | 1 | 2 ← 5 |
   | row 0 | 1 | 2 ← 0 | 4 ← 1 | 3 ← 1 | 5 ← 3 | 4 ← 3 | 6 ← 5 |

   Its row-0 values are the top values of layer 0, $`t_0 = (1, 2, 4, 3, 5, 4, 6)`$.

   | layer 0 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 |
   |---|---|---|---|---|---|---|---|
   | row 6 |   |   |   |   |   |   | 6 |
   | row 5 |   |   |   |   |   | 4 | 10 ← 5 |
   | row 4 |   |   |   |   | 5 | 9 ← 4 | 19 ← 5 |
   | row 3 |   |   |   | 3 | 8 ← 3 | 17 ← 4 | 36 ← 5 |
   | row 2 |   |   | 4 | 7 ← 2 | 15 ← 3 | 32 ← 4 | 68 ← 5 |
   | row 1 |   | 2 | 6 ← 1 | 13 ← 2 | 28 ← 3 | 60 ← 4 | 128 ← 5 |
   | row 0 | 1 | 3 ← 0 | 9 ← 1 | 22 ← 2 | 50 ← 3 | 110 ← 4 | 238 ← 5 |

   For example, column 3 starts from the top value $`t_0(3) = 3`$: row 2 is $`3 + v_2(2) = 7`$, row 1 is $`3 + v_1(2) + v_2(2) = 13`$, and row 0 is $`3 + v_0(2) + v_1(2) + v_2(2) = 3 + 9 + 6 + 4 = 22`$. So $`(1, 3, 9, 23)[2] = (1, 3, 9, 22, 50, 110, 238)`$.

**Example 4 ($`(1, 3, 4, 2, 5, 11, 6, 8, 12, 5)[2]`$).** In layer 0, columns that lie above $`z`$ and columns that do not are mixed.

1. **The original mountain.** The row-0 values of layer 2 are all 1, and there are no parents from layer 2 up.

   | layer 0 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
   |---|---|---|---|---|---|---|---|---|---|---|
   | row 3 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
   | row 2 | 0 | 0 | 0 | 0 | 2 | 3 ← 4 | 0 | 1 | 2 ← 7 | 2 |
   | row 1 | 0 | 2 | 1 | 1 | 3 ← 3 | 6 ← 4 | 1 | 2 ← 6 | 4 ← 7 | 3 ← 3 |
   | row 0 | 1 | 3 ← 0 | 4 ← 1 | 2 ← 0 | 5 ← 3 | 11 ← 4 | 6 ← 4 | 8 ← 6 | 12 ← 7 | 5 ← 3 |

   | layer 1 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
   |---|---|---|---|---|---|---|---|---|---|---|
   | row 1 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 |
   | row 0 | 1 | 2 ← 0 | 1 | 1 | 2 ← 3 | 1 | 1 | 1 | 1 | 2 ← 3 |

2. **The bad root.** The last column is $`x = 9`$. In layer 0, row 0 has parent 3 and $`5 \ne 2 + 1`$; row 1 has parent 3 and $`3 \ne 1 + 1`$. In layer 1, row 0 has parent 3 and $`2 = 1 + 1`$. So $`K = 1`$, $`d = 0`$, $`z = 3`$. $`L = 6`$ and $`W = 9 + 2 \cdot 6 = 21`$; block 1 is columns 9–14 and block 2 is columns 15–20.

3. **Copy the mountain.**
   - Layer 1 (branch $`k = K`$): columns 9 and 15 ($`j = 0`$) have height $`h_1(3) = 0`$ and no parents. The other new columns copy columns 4–8. In layer 1 only column 4 has a parent (3), so column 10 has parent $`m_1(3) = 9`$ and column 16 has parent $`m_2(3) = 15`$.

   | layer 1 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
   | row 1 |   | ○ |   |   | ○ |   |   |   |   |   | ○ |   |   |   |   |   | ○ |   |   |   |   |
   | row 0 | ○ | ← 0 | ○ | ○ | ← 3 | ○ | ○ | ○ | ○ | ○ | ← 9 | ○ | ○ | ○ | ○ | ○ | ← 15 | ○ | ○ | ○ | ○ |

   - Layer 0 (branch $`k \lt K`$): $`f = h_0(3) = 1`$ and $`e = h_0(9) - 1 = 1`$. In row 1, columns 4, 5, 9 have root column 3 and lie above $`z`$; columns 6, 7, 8 have root column 6 and do not.
     - Columns 10, 11 ($`\sigma = 4, 5`$, $`b = 1`$): they lie above $`z`$, so they grow by 1 row, to heights 3 and 4. Column 10 has parent 9 and column 11 has parent 10 in every row.
     - Columns 12, 13, 14 ($`\sigma = 6, 7, 8`$, $`b = 1`$): they do not lie above $`z`$ and are copied as they are, with parents $`m_1(4) = 10`$, $`m_1(6) = 12`$, $`m_1(7) = 13`$.
     - Column 15 ($`j = 0`$, $`\sigma = x = 9`$, $`b = 1`$): it lies above $`z`$, so its height is $`2 + 1 = 3`$, with parent 9 in every row.
     - Columns 16–20 ($`b = 2`$): columns 16, 17 grow by 2 rows to heights 4, 5, with parents 15, 16. Columns 18, 19, 20 are copied as they are, with parents $`m_2(4) = 16`$, $`m_2(6) = 18`$, $`m_2(7) = 19`$.

   | layer 0 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
   | row 5 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ○ |   |   |   |
   | row 4 |   |   |   |   |   |   |   |   |   |   |   | ○ |   |   |   |   | ○ | ← 16 |   |   |   |
   | row 3 |   |   |   |   |   | ○ |   |   | ○ |   | ○ | ← 10 |   |   | ○ | ○ | ← 15 | ← 16 |   |   | ○ |
   | row 2 |   |   |   |   | ○ | ← 4 |   | ○ | ← 7 | ○ | ← 9 | ← 10 |   | ○ | ← 13 | ← 9 | ← 15 | ← 16 |   | ○ | ← 19 |
   | row 1 |   | ○ | ○ | ○ | ← 3 | ← 4 | ○ | ← 6 | ← 7 | ← 3 | ← 9 | ← 10 | ○ | ← 12 | ← 13 | ← 9 | ← 15 | ← 16 | ○ | ← 18 | ← 19 |
   | row 0 | ○ | ← 0 | ← 1 | ← 0 | ← 3 | ← 4 | ← 4 | ← 6 | ← 7 | ← 3 | ← 9 | ← 10 | ← 10 | ← 12 | ← 13 | ← 9 | ← 15 | ← 16 | ← 16 | ← 18 | ← 19 |

4. **Rebuild the values.** There are no parents from layer 2 up, so $`t_1`$ is all 1. First the values of layer 1:

   | layer 1 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
   | row 1 |   | 1 |   |   | 1 |   |   |   |   |   | 1 |   |   |   |   |   | 1 |   |   |   |   |
   | row 0 | 1 | 2 ← 0 | 1 | 1 | 2 ← 3 | 1 | 1 | 1 | 1 | 1 | 2 ← 9 | 1 | 1 | 1 | 1 | 1 | 2 ← 15 | 1 | 1 | 1 | 1 |

   Its row-0 values are the top values $`t_0`$ of layer 0.

   | layer 0 | column 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
   | row 5 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | 1 |   |   |   |
   | row 4 |   |   |   |   |   |   |   |   |   |   |   | 1 |   |   |   |   | 2 | 3 ← 16 |   |   |   |
   | row 3 |   |   |   |   |   | 1 |   |   | 1 |   | 2 | 3 ← 10 |   |   | 1 | 1 | 3 ← 15 | 6 ← 16 |   |   | 1 |
   | row 2 |   |   |   |   | 2 | 3 ← 4 |   | 1 | 2 ← 7 | 1 | 3 ← 9 | 6 ← 10 |   | 1 | 2 ← 13 | 2 ← 9 | 5 ← 15 | 11 ← 16 |   | 1 | 2 ← 19 |
   | row 1 |   | 2 | 1 | 1 | 3 ← 3 | 6 ← 4 | 1 | 2 ← 6 | 4 ← 7 | 2 ← 3 | 5 ← 9 | 11 ← 10 | 1 | 2 ← 12 | 4 ← 13 | 4 ← 9 | 9 ← 15 | 20 ← 16 | 1 | 2 ← 18 | 4 ← 19 |
   | row 0 | 1 | 3 ← 0 | 4 ← 1 | 2 ← 0 | 5 ← 3 | 11 ← 4 | 6 ← 4 | 8 ← 6 | 12 ← 7 | 4 ← 3 | 9 ← 9 | 20 ← 10 | 10 ← 10 | 12 ← 12 | 16 ← 13 | 8 ← 9 | 17 ← 15 | 37 ← 16 | 18 ← 16 | 20 ← 18 | 24 ← 19 |

   So $`(1, 3, 4, 2, 5, 11, 6, 8, 12, 5)[2] = (1, 3, 4, 2, 5, 11, 6, 8, 12, 4, 9, 20, 10, 12, 16, 8, 17, 37, 18, 20, 24)`$.

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
