[← Back](README.md) | [English](07-relation-r.md) | [Japanese](../07-relation-r.md)

# The relation R

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | lexicographic order, well-founded recursion, guarded recursion |
| [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md) | height, point, witness, 5-tuples for $`\Sigma_1`$ formulas and the matrix, top, top predicate (§7), position, visible bits $`\mathrm{allow}_{k,S}`$ and the way two structures are compared (§8) |
| [04 Patterns of resemblance](04-patterns-of-resemblance.md) | the idea of making top predicates atomic symbols |
| [06 Phyrion's combinatorial layer](06-combinatorial-layer.md) | layer, edge, demand, representation, the role of $`R(k, \eta, a, b)`$, strictness and weakening among the six hypotheses |

This note explains the definition of the label relation $`R`$ of this repository and the properties that follow directly from it.

## 1. Notation

- $`\mathrm{Ord}`$: all ordinals.
- Lexicographic order on $`\mathbb N \times \mathrm{Ord}`$: $`(j, \xi) \prec (k, \eta) \iff j \lt k \lor (j = k \land \xi \lt \eta)`$.
- $`R(k, \eta, a, b)`$: layer $`k \in \mathbb N`$, root index ([06](06-combinatorial-layer.md) §2) $`\eta \in \mathrm{Ord}`$, lower point $`a \in \mathrm{Ord}`$, upper point $`b \in \mathrm{Ord}`$. $`R`$ is defined in §4. §2 and §3 use $`R`$ in the interpretations of symbols. As §5 explains, this use is not circular.

## 2. The language

There are three kinds of symbols.

| Symbol | Arity | Meaning (in the structure of height $`\gamma`$) |
|---|---|---|
| $`\lt`$ | 2 | order of ordinals |
| $`\mathrm{Rel}_j`$ ($`j \in \mathbb N`$) | 3 | $`\mathrm{Rel}_j(x, y, z) :\iff R(j, x, y, z)`$ |
| $`\mathrm{Top}_j`$ ($`j \in \mathbb N`$) | 2 | $`\mathrm{Top}_j(\xi, x) :\iff R(j, \xi, x, \gamma)`$ |

$`\mathrm{Rel}_j`$ relates points to points, and $`\mathrm{Top}_j`$ relates a point to the top $`\gamma`$ (a top predicate) ([03](03-sigma1-elementary.md) §7). $`\gamma`$ itself is not in the domain.

We call the interpretations of the table the **true interpretations**, to distinguish them from the stage interpretations of §5. The true interpretation of the top predicates depends on the height $`\gamma`$.

## 3. The structure of level (k, η)

**Definition (level).** A pair $`(k, \eta) \in \mathbb N \times \mathrm{Ord}`$ is called a **level**. $`k`$ is the layer and $`\eta`$ the root index. The level decides which top predicates the structure has. Levels are compared by the lexicographic order $`\prec`$ of §1. A level is unrelated to the "one step" of a one-step expansion ([05](05-1y-mountain.md) §7).

**Definition (the structure of level (k, η)).** For an ordinal $`\gamma`$, the structure of height $`\gamma`$ and level $`(k, \eta)`$ is the following. Its domain is $`\{x \mid x \lt \gamma\}`$.

```math
\mathfrak A^{\gamma}_{k,\eta} = \bigl(\gamma;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,\xi})_{\xi \lt \eta}\bigr)
```

- $`\mathrm{Rel}_j`$ is present for every layer $`j`$.
- $`\mathrm{Top}_j`$ ($`j \lt k`$) is a **diagonal top predicate**. "Diagonal" means that the root index $`\xi`$ is not fixed inside the symbol but is taken as the first argument. So the first argument can be an ordinary variable (a parameter or a witness).
- $`\mathrm{Top}_{k,\xi}(x) :\iff R(k, \xi, x, \gamma)`$ is a **named top predicate**. There is one symbol of arity 1 for each $`\xi \lt \eta`$. $`\xi`$ is called the **name** of this symbol.
- There are no top predicates with $`j \gt k`$.

A **formula of level $`(k, \eta)`$** is a $`\Sigma_1`$ formula of the language of this structure.

**Representation by positions.** A named $`\mathrm{Top}_{k,\xi}(x)`$ is represented as $`\mathrm{Top}_k(p_s, x)`$ of arity 2 whose first argument is at a parameter position $`s`$ ([03](03-sigma1-elementary.md) §8). A formula comes with a set $`S \subseteq \mathbb N`$ of positions, and $`s \in S`$ requires $`s \lt r`$ and $`p_s \lt \eta`$. Here $`r`$ is the number of parameters (the $`r`$ of the 5-tuple of [03](03-sigma1-elementary.md) §7). The visible bits are decided by $`\mathrm{allow}_{k,S}`$ ([03](03-sigma1-elementary.md) §8).

```math
\mathrm{allow}_{k,S}(j, s) \iff j \lt k \ \lor\ (j = k \land s \in S)
```

**Example.** At level $`(2, \omega)`$, consider

```math
\exists y\ \bigl(p_0 \lt y \land \mathrm{Top}_1(y, y) \land \mathrm{Top}_{2, p_0}(y)\bigr)
```

- $`\mathrm{Top}_1(y, y)`$ is diagonal ($`1 \lt 2`$), so its first argument may be the witness $`y`$.
- $`\mathrm{Top}_{2, p_0}(y)`$ is named; position 0 goes into $`S`$. This needs $`p_0 \lt \omega`$.
- $`\mathrm{Top}_2(y, y)`$ and $`\mathrm{Top}_3(p_0, y)`$ cannot be written at this level (reading them gives false).

## 4. The definition

**Definition (R).**

```math
R(k, \eta, a, b) \iff \eta \le a \ \land\ a \lt b \ \land\ \mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}
```

Here $`\mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}`$ means that for every $`\Sigma_1`$ formula $`\varphi`$ of level $`(k, \eta)`$ and all parameters $`\vec p \lt a`$ (with $`p_s \lt \eta`$ at the positions $`s \in S`$ (§3) used for names),

```math
\mathfrak A^{a}_{k,\eta} \models \varphi(\vec p) \iff \mathfrak A^{b}_{k,\eta} \models \varphi(\vec p)
```

We write $`\mathrm{Elem}(k, \eta, a, b)`$ for this comparison (with the true interpretations). The top predicates of the two structures are different ($`R`$ to $`a`$ and $`R`$ to $`b`$) (Difference 1 of [03](03-sigma1-elementary.md) §8).

About the condition $`\eta \le a`$: atoms and demands all have "root $`\le`$ parent" ([06](06-combinatorial-layer.md) §1, §3), so in a representation (whose labels increase) it always holds.

## 5. The recursion

The right side reads $`R`$ itself. We use well-founded recursion on the lexicographic order $`\lhd`$ of keys $`(b, k, \eta)`$ ([02](02-well-founded.md) §3), defining all $`a`$ at once.

**What the right side reads.** Only three kinds, all with smaller keys. In the table, $`\mathfrak A^{a}`$ and $`\mathfrak A^{b}`$ abbreviate $`\mathfrak A^{a}_{k,\eta}`$ and $`\mathfrak A^{b}_{k,\eta}`$.

| What is read | Key | Why smaller |
|---|---|---|
| $`\mathrm{Rel}_j(x, y, z)`$ | $`(z, j, x)`$ | the points are below the height ($`a`$ or $`b`$), so $`z \lt b`$ |
| a top predicate $`\mathrm{Top}_j(\xi, x)`$ of $`\mathfrak A^{a}`$ | $`(a, j, \xi)`$ | $`a \lt b`$ |
| a visible top predicate of $`\mathfrak A^{b}`$ | $`(b, j, \xi)`$ | $`j \lt k`$, or $`j = k`$ and $`\xi \lt \eta`$ |

**Guarded recursion.** The value at key $`t = (b, k, \eta)`$ is the set of $`a`$ with $`R(k, \eta, a, b)`$. It is defined with the following **stage interpretations**. The superscript $`\mathrm{st}`$ marks a stage interpretation. Each of the three contains, as a guard, the condition that the key is smaller ([02](02-well-founded.md) §5).

| Stage interpretation | Formula |
|---|---|
| $`\mathrm{Rel}^{\mathrm{st}}_j(x, y, z)`$ | $`z \lt b \land R(j, x, y, z)`$ |
| $`\mathrm{Top}^{\mathrm{st},a}_j(\xi, x)`$ | $`a \lt b \land R(j, \xi, x, a)`$ |
| $`\mathrm{Top}^{\mathrm{st},b}_j(\xi, x)`$ | $`(j, \xi) \prec (k, \eta) \land R(j, \xi, x, b)`$ |

Write $`\mathrm{Elem}^{\mathrm{st}}(k, \eta, a, b)`$ for $`\Sigma_1`$-elementarity with the stage interpretations. The stage interpretations read $`R`$ only at smaller keys, so the well-founded recursion of [02](02-well-founded.md) §4 determines $`R`$. The defining equation is the following guarded equation.

```math
R(k, \eta, a, b) \iff \eta \le a \land a \lt b \land \mathrm{Elem}^{\mathrm{st}}(k, \eta, a, b)
```

## 6. Removing the guards

**Lemma (removing the guards).** If $`a \lt b`$, then $`\mathrm{Elem}^{\mathrm{st}}(k, \eta, a, b) \iff \mathrm{Elem}(k, \eta, a, b)`$. That is, $`\Sigma_1`$-elementarity for the stage interpretations is equivalent to $`\Sigma_1`$-elementarity for the true interpretations.

**Proof.** Show that the guards are true on every bit a formula of level $`(k, \eta)`$ reads.

1. $`\mathrm{Rel}`$ bits: the points are parameters ($`\lt a`$) or witnesses ($`\lt`$ height $`\le b`$). So $`z \lt b`$.
2. Top predicates at height $`a`$: the guard is $`a \lt b`$, which is the assumption.
3. Visible top predicates at height $`b`$: by $`\mathrm{allow}_{k,S}`$, either $`j \lt k`$, or $`j = k`$ and the position is in $`S`$, in which case the value is $`p_s \lt \eta`$. In both cases $`(j, \cdot) \prec (k, \eta)`$.

Invisible bits are false in both interpretations. So by Lemma 1 of [03](03-sigma1-elementary.md) §8 the atomic diagrams are equal and so are the truth values. $`\square`$

**Theorem (defining equation).**

```math
R(k, \eta, a, b) \iff \eta \le a \land a \lt b \land \mathrm{Elem}(k, \eta, a, b)
```

**Proof.** Apply the lemma (removing the guards) under $`a \lt b`$ to the guarded equation of §5. $`\square`$

## 7. Properties that follow directly

**Theorem (strictness).** $`R(k, \eta, a, b)`$ implies $`a \lt b`$. This is the second condition on the right side of the defining equation. It is the strictness of [06](06-combinatorial-layer.md) §5.

**Theorem (lower bound of the index).** $`R(k, \eta, a, b)`$ implies $`\eta \le a`$. This is the first condition on the right side of the defining equation.

**Theorem (weakening).** If $`\eta' \le \eta`$ and $`R(k, \eta, p, c)`$, then $`R(k, \eta', p, c)`$.

**Proof.** $`\eta' \le \eta \le p`$ and $`p \lt c`$ are clear. A formula of level $`(k, \eta')`$ has names $`\lt \eta' \le \eta`$, so it is also a formula of level $`(k, \eta)`$. The two levels interpret the visible symbols in the same way. So agreement at $`(k, \eta)`$ gives agreement at $`(k, \eta')`$. In the representation by positions (§3), the name condition $`p_s \lt \eta'`$ gives $`p_s \lt \eta`$. $`\square`$

The weakening of [06](06-combinatorial-layer.md) §5 asks only for the case $`\eta' \lt \eta`$. Since $`\eta' \lt \eta`$ implies $`\eta' \le \eta`$, it follows from this theorem.

**Property (visible top predicates agree).** Let $`R(k, \eta, a, b)`$ and $`\xi, x \lt a`$. If $`j \lt k`$, or $`j = k`$ and $`\xi \lt \eta`$, then

```math
R(j, \xi, x, a) \iff R(j, \xi, x, b)
```

**Reason.** Use the quantifier-free formula $`\mathrm{Top}_j(p_0, p_1)`$ with parameters $`(\xi, x)`$ (if $`j = k`$, put position 0 into $`S`$). At height $`a`$ it means the left side, at height $`b`$ the right side. The proof does not use this property. It uses the theorem (absoluteness of the top predicates) of [09](09-obligations.md) §4.1, which has a similar form: the top predicates agree between a Good point and $`\omega_1`$.

**Property (the lower point is a limit ordinal).** $`R(k, \eta, a, b)`$ implies that $`a`$ is a nonzero limit ordinal.

**Reason.** As in the example of [03](03-sigma1-elementary.md) §5.

- If $`a = 0`$: $`\exists y\ \neg(y \lt y)`$ ($`m = 0`$, $`n = 1`$, $`\mathit{bb} = 1`$, $`r = 0`$, the matrix is the set of complete atomic diagrams with $`[v_0 \lt v_0] = 0`$) is true at height $`b`$ and false at height 0.
- If $`a = \gamma + 1`$: $`\exists y\ (\gamma \lt y)`$ with parameter $`\gamma \lt a`$ is true at height $`b`$ ($`y = \gamma + 1 \lt b`$) and false at height $`a`$.

Both contradict $`\mathrm{Elem}`$. The combinatorial layer does not use this property.

## 8. Properties that are not used

The following properties are expected to hold but are not proved here. The combinatorial layer does not use them ([notes/01-design.md](../../notes/01-design.md) §4.11, Japanese).

- Transitivity: $`R(k, \eta, a, b) \land R(k, \eta, b, c) \implies R(k, \eta, a, c)`$.
- Monotonicity in the index: if $`(k, \eta) \preceq (k', \eta')`$ ($`\prec`$ or equal), $`\eta \le a`$ and $`R(k', \eta', a, b)`$, then $`R(k, \eta, a, b)`$.
- Locality: $`R`$ with top $`\le \delta`$ is determined by the recursion below $`\delta + 1`$.

## 9. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "The relation R" | the defining equation and the three kinds of reads in the recursion |
| [README](../../README-en.md) "Where the six hypotheses go" | strictness and weakening follow from the two theorems of §7 |
| [notes/01-design.md](../../notes/01-design.md) §3.3–§3.8, §4.1–§4.4 (Japanese) | definition, recursion, defining equation, O3, O4 |
