[← Back](README.md) | [English](04-patterns-of-resemblance.md) | [Japanese](../04-patterns-of-resemblance.md)

# Patterns of resemblance

Prerequisites

| Note | Terms used here |
|---|---|
| [01 Ordinals and ω₁](01-ordinals.md) | ordinal, limit ordinal, $`\mathrm{Ord}`$ |
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded recursion, key, guarded recursion, label |
| [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md) | structures $`(\gamma; \ldots)`$, point, $`\Sigma_1`$ formulas, $`\preccurlyeq_{\Sigma_1}`$, top, top predicate (§7) |

This note explains the idea of Carlson's patterns of resemblance. It then says how [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) used it for BMS. Finally it says why this is not enough for 1-Y as it stands, and what this repository changes.

## 1. A relation whose language contains itself

**Definition (Carlson's ≤₁).** Define a relation $`\le_1`$ on ordinals by

```math
\alpha \le_1 \beta \iff \alpha \le \beta \ \land\ (\alpha; \le, \le_1) \preccurlyeq_{\Sigma_1} (\beta; \le, \le_1)
```

$`\alpha \lt_1 \beta`$ means $`\alpha \lt \beta \land \alpha \le_1 \beta`$.

**Reading.** "The shape of the ordinals below $`\alpha`$ cannot be told apart by $`\Sigma_1`$ formulas from the shape below $`\beta`$." Here the shape consists of the order and of the relation $`\le_1`$ itself.

The right side uses the relation $`\le_1`$ being defined. This looks circular, but it is a well-founded recursion on $`\beta`$.

- The domain of $`(\beta; \le, \le_1)`$ is $`\{x \mid x \lt \beta\}`$. The only $`\le_1`$ facts read there are $`x \le_1 y`$ with $`x, y \lt \beta`$.
- The truth value of $`x \le_1 y`$ has been decided at the earlier stage with key $`y \lt \beta`$.
- The same holds for $`(\alpha; \ldots)`$, since $`\alpha \le \beta`$.

Carlson studied the extension to $`\le_1, \ldots, \le_N`$ ($`\Sigma_1, \ldots, \Sigma_N`$-elementarity).

```math
\mathcal R_N = (\mathrm{Ord}; \le, \le_1, \ldots, \le_N)
```

- $`N \ge 1`$ is a natural number.
- $`\alpha \le_i \beta`$ is obtained from the definition of $`\le_1`$ by replacing $`\preccurlyeq_{\Sigma_1}`$ with elementarity for $`\Sigma_i`$ formulas. A $`\Sigma_i`$ formula starts with a block of existential quantifiers, has $`i`$ alternating blocks of existential and universal quantifiers, and then a quantifier-free formula.
- Each of the relations $`\le_1, \ldots, \le_N`$ is called a **level** of $`\mathcal R_N`$.

Reference: T. J. Carlson, Elementary patterns of resemblance, Annals of Pure and Applied Logic 108 (2001), 19–77.

## 2. Small examples

**Example 1.** For a natural number $`n \lt \beta`$, $`n \le_1 \beta`$ fails.

- If $`n \ge 1`$: $`\exists x\ (n - 1 \lt x)`$ with parameter $`n - 1`$ is true in $`\beta`$ ($`x = n`$) and false in $`n`$.
- If $`n = 0`$: $`\exists x\ (x \le x)`$ is true in $`\beta`$ and false in the empty structure $`0`$.

For the same reason, a successor ordinal $`\gamma + 1`$ is not $`\le_1`$ any larger ordinal.

**Example 2.** $`\omega \lt_1 \omega + 1`$.

By Example 1, no two distinct points below $`\omega + 1`$ are related by $`\le_1`$: pairs of natural numbers are handled by Example 1, and the only other point is $`\omega`$ itself. So in $`(\omega; \le, \le_1)`$ and $`(\omega + 1; \le, \le_1)`$, $`x \le_1 y`$ means the same as $`x = y`$. What remains is to compare the order-only structures $`(\omega; \le)`$ and $`(\omega + 1; \le)`$, and since $`\omega`$ is a limit, the example of [03](03-sigma1-elementary.md) §5 applies.

**Example 3.** If $`\beta \ge \omega + 2`$, then $`\omega \le_1 \beta`$ fails. $`\exists x\ \exists y\ (x \lt y \land x \le_1 y)`$ is true in $`\beta`$ ($`x = \omega`$, $`y = \omega + 1`$ by Example 2, both below $`\beta`$) and false in $`\omega`$ (Example 1).

$`\omega \le_1 \omega`$ holds by the definition. Hence $`\{\beta \mid \omega \le_1 \beta\} = \{\omega, \omega + 1\}`$.

In the order-only language, $`(\omega; \le) \preccurlyeq_{\Sigma_1} (\beta; \le)`$ held for every $`\beta \gt \omega`$. Putting $`\le_1`$ itself into the language makes the relation finer.

## 3. Use in termination proofs

This section uses words that later notes define, and only describes the shape. Columns of an expression, parent–child edges and expansion are defined in [05](05-1y-mountain.md); the way labels are attached and the cut are defined in [06](06-combinatorial-layer.md) §2, §3.

A termination proof for expansion attaches an ordinal label to each column and shows that expansion lowers the labels ([02](02-well-founded.md) §6). The property needed is **finite reflection**.

**The shape of finite reflection.** Let $`\alpha \lt_1 \beta`$. Suppose points $`\vec p`$ below $`\alpha`$ and points $`\vec y`$ below $`\beta`$ satisfy a condition $`\psi(\vec p, \vec y)`$ made of finitely many atomic formulas. Then there are points $`\vec y'`$ below $`\alpha`$ with the same condition $`\psi(\vec p, \vec y')`$.

**Reason.** $`\exists \vec y\ \psi(\vec p, \vec y)`$ is a $`\Sigma_1`$ formula true in $`(\beta; \ldots)`$. By $`\Sigma_1`$-elementarity it is true in $`(\alpha; \ldots)`$.

In an expansion, $`\vec y`$ is the list of old labels of the columns to be relabelled. If $`\psi`$ says "the labels at the ends of each parent–child edge satisfy $`\le_1`$ (and so on)", then the new labels $`\vec y'`$ satisfy the same edge conditions. Moreover $`\vec y'`$ lies below $`\alpha`$. In an expansion, $`\alpha`$ is the old label of the cut column, and every old label $`\vec y`$ that is replaced is $`\ge \alpha`$. So the new labels are smaller than the old ones.

**Use in bms-elem-pattern.** [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) proved termination of BMS with $`\mathcal R_N`$. The label relation of a parent–child edge in row $`k`$ is $`\lt_{k+1}`$. Finite reflection uses the levels $`\Sigma_n`$ and lemmas about continuity and cofinality. The definition of $`\mathcal R_N`$ and examples are in the note [proof/pss/03-patterns.md](https://github.com/koteitan/bms-elem-pattern/blob/main/proof/pss/03-patterns.md) of that repository.

## 4. What is missing for 1-Y

The label relation required by the 1-Y combinatorial layer ([06](06-combinatorial-layer.md)) has four arguments.

```math
R(k, \eta, a, b) \quad (k \in \mathbb N,\ \eta, a, b \in \mathrm{Ord})
```

Read it as "in layer $`k`$ with root label $`\eta`$, $`a`$ is stable into $`b`$". $`\eta`$ is the label of the root of the edge's component, an ordinal. Layers and roots of components are explained in [05](05-1y-mountain.md) §3, §4, and this reading in [06](06-combinatorial-layer.md) §2. This causes two problems.

**Problem 1: the levels are two-dimensional and transfinite.** In this repository a level is a pair $`(k, \eta)`$ of a layer $`k`$ and a root label $`\eta`$ (the level $`(k, \eta)`$ is defined in [07](07-relation-r.md) §3). The level $`(k, \eta)`$ runs lexicographically over $`\mathbb N \times \mathrm{Ord}`$. With countable labels, the levels are arranged like $`\omega \times \omega_1`$. The levels $`\Sigma_1, \ldots, \Sigma_N`$ of $`\mathcal R_N`$ are finitely many and counted by natural numbers. A transfinite $`\eta`$ cannot serve as a level number.

**Problem 2: demands toward the top.** The top $`\beta`$ is the label that the old last column had before the expansion ([06](06-combinatorial-layer.md) §3). Finite reflection must also make "relations $`R(j, v, w, \beta)`$ to the top $`\beta`$" ($`j`$ a layer, $`v`$ and $`w`$ the labels of the root and the parent) hold for the new labels (the list of demands $`\mathrm{needs}`$ of [06](06-combinatorial-layer.md) §3). $`\beta`$ is not an element of the structure $`(\beta; \ldots)`$. Writing out the definition of $`R`$ does not give a $`\Sigma_1`$ formula.

## 5. What this repository changes

As in [notes/01-design.md](../../notes/01-design.md) §3.8 (Japanese), the following changes are made.

1. **Every level is $`\Sigma_1`$.** The strength of a level is decided by the symbols in the language, not by the quantifier complexity.
2. **Top predicates ([03](03-sigma1-elementary.md) §7) are atomic symbols.** A structure of height $`\gamma`$ has the symbol $`\mathrm{Top}_j(\xi, x)`$, interpreted as "$`R(j, \xi, x, \gamma)`$". A demand toward the top becomes an atomic formula.
3. **Level $`(k, \eta)`$ decides which symbols are visible.** All top predicates of layers $`j \lt k`$ are visible. Of layer $`k`$, a top predicate $`\mathrm{Top}_k(\xi, x)`$ is visible only if its first argument satisfies $`\xi \lt \eta`$. A larger $`(k, \eta)`$ sees more symbols, so the relation is stronger.
4. **The relations $`\mathrm{Rel}_j`$ between points ([03](03-sigma1-elementary.md) §7) are present for every layer.** $`\mathrm{Rel}_j(x, y, z) :\iff R(j, x, y, z)`$ for every $`j`$.
5. **The recursion key ([02](02-well-founded.md) §4) is $`(b, k, \eta)`$.** The top $`b`$ is the outermost component ([02](02-well-founded.md) §3).

The resulting relation $`R`$ is not Carlson's $`\mathcal R_N`$ itself, and we do not claim that it coincides with $`\mathcal R_N`$. The definition is given in [07 The relation R](07-relation-r.md).

| | $`\mathcal R_N`$ (bms-elem-pattern) | $`R`$ of this repository |
|---|---|---|
| levels | $`j = 1, \ldots, N`$ | $`(k, \eta) \in \mathbb N \times \mathrm{Ord}`$ |
| strength of a level | $`\Sigma_j`$ quantifiers | range of visible top predicates |
| formulas | $`\Sigma_1, \ldots, \Sigma_N`$ | $`\Sigma_1`$ only |
| relation to the top | lemmas on continuity and cofinality | atomic symbols $`\mathrm{Top}_j`$ |
| recursion key | the top $`\beta`$ | lexicographic order on $`(b, k, \eta)`$ |

## 6. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Shape of the proof" | this is the 1-Y version of bms-elem-pattern; the levels are arranged like $`\omega \times \omega_1`$ |
| [notes/01-design.md](../../notes/01-design.md) §1, §3.8 (Japanese) | reasons for the design |
| [notes/01-design.md](../../notes/01-design.md) §6.3 (Japanese) | what was taken from bms-elem-pattern (the shape of the recursion and more) |
