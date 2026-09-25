[← Back](README.md) | [English](06-combinatorial-layer.md) | [Japanese](../06-combinatorial-layer.md)

# Phyrion's combinatorial layer

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded, accessible, termination by labels (§6) |
| [05 The 1-Y sequence and its mountain](05-1y-mountain.md) | expression, layer, row, parent, root of a component, bad root, expansion |

This note explains the part of Phyrion's proof that does not use the meaning of the labels (the combinatorial layer). This layer takes the label set $`\alpha`$, an order $`\lt`$, a domain $`D`$ and a relation $`R`$ as arguments, and proves well-foundedness of expansion from six hypotheses about them. This repository uses the theorem of this layer as it is.

## 1. Diagrams

**Definition (atom).** An **atom** is a 4-tuple of natural numbers $`e = (k, r, p, q) \in \mathbb N^4`$. It represents one parent–child edge.

- $`k \in \mathbb N`$: the layer number.
- $`r \in \mathbb N`$: the column number of the root, that is, the root of the child's component in the row of the edge. It is not a row number.
- $`p \in \mathbb N`$: the column number of the parent.
- $`q \in \mathbb N`$: the column number of the child.

None of them is a label (an ordinal); they are all numbers. Labels are attached to column numbers by a representation $`f`$ of §2.

It is **valid** for size $`n`$ if $`r \le p \lt q \lt n`$.

**Definition (diagram).** A **diagram** is a size $`n`$ together with a finite list of valid atoms. $`n`$ is the number of columns.

**The diagram of an expression.** The diagram $`G(s)`$ of an expression $`s`$ has one atom for each parent–child edge in every layer and every row. If column $`c`$ has parent $`p`$ in layer $`k`$, row $`r`$, it contains the atom

```math
(k,\ \mathrm{root}_{k,r}(c),\ p,\ c)
```

where $`\mathrm{root}_{k,r}(c)`$ is the root of the component of $`c`$ in layer $`k`$, row $`r`$.

| Expression | Atoms $`(k, r, p, q)`$ |
|---|---|
| $`(1, 2, 2)`$ | $`(0,0,0,1)`$, $`(0,0,0,2)`$ |
| $`(1, 2, 4)`$ | $`(0,0,0,1)`$, $`(0,0,1,2)`$, $`(0,1,1,2)`$ |
| $`(1, 3)`$ | $`(0,0,0,1)`$, $`(1,0,0,1)`$ |

**Example (the atoms of $`(1, 2, 4)`$).** First build the mountain of layer 0 ([05](05-1y-mountain.md) §2, §3). In the table, "$`v \leftarrow p`$" means value $`v`$ with parent column $`p`$.

| layer 0 | column 0 | column 1 | column 2 |
|---|---|---|---|
| row 2 | 0 | 0 | 1 |
| row 1 | 0 | 1 | 2 ← 1 |
| row 0 | 1 | 2 ← 0 | 4 ← 1 |

- Row 0: the parent of column 1 is the largest $`p \lt 1`$ with $`s_p \lt 2`$, which is column 0. The parent of column 2 is the largest $`p \lt 2`$ with $`s_p \lt 4`$, which is column 1.
- Row 1: the values are differences, $`v_1 = (0,\ 2 - 1,\ 4 - 2) = (0, 1, 2)`$. The only row-0 ancestor of column 1 is column 0, whose value is 0, so column 1 has no parent. The row-0 ancestors of column 2 are columns 1 and 0, and $`0 \lt v_1(1) = 1 \lt 2`$, so its parent is column 1.
- Row 2: $`v_2 = (0, 0, 2 - 1) = (0, 0, 1)`$. The only row-1 ancestor of column 2 is column 1, whose value is 0, so there is no parent.
- The heights of columns 0, 1, 2 are 0, 1, 2, and all top values are 1. Layer 1 has values $`(1, 1, 1)`$; no value is strictly smaller, so there are no parents ([05](05-1y-mountain.md) §4). Layers 1 and above have no atoms.

So the edges are the 3 edges of layer 0, and each becomes one atom. The size is $`n = 3`$.

| Edge (layer, row) | Parent $`p`$ | Child $`q`$ | How to find the root $`r`$ | Atom $`(k, r, p, q)`$ | Validity $`r \le p \lt q \lt 3`$ |
|---|---|---|---|---|---|
| layer 0, row 0 | 0 | 1 | in row 0, $`1 \to 0`$; column 0 has no parent. Root 0 | $`(0, 0, 0, 1)`$ | $`0 \le 0 \lt 1 \lt 3`$ |
| layer 0, row 0 | 1 | 2 | in row 0, $`2 \to 1 \to 0`$; column 0 has no parent. Root 0 | $`(0, 0, 1, 2)`$ | $`0 \le 1 \lt 2 \lt 3`$ |
| layer 0, row 1 | 1 | 2 | in row 1, $`2 \to 1`$; column 1 has no parent in row 1. Root 1 | $`(0, 1, 1, 2)`$ | $`1 \le 1 \lt 2 \lt 3`$ |

- An atom does not record the row number. The second and third atoms are both the edge with parent 1 and child 2, but they lie in different rows, so their roots differ (0 and 1). That is why they are different atoms.
- On the edge of the third atom, $`v_1(2) = 2 = v_1(1) + 1`$. This is the bad root of $`(1, 2, 4)`$ (layer 0, row 1, column 1) ([05](05-1y-mountain.md) §5).

**Example (the atoms of $`(1, 3)`$).** This expression also has an edge in layer 1. The mountain is the example of [05](05-1y-mountain.md) §4.

| layer 0 | column 0 | column 1 |
|---|---|---|
| row 1 | 0 | 2 |
| row 0 | 1 | 3 ← 0 |

- Row 0: the parent of column 1 is the largest $`p \lt 1`$ with $`s_p \lt 3`$, which is column 0.
- Row 1: $`v_1 = (0,\ 3 - 1) = (0, 2)`$. The only row-0 ancestor of column 1 is column 0, whose value is 0, so there is no parent.
- The heights are 0 for column 0 and 1 for column 1, and the top values are $`(1, 2)`$.

| layer 1 | column 0 | column 1 |
|---|---|---|
| row 1 | 0 | 1 |
| row 0 | 1 | 2 ← 0 |

- The values of row 0 are the top values $`(1, 2)`$ of layer 0.
- The parent candidate of column 1: column 1 has height $`h = 1`$. Its ancestor in row $`h - 1 = 0`$ of layer 0 is column 0, whose height is $`0 = h - 1`$, so column 0 is a candidate. Since $`0 \lt 1 \lt 2`$, the parent is column 0.
- Row 1: $`v_1 = (0,\ 2 - 1) = (0, 1)`$. The only row-0 ancestor of column 1 is column 0, whose value is 0, so there is no parent.
- The top values are $`(1, 1)`$. Layer 2 has values $`(1, 1)`$; no value is strictly smaller, so there are no parents.

So there are 2 edges: row 0 of layer 0 and row 0 of layer 1. The size is $`n = 2`$.

| Edge (layer, row) | Parent $`p`$ | Child $`q`$ | How to find the root $`r`$ | Atom $`(k, r, p, q)`$ | Validity $`r \le p \lt q \lt 2`$ |
|---|---|---|---|---|---|
| layer 0, row 0 | 0 | 1 | in row 0, $`1 \to 0`$; column 0 has no parent. Root 0 | $`(0, 0, 0, 1)`$ | $`0 \le 0 \lt 1 \lt 2`$ |
| layer 1, row 0 | 0 | 1 | in row 0 of layer 1, $`1 \to 0`$; column 0 has no parent. Root 0 | $`(1, 0, 0, 1)`$ | $`0 \le 0 \lt 1 \lt 2`$ |

- The two atoms have the same root, parent and child; only the layer $`k`$ differs.
- On the layer-0 edge, $`v_0(1) = 3 \ne v_0(0) + 1 = 2`$, so it gives no bad root. On the layer-1 edge, $`2 = 1 + 1`$, so column 0 is the bad root (layer 1, row 0, column 0) ([05](05-1y-mountain.md) §5).

## 2. Representations

Choose one structure of labels $`(\alpha; \lt, D, R)`$ and keep it fixed (for the notation of structures see [03](03-sigma1-elementary.md) §1). All definitions below are relative to this structure.

- $`\alpha`$ is the set of labels (the domain).
- $`\lt`$ is an order on $`\alpha`$.
- $`D`$ is a subset of $`\alpha`$, the labels that may be used. $`D(x)`$ means $`x \in D`$.
- $`R(k, \eta, a, b)`$ is a relation of four arguments: $`k`$ is a natural number and $`\eta, a, b`$ are elements of $`\alpha`$. Read it as "in layer $`k`$ with root index $`\eta`$, $`a`$ is stable into $`b`$".

**Definition (representation).** A function $`f : \mathbb N \to \alpha`$ is a **representation** of a diagram $`G`$ of size $`n`$ if the following three conditions hold.

1. $`D(f(i))`$ for $`i \lt n`$.
2. $`f(i) \lt f(j)`$ for $`i \lt j \lt n`$.
3. $`R(k, f(r), f(p), f(q))`$ for each atom $`(k, r, p, q)`$ of $`G`$.

$`f(i)`$ is called the **label** of column $`i`$.

**Example.** A representation of the diagram of $`(1, 2, 4)`$ is an $`f`$ with

```math
f(0) \lt f(1) \lt f(2), \quad R(0, f(0), f(0), f(1)), \quad R(0, f(0), f(1), f(2)), \quad R(0, f(1), f(1), f(2))
```

## 3. Demands toward the top

**Definition (top atom).** A **top atom** is $`d = (k, r, p)`$; it is valid for size $`n`$ if $`r \le p \lt n`$. It holds for a top $`\beta \in \alpha`$ if $`R(k, f(r), f(p), \beta)`$.

A top atom is an edge to a point $`\beta`$ outside the diagram. In an expansion, the label of the old last column plays the role of $`\beta`$.

**Definition (bound).** $`f`$ is **bounded by** $`\beta`$ if $`f(i) \lt \beta`$ for all $`i \lt n`$.

## 4. Finite reflection

**Definition (admissible demand).** For a layer $`K`$, a cut $`\mathrm{cut}`$ and an index $`\theta`$, a top atom $`d = (k_d, r_d, p_d)`$ is **admissible** if one of the following holds.

- $`k_d \lt K`$ (a lower layer).
- $`k_d = K`$ and $`r_d \lt \mathrm{cut}`$ and $`f(r_d) \lt \theta`$ (the same layer, the root before the cut, and the root's label below $`\theta`$).

**Definition (finite reflection).** The following holds. The hypotheses are these eight.

1. $`G`$ is a diagram of size $`n`$ and $`\mathrm{cut} \lt n`$.
2. $`f`$ is a representation of $`G`$.
3. $`D(\beta)`$.
4. $`f`$ is bounded by $`\beta`$.
5. The control relation $`R(K, \theta, f(\mathrm{cut}), \beta)`$ holds.
6. Every element of the list of demands $`\mathrm{needs}`$ is valid.
7. Every element is admissible.
8. Every element holds for the top $`\beta`$.

Then there is a $`g`$ with:

1. $`g`$ is a representation of $`G`$.
2. $`g(i) = f(i)`$ for $`i \lt \mathrm{cut}`$.
3. $`g`$ is bounded by $`f(\mathrm{cut})`$.
4. Every demand holds for the top $`f(\mathrm{cut})`$.

**Meaning.** The labels left of the cut stay. The labels from the cut on are replaced so that all of them lie below $`f(\mathrm{cut})`$. The edge conditions and the demands toward the top (with the top changed from $`\beta`$ to $`f(\mathrm{cut})`$) are kept. This is exactly the shape of finite reflection in [04](04-patterns-of-resemblance.md) §3.

## 5. The six hypotheses

The main theorem of the combinatorial layer (below, the **entry theorem**) has these six hypotheses.

| Name | Statement |
|---|---|
| well-foundedness | $`\lt`$ is well-founded |
| transitivity | $`a \lt b`$ and $`b \lt c`$ imply $`a \lt c`$ |
| strictness | $`R(k, \eta, a, b)`$ implies $`a \lt b`$ |
| weakening | $`\eta' \lt \eta`$ and $`R(k, \eta, p, c)`$ imply $`R(k, \eta', p, c)`$ |
| finite reflection | finite reflection of §4 holds for $`(\alpha; \lt, D, R)`$ |
| initial representation | for every expression $`s`$, $`G(s)`$ has a representation |

The conclusion is "the one-step expansion relation is well-founded" (Theorem 1 of [05](05-1y-mountain.md) §7).

## 6. Descent of the last label

**Definition (last representation).** If the size $`n`$ of $`G`$ is positive and $`G`$ has a representation $`f`$ with $`f(n-1) = a`$, we write $`\mathrm{Last}(G, a)`$.

**Theorem (the last label goes down).** Suppose $`G(s)`$ has a representation with last label $`\beta`$, and $`s[N]`$ is nonempty. Then for some $`b \lt \beta`$, $`G(s[N])`$ has a representation with last label $`b`$.

**Outline of the proof.** Let $`x`$ be the last column of $`s`$.

1. No bad root: $`s[N]`$ is $`s`$ without its last column. The new diagram is a prefix of the old one. The same $`f`$ is a representation, and the new last label $`f(x-1)`$ is below $`f(x) = \beta`$.
2. Bad root $`y`$ (layer $`K`$, row $`d`$):
   - The diagrams are numbered $`i = 0, 1, \ldots, N`$. Diagram $`i`$ has size $`x + i \cdot (x - y)`$.
   - Diagram $`i = 0`$ has size $`x`$ and is a prefix of the old diagram (it does not contain the last column $`x`$). $`f`$ is a representation of it, bounded by $`\beta = f(x)`$.
   - The edge at the bad root gives $`R(K, f(\rho), f(y), f(x))`$, where $`\rho`$ is the root of the component of $`x`$ in layer $`K`$, row $`d`$. This is the first control relation.
   - Going from diagram $`i`$ to diagram $`i + 1`$ uses finite reflection once. The cut is the start of block $`i`$, $`\mathrm{cut} = y + i \cdot (x - y)`$.
   - Let $`m`$ be the size of diagram $`i`$ and $`f_i`$ its labelling. The $`g`$ from the reflection equals $`f_i`$ left of the cut and lies entirely below $`f_i(\mathrm{cut})`$. The new diagram has $`m + (m - \mathrm{cut})`$ columns. Column $`c \lt m`$ gets $`g(c)`$, and column $`c \ge m`$ gets the old label $`f_i(\mathrm{cut} + c - m)`$. So $`f_i(\mathrm{cut}), \ldots, f_i(m-1)`$ appear unchanged at the right end. This gives a representation of the diagram that is one block longer.
   - After $`N`$ repetitions we get a representation of the diagram of $`s[N]`$ bounded by $`\beta`$.
   - The new last label is below $`\beta`$. $`\square`$

**Where the six hypotheses are used.**

| Hypothesis | Where |
|---|---|
| well-foundedness | the induction on the last label |
| transitivity | order and bound of the spliced labels |
| strictness | $`f(\mathrm{cut}) \lt \beta`$ from the control relation |
| weakening | edges whose root moves to an earlier block, and virtual demands |
| finite reflection | once per block |
| initial representation | the start of the induction |

**Well-foundedness.** By well-founded induction on $`\beta`$, show "if $`G(s)`$ has a representation with last label $`\beta`$, then $`s`$ is accessible". This is the form of [02](02-well-founded.md) §6. The empty expression has no one-step expansion and is handled separately. By the initial representation every expression gets a first label. Hence the expansion relation is well-founded.

## 7. What remains for the semantic layer

The combinatorial layer does not ask why finite reflection holds. Supplying $`(\alpha; \lt, D, R)`$ with the six hypotheses is the job of the **semantic layer**.

- Phyrion's semantic layer: $`D`$ is a condition corresponding to admissible ordinals, and $`R`$ is $`\Sigma_1`$ preservation of a truth tower over the constructible universe $`L`$.
- The semantic layer of this repository: $`\alpha = \mathrm{Ord}`$, $`D = \mathrm{True}`$, and $`R`$ is the relation of [07 The relation R](07-relation-r.md). The proofs are in [09 Discharging the obligations](09-obligations.md).

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Shape of the proof", "Where the six hypotheses go" | the two layers and the table of the six hypotheses |
| [notes/01-design.md](../../notes/01-design.md) §2 (Japanese) | entry theorem, the six hypotheses, table of obligations, how the combinatorial layer uses the hypotheses |
