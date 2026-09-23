[← Back](README.md) | [English](01-ordinals.md) | [Japanese](../01-ordinals.md)

# Ordinals and ω₁

Prerequisites: none

This note explains the ordinals used as labels and the ordinal $`\omega_1`$ used as a bound for the labels. The facts that are used are the regularity in §5 and the enumeration in §6.

## 1. Well-orders and ordinals

**Definition (well-order).** A linear order $`\lt`$ on a set $`X`$ is a **well-order** if every nonempty subset of $`X`$ has a least element.

**Definition (infinite descending sequence).** A sequence $`(x_n)_{n \in \mathbb N}`$ with $`x_0 \gt x_1 \gt x_2 \gt \cdots`$ is an **infinite descending sequence**.

A linear order is a well-order if and only if it has no infinite descending sequence. The direction "no infinite descending sequence implies well-order" uses a weak form of the axiom of choice (dependent choice).

| Order | Well-order? | Reason |
|---|---|---|
| $`(\mathbb N, \lt)`$ | yes | every nonempty subset has a least element |
| $`(\mathbb Z, \lt)`$ | no | $`0 \gt -1 \gt -2 \gt \cdots`$ |
| $`(\mathbb Q_{\ge 0}, \lt)`$ | no | $`1 \gt 1/2 \gt 1/4 \gt \cdots`$ |

**Definition (ordinal).** An **ordinal** is the order type of a well-order. We identify an ordinal $`\alpha`$ with the set $`\{\beta \mid \beta \lt \alpha\}`$ of smaller ordinals.

In increasing order:

```math
0,\ 1,\ 2,\ \ldots,\ \omega,\ \omega+1,\ \omega+2,\ \ldots,\ \omega \cdot 2,\ \ldots,\ \omega^2,\ \ldots
```

- $`\omega`$ is the order type of the natural numbers. $`\omega = \{0, 1, 2, \ldots\}`$.
- The ordinals are well-ordered by $`\lt`$. Every collection of ordinals has a least element.

In Lean the type of ordinals is `Ordinal.{0}`. This repository calls it `Por.Ord` ([Por/Tuple.lean](../../Por/Tuple.lean)). The set $`\{\beta \mid \beta \lt \gamma\}`$ is `Set.Iio γ`.

## 2. Successors and limits

**Definition (successor).** $`\alpha + 1`$ is the ordinal right after $`\alpha`$. In Lean it is `Order.succ α`. An ordinal of the form $`\alpha + 1`$ is a **successor ordinal**.

**Definition (limit ordinal).** An ordinal that is neither 0 nor a successor ordinal is a **limit ordinal**.

| Ordinal | Kind |
|---|---|
| $`0`$ | neither |
| $`5`$, $`\omega+1`$, $`\omega \cdot 2 + 3`$ | successor |
| $`\omega`$, $`\omega \cdot 2`$, $`\omega^2`$ | limit |

**Property.** If $`\alpha`$ is a limit ordinal and $`\beta \lt \alpha`$, then $`\beta + 1 \lt \alpha`$. So above $`\beta`$ there are infinitely many elements below $`\alpha`$.

This property is used in an example of [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md).

## 3. Suprema

**Definition (supremum).** The **supremum** $`\sup S`$ of a set $`S`$ of ordinals is the least ordinal that is $`\ge`$ every element of $`S`$.

- If $`S`$ has a largest element, $`\sup S`$ is that element. This is always the case for a nonempty finite set. The supremum of the empty set is $`0`$.
- If $`S`$ has no largest element, $`\sup S`$ is not in $`S`$.

| $`S`$ | $`\sup S`$ |
|---|---|
| $`\{2, 5, 3\}`$ | $`5`$ |
| $`\{0, 1, 2, \ldots\}`$ | $`\omega`$ |
| $`\{\omega, \omega+1, \omega+2, \ldots\}`$ | $`\omega \cdot 2`$ |

To get an ordinal strictly above all $`y_i`$, use $`\sup_{i} (y_i + 1)`$. Indeed $`y_i \lt y_i + 1 \le \sup_i (y_i + 1)`$. The function `witHeight` of [08 Closure and chain](08-closure-chain.md) has this form.

In Lean an indexed supremum is `⨆ i, f i` (`iSup`), and the supremum over a finite set is `Finset.sup`.

## 4. Countability and ω₁

**Definition (countable).** A set $`X`$ is **countable** if $`X`$ is empty or there is a surjection $`\mathbb N \to X`$. In Lean this is `Set.Countable`.

**Definition (countable ordinal).** An ordinal $`\alpha`$ is **countable** if $`\{\beta \mid \beta \lt \alpha\}`$ is countable.

$`0, 1, \omega, \omega+1, \omega \cdot 2, \omega^2, \omega^\omega, \varepsilon_0`$ are all countable.

**Definition (ω₁).** $`\omega_1`$ is the least uncountable ordinal. So the ordinals below $`\omega_1`$ are exactly the countable ordinals.

```math
\alpha \lt \omega_1 \iff \alpha \text{ is countable}
```

In Lean it is `ω₁`, and this repository calls it `Por.Om` ([Por/Omega1.lean](../../Por/Omega1.lean)). Three facts are used.

| Name | Statement |
|---|---|
| `om_pos` | $`0 \lt \omega_1`$ |
| `om_succ_lt` | $`\alpha \lt \omega_1 \implies \alpha + 1 \lt \omega_1`$ |
| `countable_Iio` | $`\gamma \lt \omega_1 \implies \{\beta \mid \beta \lt \gamma\}`$ is countable |

Reason for `om_succ_lt`: $`\{\beta \mid \beta \lt \alpha + 1\} = \{\beta \mid \beta \lt \alpha\} \cup \{\alpha\}`$, and a countable set with one more point is countable. The Lean proof uses the fact that $`\omega_1`$ is a limit ordinal.

## 5. Regularity of ω₁

**Theorem (regularity of ω₁).** If $`\alpha_n \lt \omega_1`$ for every $`n \in \mathbb N`$, then

```math
\sup_{n \in \mathbb N} \alpha_n \lt \omega_1
```

The index set need not be $`\mathbb N`$. Any countable index set works.

**Proof.** Let $`\sigma := \sup_n \alpha_n`$. If $`\beta \lt \sigma`$, then $`\beta \lt \alpha_n`$ for some $`n`$. So

```math
\{\beta \mid \beta \lt \sigma\} = \bigcup_{n} \{\beta \mid \beta \lt \alpha_n\}
```

The right side is a countable union of countable sets. The terms with $`\alpha_n = 0`$ add nothing to the union, so drop them. For each remaining $`n`$ choose a surjection $`e_n : \mathbb N \to \alpha_n`$. Then $`(n, t) \mapsto e_n(t)`$ is a surjection from $`\mathbb N \times \mathbb N`$ onto the union. Since $`\mathbb N \times \mathbb N`$ is countable, so is the union. Hence $`\sigma`$ is countable and $`\sigma \lt \omega_1`$. $`\square`$

- Choosing countably many surjections $`e_n`$ at once uses the axiom of choice (countable choice).
- The statement fails for an uncountable index set. For example $`\sup_{\alpha \lt \omega_1} \alpha = \omega_1`$.

In Lean it is `Ordinal.iSup_lt_omega_one`. The index type needs a `Countable` instance. This repository uses it in two places.

| Place | Index type | Supremum of |
|---|---|---|
| `next_lt` ([Por/Closure.lean](../../Por/Closure.lean)) | `Form × List ℕ` | witness heights |
| `lam_lt` (same file) | `ℕ` | the closure tower |

## 6. Enumerating a countable ordinal

If $`0 \lt \gamma \lt \omega_1`$, the set $`\{\beta \mid \beta \lt \gamma\}`$ is nonempty and countable, so there is a surjection $`e_\gamma : \mathbb N \to \gamma`$. Lean chooses one and calls it `enumBelow γ` (using `Classical.choose`).

**Theorem (`enumBelow_surj`).** If $`\gamma \lt \omega_1`$ and $`a \lt \gamma`$, then $`e_\gamma(t) = a`$ for some $`t \in \mathbb N`$.

With this, finitely many parameters below $`\gamma`$ can be written as a finite list of natural numbers.

**Definition (`params`).** For a list of natural numbers $`l = (l_0, l_1, \ldots)`$, let $`\mathrm{params}_\gamma(l)(i) := e_\gamma(l_i)`$ (outside the list, read $`l_i := 0`$).

**Theorem (`exists_params`).** If $`\gamma \lt \omega_1`$ and $`p_0, \ldots, p_{k-1} \lt \gamma`$, then there is a list $`l`$ of natural numbers with $`\mathrm{params}_\gamma(l)(i) = p_i`$ for all $`i \lt k`$.

**Example.** Let $`\gamma = \omega + 1`$, and suppose the chosen enumeration is $`e_\gamma(0) = \omega`$, $`e_\gamma(t+1) = t`$. The parameters $`(3, \omega, 0)`$ are given by $`l = (4, 0, 1)`$.

**Why it is needed.** In [08 Closure and chain](08-closure-chain.md) we take a supremum over all formulas with parameters below $`\gamma`$. Instead of running over tuples of ordinals, we run over lists $`l`$ of natural numbers. Then the index type is the countable type `Form × List ℕ`, which does not depend on $`\gamma`$, and the theorem of §5 applies directly.

## 7. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "The relation R" | labels are ordinals, the order is $`\lt`$ |
| [README](../../README-en.md) "Where the six hypotheses go" | `hWF` is `Ordinal.lt_wf`, `hTrans` is `h₁.trans h₂` |
| [notes/01-design.md](../../notes/01-design.md) §3.6, §4.7 (Japanese) | $`\omega_1`$, `enumBelow`, closure points lie below $`\omega_1`$ |
| [Por/Omega1.lean](../../Por/Omega1.lean) | §4 and §6 of this note |
| [Por/Closure.lean](../../Por/Closure.lean) | regularity of §5 (`next_lt`, `lam_lt`) |

## 8. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| type of ordinals | `Por.Ord` (`Ordinal.{0}`) | [Por/Tuple.lean](../../Por/Tuple.lean) |
| $`\lt`$ is well-founded | `Ordinal.lt_wf`, `wellFounded_lt` | Mathlib |
| successor | `Order.succ` | Mathlib |
| supremum | `iSup`, `Finset.sup` | Mathlib |
| $`\omega_1`$ | `Por.Om` (`ω₁`) | [Por/Omega1.lean](../../Por/Omega1.lean) |
| $`0 \lt \omega_1`$ | `om_pos` | same |
| closed under successor | `om_succ_lt` | same |
| below a countable ordinal is countable | `countable_Iio` | same |
| regularity | `Ordinal.iSup_lt_omega_one` | Mathlib |
| enumeration | `enumBelow`, `enumBelow_surj` | [Por/Omega1.lean](../../Por/Omega1.lean) |
| coding parameters | `params`, `exists_params` | same |
