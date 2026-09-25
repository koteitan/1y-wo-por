[← Back](README.md) | [English](06-combinatorial-layer.md) | [Japanese](../06-combinatorial-layer.md)

# Phyrion's combinatorial layer

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded, accessible, well-founded induction (§1, §2) |
| [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md) | the notation $`(A; P_1, \ldots)`$ for structures (§1) |
| [05 The 1-Y sequence and its mountain](05-1y-mountain.md) | expression, layer, row, parent, parent–child edge, root of a component, bad root, expansion, block |

This note explains the combinatorial layer of Phyrion's proof. This layer takes a set $`\alpha`$, an order $`\lt`$, a domain $`D`$ and a relation $`R`$ as arguments (§2), does not use what the elements of $`\alpha`$ are, and proves well-foundedness of expansion from six hypotheses about them. This repository uses the theorem of this layer as it is.

## 1. Diagrams

**Definition (atom).** An **atom** is a 4-tuple of natural numbers $`e = (k, r, p, q) \in \mathbb N^4`$. It represents one parent–child edge ([05](05-1y-mountain.md) §3).

- $`k \in \mathbb N`$: the layer number.
- $`r \in \mathbb N`$: the column number of the root, that is, the root of the child's component in the row of the edge. It is not a row number. [05](05-1y-mountain.md) wrote rows as $`r`$, but in this note $`r`$ is the root column and rows are written $`\ell`$.
- $`p \in \mathbb N`$: the column number of the parent.
- $`q \in \mathbb N`$: the column number of the child.

They are all numbers (natural numbers). The labels attached to columns are defined in §2.

It is **valid** for size $`n`$ if $`r \le p \lt q \lt n`$.

**Definition (diagram).** A **diagram** is a size $`n`$ together with a finite list of valid atoms. $`n \in \mathbb N`$ is the number of columns, and the columns are numbered $`0, 1, \ldots, n - 1`$. We write $`e \in G`$ when $`e`$ is in the list of atoms of the diagram $`G`$.

- In the diagram of an expression $`s = (s_0, \ldots, s_{n-1})`$, $`n`$ is the length of the expression.
- Every row of every layer of the mountain has the same columns $`0, \ldots, n - 1`$. The number of columns does not change from row to row. Higher rows seem to have fewer columns only because a column of value 0 is read as "not in that row" ([05](05-1y-mountain.md) §3); such a column keeps its number.

**Definition (prefix).** Let $`m \le n`$. The **prefix of size $`m`$** of a diagram $`G`$ of size $`n`$ is the diagram of size $`m`$ that keeps only the atoms $`(k, r, p, q)`$ of $`G`$ with $`q \lt m`$.

**The diagram of an expression.** The diagram $`G(s)`$ of an expression $`s`$ has one atom for each parent–child edge in every layer and every row. If column $`c`$ has parent $`p`$ in layer $`k`$, row $`\ell`$, it contains the atom

```math
(k,\ \mathrm{root}_{k,\ell}(c),\ p,\ c)
```

where $`\mathrm{root}_{k,\ell}(c)`$ is the root of the component of $`c`$ in layer $`k`$, row $`\ell`$ ([05](05-1y-mountain.md) §3).

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

Choose one structure $`(\alpha; \lt, D, R)`$ and keep it fixed (for the notation of structures see [03](03-sigma1-elementary.md) §1). All definitions below are relative to this structure.

- $`\alpha`$ is the domain. Its elements are called **labels**. A representation below attaches one label to each column of a diagram.
- $`\lt`$ is an order on $`\alpha`$.
- $`D`$ is a subset of $`\alpha`$, the labels that may be used. $`D(x)`$ means $`x \in D`$.
- $`R(k, \eta, a, b)`$ is a relation of four arguments: $`k`$ is a natural number and $`\eta, a, b`$ are elements of $`\alpha`$. In the definition of a representation below, $`\eta`$ receives the label of the root column ([05](05-1y-mountain.md) §3), $`a`$ the label of the parent, and $`b`$ the label of the child. That is why $`\eta`$ is called the **root label** (it is an element of $`\alpha`$, not a column number). Read $`R(k, \eta, a, b)`$ as "in layer $`k`$ with root label $`\eta`$, $`a`$ is stable into $`b`$". This is only a reading; what $`R`$ is does not matter here (§7).

**Definition (representation).** A function $`f : \mathbb N \to \alpha`$ is a **representation** of a diagram $`G`$ of size $`n`$ if the following three conditions hold.

1. $`D(f(i))`$ for $`i \lt n`$.
2. $`f(i) \lt f(j)`$ for $`i \lt j \lt n`$.
3. $`R(k, f(r), f(p), f(q))`$ for each atom $`(k, r, p, q)`$ of $`G`$.

$`f(i)`$ is called the label of column $`i`$.

**Example.** A representation of the diagram of $`(1, 2, 4)`$ is an $`f`$ with

```math
f(0) \lt f(1) \lt f(2), \quad R(0, f(0), f(0), f(1)), \quad R(0, f(0), f(1), f(2)), \quad R(0, f(1), f(1), f(2))
```

## 3. Demands toward the top

**Definition (top atom).** A **top atom** is a triple of natural numbers $`d = (k, r, p)`$; it is valid for size $`n`$ if $`r \le p \lt n`$. A label $`\beta \in \alpha`$ of a point outside the diagram is called a **top**. For a function $`f : \mathbb N \to \alpha`$, $`d`$ holds for the top $`\beta`$ if $`R(k, f(r), f(p), \beta)`$.

A top atom is an edge to a point $`\beta`$ outside the diagram. In an expansion ([05](05-1y-mountain.md) §6), the label of the old last column plays the role of $`\beta`$.

**Difference from ordinary atoms.** A top atom is an atom $`(k, r, p, q)`$ with the child $`q`$ removed. The child is not a column of the diagram but a point outside it, whose label we write $`\beta`$.

| | atom | top atom |
|---|---|---|
| form | $`(k, r, p, q)`$ | $`(k, r, p)`$ |
| child | column $`q`$ of the diagram | a point outside the diagram (label $`\beta`$) |
| valid | $`r \le p \lt q \lt n`$ | $`r \le p \lt n`$ |
| holds | $`R(k, f(r), f(p), f(q))`$ | $`R(k, f(r), f(p), \beta)`$ |

**Example 1 (the form).** The atoms of $`(1, 2, 4)`$ are $`(0, 0, 0, 1)`$, $`(0, 0, 1, 2)`$, $`(0, 1, 1, 2)`$ (§1). Remove the last column 2 and consider the diagram of columns 0, 1 only (size 2). The two edges to column 2 now have their child outside the diagram, so we write them as top atoms.

- $`(0, 0, 1)`$: it holds when $`R(0, f(0), f(1), \beta)`$.
- $`(0, 1, 1)`$: it holds when $`R(0, f(1), f(1), \beta)`$.

Here $`\beta = f(2)`$ is the label of column 2, which is now outside.

**Definition (demand).** A top atom $`d = (k_d, r_d, p_d)`$ that is passed to finite reflection of §4 separately from the diagram $`G`$ is called a **demand**. A finite list of demands is written $`\mathrm{needs}`$. Finite reflection guarantees that the demands that hold for the top $`\beta`$ before the reflection hold for the new top $`f(\mathrm{cut})`$ after it ($`\mathrm{cut}`$ is the cut defined below).

**Steps of an expansion.** Consider expanding an expression $`s`$ to $`s[N]`$ (expansion: [05](05-1y-mountain.md) §6). Let $`x`$ be the last column of $`s`$ and $`y`$ the bad root (layer $`K`$, row $`\ell`$). From column $`y`$ on, $`s[N]`$ is divided into blocks $`0, 1, \ldots, N`$ ([05](05-1y-mountain.md) §6). In §6, a representation of $`G(s[N])`$ is built from one of $`G(s)`$ by adding the blocks one at a time. For $`i = 0, 1, \ldots, N - 1`$, the procedure that adds block $`i + 1`$ is called **step $`i`$**.

**Demands in an expansion.** At each step $`i`$, $`\mathrm{needs}`$ is built as follows.

- At step $`i`$, the first column of block $`i`$, $`\mathrm{cut} := y + i \cdot (x - y)`$, is called the **cut**.
- The column to be added next, $`m := x + i \cdot (x - y)`$ (the first column of block $`i + 1`$), is taken as the top.
- The edges from column $`m`$ to its parents in the mountain of $`s[N]`$ become demands in this range only:
  - layer $`k \lt K`$: the edges of all rows;
  - layer $`K`$: the edges of the rows below row $`\ell`$;
  - layer $`k \gt K`$: none.

The edge of layer $`K`$, row $`\ell`$ is the edge of the bad root, and it is not made a demand. Instead, the relation $`R(K, \theta, f(\mathrm{cut}), \beta)`$ is passed to finite reflection of §4 (hypothesis 5). A relation of this form is called the **control relation**, and $`\theta \in \alpha`$ is its root label. At step 0, $`\theta = f(\rho)`$, where $`\rho`$ is the root of the component of $`x`$ in layer $`K`$, row $`\ell`$ ([05](05-1y-mountain.md) §3). The $`\theta`$ of later steps is described in §6.

**Example 2 (step 0 of the expansion of $`(1, 2, 4)`$).** $`x = 2`$, the bad root is $`y = 1`$ (layer $`K = 0`$, row $`\ell = 1`$), and $`s[N] = (1, 2, \ldots, N + 2)`$. Look at step $`i = 0`$.

- The diagram $`G`$ is the diagram of $`(1, 2)`$: size 2, atom $`(0, 0, 0, 1)`$. $`f`$ is the original representation, $`\beta = f(2)`$, and the cut is $`\mathrm{cut} = y = 1`$.
- The top is column $`m = 2`$. In the mountain of $`s[N]`$, the parent of column 2 is column 1 in row 0 (root column 0), and there is none in row 1. We look only at the rows $`0 \lt \ell = 1`$ of layer 0, so $`\mathrm{needs} = [(0, 0, 1)]`$. It holds for $`\beta = f(2)`$ by the original atom $`(0, 0, 1, 2)`$.
- The original atom $`(0, 1, 1, 2)`$ is the edge of the bad root and is not a demand. It becomes the control relation $`R(0, f(1), f(1), f(2))`$. The root of column 2 in layer 0, row 1 is column 1, so $`\rho = 1`$ and $`\theta = f(1)`$.
- The demand $`(0, 0, 1)`$ is admissible (defined in §4): $`k_d = 0 = K`$, $`r_d = 0 \lt \mathrm{cut} = 1`$, and $`f(0) \lt f(1) = \theta`$.
- The $`g`$ given by finite reflection (§4) has $`g(0) = f(0)`$ and $`g(1) \lt f(1)`$, and the demand holds for the top $`f(\mathrm{cut}) = f(1)`$, that is, $`R(0, g(0), g(1), f(1))`$.
- Column 2 of the new diagram gets $`f(\mathrm{cut}) = f(1)`$ (§6), so the labels are $`(g(0), g(1), f(1))`$. The atoms of the diagram of $`(1, 2, 3)`$ are $`(0, 0, 0, 1)`$ and $`(0, 0, 1, 2)`$, and the latter is exactly the demand above. In this way a demand becomes an edge of the new diagram.

**Definition (bound).** Let $`n \in \mathbb N`$, $`f : \mathbb N \to \alpha`$ and $`\beta \in \alpha`$. $`f`$ is **bounded by** $`\beta`$ if $`f(i) \lt \beta`$ for all $`i \lt n`$.

## 4. Finite reflection

**Definition (admissible demand).** For a layer $`K \in \mathbb N`$, a cut $`\mathrm{cut} \in \mathbb N`$, a root label $`\theta \in \alpha`$ and a function $`f : \mathbb N \to \alpha`$, a top atom $`d = (k_d, r_d, p_d)`$ is **admissible** if one of the following holds.

- $`k_d \lt K`$ (a lower layer).
- $`k_d = K`$ and $`r_d \lt \mathrm{cut}`$ and $`f(r_d) \lt \theta`$ (the same layer, the root before the cut, and the root's label below $`\theta`$).

**Example.** Look at step 0 of an expansion ("Steps of an expansion" of §3). $`K`$, $`\mathrm{cut}`$ and $`\theta`$ are determined by the bad root ("Demands in an expansion" of §3). $`f`$ is the original representation, whose labels increase with the column.

- $`(1, 2, 4)`$: the bad root is layer $`K = 0`$, row 1, column $`y = 1`$, so $`\mathrm{cut} = 1`$ and $`\theta = f(1)`$ (Example 2 of §3).
- $`(1, 3)`$: the bad root is layer $`K = 1`$, row 0, column $`y = 0`$ ([05](05-1y-mountain.md) §5), so $`\mathrm{cut} = 0`$. The root of the last column 1 in layer 1, row 0 is column 0, so $`\theta = f(0)`$. The demands are the layer-0 edges from column 1 of $`s[N]`$ to its parents. In $`(1, 3)[2] = (1, 2, 4)`$, the parent of column 1 is column 0 in row 0 of layer 0 (root column 0), and there is none in row 1. So $`\mathrm{needs} = [(0, 0, 0)]`$.

| Expression | Top atom $`d`$ | Admissible? | Reason |
|---|---|---|---|
| $`(1, 2, 4)`$ | $`(0, 0, 1)`$ | yes (second case) | $`k_d = 0 = K`$, $`r_d = 0 \lt 1 = \mathrm{cut}`$, $`f(0) \lt f(1) = \theta`$ |
| $`(1, 2, 4)`$ | $`(0, 1, 1)`$ | no | $`k_d = K`$, but $`r_d = 1`$ is not before $`\mathrm{cut} = 1`$ |
| $`(1, 3)`$ | $`(0, 0, 0)`$ | yes (first case) | $`k_d = 0 \lt 1 = K`$; no condition on the root or labels is needed |
| $`(1, 3)`$ | $`(1, 0, 0)`$ | no | $`k_d = K`$, but $`r_d = 0`$ is not before $`\mathrm{cut} = 0`$ |

The two non-admissible ones are the edges of the bad roots ($`(0, 1, 1, 2)`$ and $`(1, 0, 0, 1)`$) with the child removed. These edges are not made demands; they are passed as the control relation.

**Definition (finite reflection).** A structure $`(\alpha; \lt, D, R)`$ (§2) satisfies **finite reflection** if the following holds.

For every diagram $`G`$, function $`f : \mathbb N \to \alpha`$, natural numbers $`\mathrm{cut}, K`$, labels $`\theta, \beta \in \alpha`$ and list $`\mathrm{needs}`$ of top atoms, assume that all of the following eight hypotheses hold.

1. $`G`$ is a diagram of size $`n`$ and $`\mathrm{cut} \lt n`$.
2. $`f`$ is a representation of $`G`$.
3. $`D(\beta)`$.
4. $`f`$ is bounded by $`\beta`$.
5. The control relation (§3) $`R(K, \theta, f(\mathrm{cut}), \beta)`$ holds.
6. Every element of the list of demands $`\mathrm{needs}`$ is valid.
7. Every element is admissible.
8. Every element holds for the top $`\beta`$.

Then there is a function $`g : \mathbb N \to \alpha`$ with the following four properties.

1. $`g`$ is a representation of $`G`$.
2. $`g(i) = f(i)`$ for $`i \lt \mathrm{cut}`$.
3. $`g`$ is bounded by $`f(\mathrm{cut})`$.
4. Every demand holds for the top $`f(\mathrm{cut})`$.

**Meaning.** The labels left of the cut stay. The labels from the cut on are replaced so that all of them lie below $`f(\mathrm{cut})`$. The edge conditions and the demands toward the top (with the top changed from $`\beta`$ to $`f(\mathrm{cut})`$) are kept. This is exactly the shape of finite reflection in [04](04-patterns-of-resemblance.md) §3.

## 5. The six hypotheses

The main theorem of the combinatorial layer (below, the **entry theorem**) has these six hypotheses. The letters in the table range over $`k \in \mathbb N`$ and $`\eta, \eta', a, b, c, p \in \alpha`$.

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

**Definition (last label).** For a representation $`f`$ of a diagram of size $`n \gt 0`$, the label $`f(n-1)`$ of the last column is called the **last label** of $`f`$.

**Theorem (the last label goes down).** Suppose $`G(s)`$ has a representation with last label $`\beta`$, and $`s[N]`$ is nonempty. Then for some $`b \lt \beta`$, $`G(s[N])`$ has a representation with last label $`b`$.

**Outline of the proof.** Let $`x`$ be the last column of $`s`$, and call $`G(s)`$ the old diagram. Let $`f`$ be a representation of $`G(s)`$ with last label $`\beta = f(x)`$.

1. No bad root: $`s[N]`$ is $`s`$ without its last column. The new diagram is a prefix of the old one. The same $`f`$ is a representation, and the new last label $`f(x-1)`$ is below $`f(x) = \beta`$.
2. Bad root $`y`$ (layer $`K`$, row $`\ell`$):
   - For $`i = 0, 1, \ldots, N`$, the prefix (§1) of $`G(s[N])`$ of size $`x + i \cdot (x - y)`$ is called diagram $`i`$. Diagram $`i`$ consists of the edges of columns $`0, \ldots, y - 1`$ and blocks $`0, \ldots, i`$. Diagram $`N`$ is $`G(s[N])`$ itself.
   - Diagram $`i = 0`$ has size $`x`$ and is a prefix of the old diagram (it does not contain the last column $`x`$). $`f`$ is a representation of it, bounded by $`\beta = f(x)`$.
   - The edge at the bad root gives $`R(K, f(\rho), f(y), f(x))`$, where $`\rho`$ is the root of the component of $`x`$ in layer $`K`$, row $`\ell`$. This is the first control relation, with root label $`\theta = f(\rho)`$.
   - Let $`f_i`$ be the representation of diagram $`i`$ ($`f_0 = f`$). Step $`i`$ (§3), going from diagram $`i`$ to diagram $`i + 1`$, uses finite reflection once. The cut is the start of block $`i`$, $`\mathrm{cut} = y + i \cdot (x - y)`$.
   - Hypothesis 8 of finite reflection (every demand holds for the top $`\beta`$) is checked with the edges $`(k, r, p, x)`$ from the old last column $`x`$ to its parents. Removing the child $`x`$ from such an edge gives a top atom $`(k, r, p)`$ (built as in Example 1 of §3). Every diagram of every step is bounded above by $`\beta = f(x)`$, so no column of a diagram has the label $`\beta`$. So these top atoms remain edges to the outside point $`\beta`$.
     - At $`i = 0`$ these top atoms hold for $`\beta`$, because the edges $`(k, r, p, x)`$ hold in the original representation.
     - When a step is taken, the root and parent column numbers of these top atoms are moved in the same way as the labels. Columns left of the cut stay; columns from the cut on move to the new block. The moved columns carry their old labels, so they keep holding for $`\beta`$.
     - For each demand $`d = (k, r_d, p)`$ of step $`i`$ ("Demands in an expansion" of §3), one of these moved top atoms has the same layer and parent; call it $`\tau = (k, r_\tau, p)`$. The roots are in one of two cases.
       - $`r_d = r_\tau`$: $`d`$ and $`\tau`$ are equal, so $`d`$ holds for $`\beta`$.
       - $`r_d \lt \mathrm{cut} \le r_\tau`$ (the root of the demand lies in an earlier block than the root of $`\tau`$): the labels satisfy $`f_i(r_d) \lt f_i(r_\tau)`$. Weakening turns $`R(k, f_i(r_\tau), f_i(p), \beta)`$ into $`R(k, f_i(r_d), f_i(p), \beta)`$.
   - The control relation carries over in the same way. Let the control relation of step $`i`$ be $`R(K, f_i(\rho_i), f_i(\mathrm{cut}), \beta)`$ ($`\rho_0 = \rho`$, $`\rho_i \le \mathrm{cut}`$). For the next step, $`\rho_{i+1}`$ is the column $`\rho_i`$ moved in the same way as above, and the cut becomes the start of the next block. Both columns carry the old labels $`f_i(\rho_i)`$ and $`f_i(\mathrm{cut})`$ unchanged, so the same relation is the control relation of the next step. Its root label is $`\theta = f_{i+1}(\rho_{i+1})`$.
   - Let $`m`$ be the size of diagram $`i`$. The $`g`$ from the reflection equals $`f_i`$ left of the cut and lies entirely below $`f_i(\mathrm{cut})`$. The new diagram has $`m + (m - \mathrm{cut})`$ columns. Column $`c \lt m`$ gets $`g(c)`$, and column $`c \ge m`$ gets the old label $`f_i(\mathrm{cut} + c - m)`$. So $`f_i(\mathrm{cut}), \ldots, f_i(m-1)`$ appear unchanged at the right end. The labels of $`g`$ and $`f_i`$ spliced this way form a representation of the diagram that is one block longer. The atoms of the new diagram are of three kinds, and each holds for the spliced labels.
     - Atoms of diagram $`i`$: they hold because $`g`$ is a representation.
     - Old atoms copied by moving their column numbers in the same way: the moved columns carry their old labels, so they hold. However, the root of a copied atom may be a column before the block it was copied into (a column number below $`m`$). This is the case "the root moves to an earlier block". Then the root column $`r`$ before copying lies at or after the cut. The new root's label is below $`f_i(\mathrm{cut})`$, so it is smaller than $`f_i(\mathrm{cut}) \le f_i(r)`$. Weakening is used there.
     - Edges that come from demands (child at column $`m`$): the demands hold for the top $`f_i(\mathrm{cut})`$, and column $`m`$ has the label $`f_i(\mathrm{cut})`$, so they hold.
   - After $`N`$ repetitions we get a representation of the diagram of $`s[N]`$ bounded by $`\beta`$.
   - The new last label is below $`\beta`$. $`\square`$

**Where the six hypotheses are used.**

| Hypothesis | Where |
|---|---|
| well-foundedness | the induction on the last label |
| transitivity | order and bound of the spliced labels |
| strictness | $`f(\mathrm{cut}) \lt \beta`$ from the control relation |
| weakening | edges whose root moves to an earlier block, and demands with $`r_d \lt r_\tau`$ |
| finite reflection | once per block |
| initial representation | the start of the induction |

**Theorem (well-foundedness by a decreasing value).** Let $`X`$ be a set, $`\to`$ a binary relation on $`X`$, and $`(L, \lt)`$ a well-founded order. Suppose a relation $`\mathrm{valid}(s, a)`$ between $`s \in X`$ and $`a \in L`$ satisfies:

- every $`s \in X`$ has an $`a \in L`$ with $`\mathrm{valid}(s, a)`$;
- if $`\mathrm{valid}(s, a)`$ and $`s \to t`$, then $`\mathrm{valid}(t, b)`$ for some $`b \lt a`$.

Then $`\to`$ is well-founded, that is, there is no infinite sequence $`s_0 \to s_1 \to s_2 \to \cdots`$.

**Proof.** By well-founded induction on $`a`$ ([02](02-well-founded.md) §2), show "if $`\mathrm{valid}(s, a)`$ then $`s`$ is accessible ([02](02-well-founded.md) §1)". If $`s \to t`$, there is $`b \lt a`$ with $`\mathrm{valid}(t, b)`$, so $`t`$ is accessible by the induction hypothesis. $`\square`$

The $`a`$ attached to $`s`$ need not be unique. In 1-Y, one expression has many representations.

**Well-foundedness.** By well-founded induction on $`\beta`$, show "if $`G(s)`$ has a representation with last label $`\beta`$, then $`s`$ is accessible". This is the form of the theorem above. The empty expression has no one-step expansion and is handled separately. By the initial representation every expression gets a first label. Hence the expansion relation is well-founded.

The theorem above is applied as follows.

| General form | 1-Y |
|---|---|
| element of $`X`$ | expression $`s`$ |
| $`s \to t`$ | nontrivial one-step expansion ($`t = s[N] \ne s`$) |
| $`(L, \lt)`$ | the order of labels $`(\mathrm{Ord}, \lt)`$ |
| $`\mathrm{valid}(s, a)`$ | the diagram of $`s`$ has a representation whose last label is $`a`$ |

## 7. What remains for the semantic layer

The combinatorial layer does not ask why finite reflection holds. Supplying $`(\alpha; \lt, D, R)`$ with the six hypotheses is the job of the **semantic layer**.

- Phyrion's semantic layer: it gives a $`D`$ and an $`R`$ different from those of this repository.
- The semantic layer of this repository: $`\alpha = \mathrm{Ord}`$, $`D = \mathrm{True}`$ ($`D(x)`$ holds for every $`x`$), and $`R`$ is the relation of [07 The relation R](07-relation-r.md). The proofs are in [09 Discharging the obligations](09-obligations.md).

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Shape of the proof", "Where the six hypotheses go" | the two layers and the table of the six hypotheses |
| [notes/01-design.md](../../notes/01-design.md) §2 (Japanese) | entry theorem, the six hypotheses, table of obligations, how the combinatorial layer uses the hypotheses |
